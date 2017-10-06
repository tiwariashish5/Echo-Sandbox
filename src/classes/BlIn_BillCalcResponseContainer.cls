/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		01 Sep 2017
@description 	Container class for JSON billing response
*******************************************************************************/
public with sharing class BlIn_BillCalcResponseContainer {

	public static final String CLASS_NAME = 'BlIn_BillCalcResponseContainer';
	public static final String DEBUG = '[' + CLASS_NAME + '] ';
	
	// Bill Calculation
	public String Status;
	public List<BlIn_BillCalcResponseBillObj> Bills;

	// Bill
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		01 Sep 2017
	@description 	Subclass for Bill JSON Object
	*******************************************************************************/
	public class BlIn_BillCalcResponseBillObj {

		public String Id;
		public String Name;
		public String AccountId;
		public String ContractId;
		public String ContractGroupId;
		public String OriginalBillId;
		public String BilledAmount;
		public String TotalDue;
		public List<BlIn_BillCalcResponseBillServiceTypeObject> BillServiceTypes;
	}

	// Bill Services
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		20 Sep 2017
	@description 	Subclass for Bill Services Type JSON Object
	*******************************************************************************/
	public class BlIn_BillCalcResponseBillServiceTypeObject {

		public String Id;
		public String Name;
		public String ServiceTypeId;
		public List<BlIn_BillCalcResponseBillItemObject> BillItems;
	}
    
	// Bill Items
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		01 Sep 2017
	@description 	Subclass for Bill Item JSON Object
	*******************************************************************************/
	public class BlIn_BillCalcResponseBillItemObject {

		public String Id;
		public String Name;
		public String ServiceItemId;		// Required
		public String BillItemId; 
		public String RateBandId; 
		public String ReadingId; 
		public String VolumeUsed;
		public String ChargeBasisValue;
		public String FromDate;
		public String ToDate;
		public String BilledAmount;
	}
    
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		01 Sep 2017
	@param			String - json
	@return			BlIn_BillCalcResponseContainer - formatted billing object
	@description 	parses and formats the JSON response 
	*******************************************************************************/
    public static BlIn_BillCalcResponseContainer parse(String json) {

        return (BlIn_BillCalcResponseContainer) System.JSON.deserialize(json, BlIn_BillCalcResponseContainer.class);
    }
    
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		20 Sep 2017
	@param			Id - bill calculation Id
	@param			BlIn_BillCalcResponseContainer - formatted billing object
	@return			List<Id> - bill Ids (null if the bill result was not ready)
	@description 	builds and inserts the records 
	*******************************************************************************/
    public static List<Id> processResult(Id billCalculationId, BlIn_BillCalcResponseContainer result) {	

		system.debug(DEBUG + 'result: ' + result);
		
		// TO-DO - temp for debug
		String rand = String.valueOf(Datetime.now());
		Id accountId;
		Id contractId;
		for (BillCalculation__c billcalculation : [select Id, (select Id, CustomerName__c from Contracts__r) from BillCalculation__c where Id = :billCalculationId]) {
			for (Contract__c contract : billcalculation.Contracts__r) {
				contractId = contract.Id;
				accountId = contract.CustomerName__c;
				break;
			}
			break;
		}
		// END temp for debug
		
    	if (result.Status == BlIn_Constants.BILL_CALCULATION_STATUS_COMPLETED) {
			List<Bill__c> billsInserted = new List<Bill__c>();
    		
    		List<SObject> recordsToInsert = new List<SObject>();
    		for (BlIn_BillCalcResponseBillObj billObj : result.Bills) {
    			
    			Bill__c billReference = new Bill__c(HerokuPostgresId__c = billObj.Id + rand);
    			Bill__c bill = (new Bill__c(
	   										Name = billObj.Name, 
											BillCalculation__c = (Id)billCalculationId, 
											HerokuPostgresId__c = billObj.Id + rand, 
											BillDate__c = Date.today(),		// TO-DO
											CustomerNumber__c = accountId,		//(Id)billObj.AccountId, 
											ContractNumber__c = contractId,		//(Id)billObj.ContractId, 												
//											ContractGroup__c = (Id)billObj.ContractGroupId, 
//											OriginalBill__c = (Id)billObj.OriginalBillId, 
											BilledAmount__c = Decimal.valueOf(billObj.BilledAmount), 
											TotalDue__c = Decimal.valueOf(billObj.TotalDue)
											)
									);
    			recordsToInsert.add(bill);

				// add the bill to the list of bills inserted				
				billsInserted.add(bill);
				
				for (BlIn_BillCalcResponseBillServiceTypeObject billServiceTypeObj : billObj.BillServiceTypes) {
					
	    			BillServiceType__c billServiceTypeReference = new BillServiceType__c(HerokuPostgresId__c = billServiceTypeObj.Id + rand);
    				recordsToInsert.add(new BillServiceType__c(
    															Name = billServiceTypeObj.Name, 
																Bill__r = billReference, 
																HerokuPostgresId__c = billServiceTypeObj.Id + rand//, 
//																ServiceType__c = (Id)billServiceTypeObj.ServiceTypeId 
																)
										);

					for (BlIn_BillCalcResponseBillItemObject billItemObj : billServiceTypeObj.BillItems) {
						
    					recordsToInsert.add(new BillItem__c(
    														Name = billItemObj.Name, 
    														BillServiceType__r = billServiceTypeReference, 
															HerokuPostgresId__c = billItemObj.Id + rand, 
															ServiceItem__c = (Id)billItemObj.ServiceItemId, 
//															BillItem__c = (Id)billItemObj.BillItemId, 
//															RateBand__c = (Id)billItemObj.RateBandId, 
//															Reading__c = (Id)billItemObj.ReadingId, 
															VolumeUsed__c = Integer.valueOf(billItemObj.VolumeUsed), 
															From__c = Date.valueOf(billItemObj.FromDate), 
															To__c = Date.valueOf(billItemObj.ToDate), 
															BilledAmount__c = Decimal.valueOf(billItemObj.BilledAmount)
															)
											);
					}
				}
				
    		}
    		
    		// save the records
			Database.SaveResult[] results = Database.insert(recordsToInsert);

			// and check the results
			for (Integer i = 0; i < results.size(); i++) {

				if (results[i].isSuccess()) {
					System.debug(DEBUG + 'Created record with Id: ' + results[i].getId());

				} else {
					System.debug(DEBUG + 'Error: could not create record ' + 'for array element ' + i + '.');
					System.debug('The error reported was: ' + results[i].getErrors()[0].getMessage() + '\n');
    				return null;
				}
			}
			
			// return a list of the Ids of the bill records inserted
			List<Id> billIds = new List<Id>();
			for (Bill__c bill : billsInserted) {
				billIds.add(bill.Id);
			}
			return billIds;
    	}
    	return null;
    }
}
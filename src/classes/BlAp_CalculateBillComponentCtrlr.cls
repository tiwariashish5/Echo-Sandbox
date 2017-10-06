/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		06 Sep 2017
@description 	Component controller for calculate bill lightning component
*******************************************************************************/
public with sharing class BlAp_CalculateBillComponentCtrlr {
	
	public static final String CLASS_NAME = 'BlAp_CalculateBillComponentCtrlr';
	public static final String DEBUG = '[' + CLASS_NAME + '] ';
	/*
	
	hasBillingBasisChanged set from triggers on readings/rates/discounts/etc updates or additions
	when hasBillingBasisChanged is set, any BillCalculation records with Status 'Pending' will be changed to Status 'Void'
	
	Contract lookup to BillCalculation, Bill lookup to BillCalculation.
	
	*/
	
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		11 Sep 2017
	@param			Id - contract Id
	@return			Contract__c - contract record
	@description 	Method called to return the contract record
	*******************************************************************************/
	@AuraEnabled
	public static Contract__c getContract(Id contractId) {
		
		// get the associated contract
		for (Contract__c contract : [select Id, 
//											HasBillingBasisChanged__c, 
											LastBillCalculationDate__c, 
											
											(select Id 
											from Bills__r 
											order by BillDate__c desc
											limit 1), 
											
											BillCalculation__c, 
											BillCalculation__r.Status__c, 
											BillCalculation__r.RequestDate__c
									from Contract__c 
									where Id = :contractId
									]) {
			return contract;
		}
		return null;
	}

	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		19 Sep 2017
	@param			Id - contract record Id
	@return			Id - bill Id (null if new bill required)
	@description 	Returns the most recent bill Id or null if a new bill is required
	*******************************************************************************/
	@AuraEnabled
	public static Id getBillId(Id contractId) {

		Id billId;
		try {

			// get the contract record
			Contract__c contract = getContract(contractId);
			System.debug(DEBUG + 'contract: ' + contract);

			Id mostRecentBillId;
			for (Bill__c bill : contract.Bills__r) {
				mostRecentBillId = bill.Id;
				break;
			}
			
			// check if we should calculate a new bill at all
			if (!(mostRecentBillId == null 
					|| contract.LastBillCalculationDate__c == null 
					|| contract.LastBillCalculationDate__c < Date.today())) {		//|| contract.HasBillingBasisChanged__c) {
				
				// new bill not required so return most recent bill Id
				billId = mostRecentBillId;
			}

		} catch (exception e) {
			throw new AuraHandledException(e.getMessage());
		}
		return billId;
	}

	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		19 Sep 2017
	@param			Id - contract record Id
	@return			BillCalculation__c - bill calculation record Id
	@description 	Initiates a new bill request by creating a new bill calculation record 
					or returning a valid existing pending bill calculation record
	*******************************************************************************/
	@AuraEnabled
	public static BillCalculation__c initiateBillRequest(Id contractId) {

		BillCalculation__c billCalculation;
		try {

			// get the contract record
			Contract__c contract = getContract(contractId);
			System.debug(DEBUG + 'contract: ' + contract);
		
			// check for a live new or pending bill calculation
			if ((contract.BillCalculation__r.Status__c == BlIn_Constants.BILL_CALCULATION_STATUS_NEW
					|| contract.BillCalculation__r.Status__c == BlIn_Constants.BILL_CALCULATION_STATUS_PENDING)
					&& contract.BillCalculation__r.RequestDate__c >= Date.today()) {
						
				billCalculation = new BillCalculation__c(
														Id = contract.BillCalculation__c, 
														Status__c = contract.BillCalculation__r.Status__c, 
														RequestDate__c = contract.BillCalculation__r.RequestDate__c
														);
														
			// check for a live errored bill calculation
			} else if (contract.BillCalculation__r.Status__c == BlIn_Constants.BILL_CALCULATION_STATUS_ERROR
					&& contract.BillCalculation__r.RequestDate__c >= Date.today()) {
						
				// TO-DO - throw exception and display error message to user
				throw new AuraHandledException('An error has occured: please contact the System Administrator');
						
			// no live new or pending calculation found so initiate a new request
			} else {
				
				System.debug(DEBUG + 'DML: Insert bill calculation');
					
				// create a new bill calculation record
				billCalculation = new BillCalculation__c(
														Status__c = BlIn_Constants.BILL_CALCULATION_STATUS_NEW,
														RequestDate__c = Date.today()
														);

				insert billCalculation;

				// and link it to the contract
				contract.BillCalculation__c = billCalculation.Id;
				update contract;
			}

		} catch (exception e) {
			throw new AuraHandledException(e.getMessage());
		}
		return billCalculation;
	}

	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		11 Sep 2017
	@param			BillCalculation__c - new bill calculation record
	@return			Boolean - request sucessful
	@description 	Method called to request a new bill calculation
	*******************************************************************************/
	@AuraEnabled
	public static Boolean requestNewBill(BillCalculation__c billCalculation) {
		
		try {

			// make bill calculation request callout
			BlIn_ExecuteBillCalculation.requestBillCalculation(billCalculation.Id);

			System.debug(DEBUG + 'DML: update bill calculation');

			// update the bill calculation status
			billCalculation.Status__c = BlIn_Constants.BILL_CALCULATION_STATUS_PENDING;
			update billCalculation;
			return true;
			
		} catch (exception e) {
			throw new AuraHandledException(e.getMessage());
		}
		return true;
	}

	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		11 Sep 2017
	@param			BillCalculation__c - bill calculation record
	@return			Id - bill Id (null if bill result not ready)
	@description 	Method called to fetch a bill calculation result
	*******************************************************************************/
	@AuraEnabled
	public static Id getNewBill(BillCalculation__c billCalculation) {
		
		Id billId;
//		return null;
//		try {
		
			// callout to get the result and the bill Id
			for (Id insertedBillId : BlIn_ExecuteBillCalculation.getBillCalculationResult(billCalculation.Id)) {

				// we are only creating one bill from this component
				billId = insertedBillId;
				break;
			}

			// got a bill result
			if (billId != null) {

				// set bill calculation record 'Completed'
				billCalculation.Status__c = BlIn_Constants.BILL_CALCULATION_STATUS_COMPLETED;
				update billCalculation;
			}

//		} catch (exception e) {
//			throw new AuraHandledException(e.getMessage());
//		}
		return billId;
	}
}
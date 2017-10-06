/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		21 Sep 2017
@description 	Handler for Bill trigger
*******************************************************************************/
public with sharing class GlUt_BillHandler extends GlUt_TriggerHandlerBase {
	
	// Maps of the related records that will be updated by this trigger
	Map<Id, Contract__c> contractsToUpdate;
	Map<Id, BillCalculation__c> billCalculationsToUpdate;
	
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		21 Sep 2017
	@param			Id - contract Id
    @param          GlUt_TriggerHandlerObj - inputParam
    @description	This method handles the initial invocation of the trigger
	*******************************************************************************/
    public override void MainEntry(GlUt_TriggerHandlerObj inputParam) {

		// initialise related records maps
		contractsToUpdate = new Map<Id, Contract__c>();
		billCalculationsToUpdate = new Map<Id, BillCalculation__c>();

        try {
        	// TO-DO Logger.Push('MainEntry', 'GlUt_AccountHandler');
        	
        	/* This is a Heroku mastered object so we shouldn't be modifying any fields on it */
        	/* Therfore before Insert/Update triggers not required */
        		
            if (inputParam.isInsert && inputParam.isAfter) {
            	
            	// update fields on related records
            	updateRelatedRecords(inputParam.newmap);
            }
            
            if (inputParam.isUpdate && inputParam.isAfter) {
            }
            
            if (inputParam.isDelete && inputParam.isBefore) {
            }
            
            if (inputParam.isDelete && inputParam.isAfter) {
            }
            
        } catch (exception e) {
			// TO-DO Logger.debugException(e);
        }

        finally {
        	
        	// update the related records
        	if (!contractsToUpdate.isEmpty()) update contractsToUpdate.values();
        	if (!billCalculationsToUpdate.isEmpty()) update billCalculationsToUpdate.values();
        	
            // Reset the active function to null in case this class was first in stack
            // this indicates that the trigger has finished firing so it no longer needs to control flow
            GlUt_CentralDispatcher.activeFunction = null;
            // TO-DO Logger.pop();
        }
	}
	
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		21 Sep 2017
	@param			Map<Id, SObject> - newMap
	@description 	Updates LastBillCalculationDate on Contract__c and
					Status = 'Completed' on BillCalculation for new Bills inserted
	*******************************************************************************/
	public void updateRelatedRecords(Map<Id, SObject> newMap) {
		
		Map<Id, Date> contractBillDateMap = new Map<Id, Date>();		// map of bill dates keyed on contract Id
		List<Id> billCalculationIdsToUpdate = new List<Id>();		// list of related bill calculation Ids

		// get the related contract and bill calculation records
		for (Bill__c bill : (List<Bill__c>)newMap.values()) {
			
			contractBillDateMap.put(bill.ContractNumber__c, bill.BillDate__c);
			billCalculationIdsToUpdate.add(bill.BillCalculation__c);
		}
		
		// for each related contract
		for (Contract__c contract : [select Id, 
											LastBillCalculationDate__c
									from Contract__c
									where Id in :contractBillDateMap.keySet()]) {
			
			// if the new bill date is more recent than the last bill calculation date, update it
			if (contract.LastBillCalculationDate__c == null 
					|| contract.LastBillCalculationDate__c < contractBillDateMap.get(contract.Id)) {
				contract.LastBillCalculationDate__c = contractBillDateMap.get(contract.Id);
				
				// and add it to the update map
				contractsToUpdate.put(contract.Id, contract);
			}

		}
		
		// for each related bill calculation
		for (BillCalculation__c billCalculation : [select Id, 
														Status__c
													from BillCalculation__c
													where Id in :billCalculationIdsToUpdate]) {
			
			// ensure the bill calculation status is 'Completed'								
			billCalculation.Status__c = BlIn_Constants.BILL_CALCULATION_STATUS_COMPLETED;						
			billCalculationsToUpdate.put(billCalculation.Id, billCalculation);
		}
	}
}
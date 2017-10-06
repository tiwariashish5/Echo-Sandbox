/************************************************************************************************************
@author         Accenture : Luke Emberton
@date           24-Aug-2017
@description:   This is an example class for how to use the trigger handler framework
Revision(s):    07-09-2017 - Shivangi Gaur - Added method createHouseholdContact() to create HH contact automatically
                                             on HH account insert.
                08-09-2017 - Shivangi Gaur - Commented method "createHouseholdContact()" since design for HH account 
                                             and contacts is moved to contact trigger.
                
**************************************************************************************************************/
public with sharing class GlUt_AccountHandler extends GlUt_TriggerHandlerBase{
     //Variable Declaration
     
     Id AccounthhRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(system.Label.AccAp_AccountRecordTypeHouseholdAccount).getRecordTypeId(); 
     Id ContacthhRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(system.Label.CuAp_ContactRecordTypeHouseholdContact).getRecordTypeId(); 
     
     //End Variable Declaration

    /**********************************************************************************************
    @author         Accenture: Luke Emberton
    @date           18-Aug-2017
    @param          GlUt_TriggerHandlerObj inputParam
    @return         void
    @description        This method is an example for handling the initial invocation of the trigger
                    for this example it simply updates the list of new records to make a recursive
                    call
    **********************************************************************************************/
    public override void  MainEntry(GlUt_TriggerHandlerObj inputParam){
            try{
            //Logger.Push('MainEntry', 'GlUt_AccountHandler');
                if( inputParam.isInsert && inputParam.isBefore ){
                    
                }
                if( inputParam.isInsert && inputParam.isAfter ){
                    //Call method to insert HH contact on HH account insert
                    //createHouseholdContact(inputParam.newlist);
                }
                if( inputParam.isUpdate && inputParam.isBefore ){
                    
                }
                if( inputParam.isUpdate && inputParam.isAfter ){
                      
                }  
                if( inputParam.isDelete && inputParam.isBefore ){
                    
                }
                if( inputParam.isDelete && inputParam.isAfter ){
                
                }  
            }
            catch (Exception ex){
                    //Logger.debugException(ex);
            }

            finally{   
                //Reset the active function to null in case this class was first in stack
                //this indicates that the trigger has finished firing so it no longer needs to control flow
                GlUt_CentralDispatcher.activeFunction = null;
                //Logger.pop();
            }
            
            //Cause recursion by making the trigger fire again by doing a second update on the account
            system.debug('Running Trigger Code');
            //update inputParam.newlist;
    }
    
    /**********************************************************************************************
    @author         Accenture: Luke Emberton
    @date           18-Aug-2017
    @param          GlUt_TriggerHandlerObj inputParam
    @return         void
    @description        This method overides the InProgressEntry in the base class. This is 
                    only necessary where special handling is required in the event that a trigger
                    causes another trigger to fire. In this case it is the Acccount trigger
                    calling the account trigger in which case the subsequnet invocation is supressed
    **********************************************************************************************/
        /* public override void  InProgressEntry(GlUt_TriggerHandlerObj inputParam){        
        
       if(inputParam.TriggerObject == 'Account'){
                //Supress recursion
                system.debug('Suppression Account Recursion ' + 'IsUpdate: ' + inputParam.IsUpdate + ' IsBefore: ' + inputParam.IsBefore + ' IsAfter: ' + inputParam.IsAfter);
                
        }
        //Otherwise invoke the default version of the tigger
        else{
                system.debug('Running standard trigger');
                super.InProgressEntry(inputParam);
        }
      
    }*/
    /**********************************************************************************************
    @author        Accenture : Shivangi Gaur
    @date          07-09-2017
    @param         List<Account> newAccList
    @return        void
    @description   This utility method is used to create Household Contact associated to the Contact
    **********************************************************************************************/
    /*public void createHouseholdContact(List<Account> newAccList){
        List<Contact> newContactList = new List<Contact>();
        List<HHAccounttoContactMapping__mdt> AccToConList = new List<HHAccounttoContactMapping__mdt>([Select id, DeveloperName, AccountField__c, ContactField__c from HHAccounttoContactMapping__mdt limit 50000]);
        
        for(Account acc : newAccList){
            if(acc.RecordTypeId.equals(AccounthhRecordTypeId)){
                Contact conObj = new Contact();
                if(!AccToConList.isEmpty()){
                    for(HHAccounttoContactMapping__mdt AccToCon : AccToConList){
                        String fieldName = AccToCon.ContactField__c;
                        conObj.put(fieldName,acc.get(AccToCon.AccountField__c));
                        conObj.recordtypeId = ContacthhRecordTypeId;
                    }
                    newContactList.add(conObj);
                }                
            }
        }
        
        if(!newContactList.isEmpty()){
            insert newContactList;
        }
    }*/
}
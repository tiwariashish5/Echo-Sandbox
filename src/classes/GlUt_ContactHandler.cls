/**************************************************************************************************************************************
@author        Accenture : Shivangi Gaur
@date          05-Sep-2017
@description:  This class is uesd to handle various methods related to Contact trigger  
@group         TriggerHelper
Revision(s)    06-09-2017 - Shivangi Gaur - Updated method createHouseholdAccounts() to include check for Household Contact record type
                                            and copy Contact mailing address fields to Account Shipping Address fields.
               07-09-2017 - Shivangi Gaur - Commented method createHouseholdAccounts() since the functionality is shifted to Account Trigger.
               08-09-2017 - Shivangi Gaur - Uncommented and updated method createHouseholdAccounts().
               12-09-2017 - Shivangi Gaur - Added inline comments in the method createHouseholdAccounts().
               20-09-2017 - Shivangi Gaur - Commented method createHouseholdAccounts() due to change in HH Account design.
***************************************************************************************************************************************/
public with sharing class GlUt_ContactHandler extends GlUt_TriggerHandlerBase{
    // Variable declaration
    
    Id AccounthhRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(system.Label.AccAp_AccountRecordTypeHouseholdAccount).getRecordTypeId(); 
    Id ContacthhRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(system.Label.CuAp_ContactRecordTypeHouseholdContact).getRecordTypeId(); 
    
    // End variable declaration
    
    /**********************************************************************************************
    @author        Accenture: Shivangi Gaur
    @date          05-Sep-2017
    @param         GlUt_TriggerHandlerObj inputParam
    @return        void
    @description   This method is used to invoke method from trigger
    **********************************************************************************************/
    public override void  MainEntry(GlUt_TriggerHandlerObj inputParam){
        try{
        //Logger.Push('MainEntry', 'GlUt_ContactHandler');
            if( inputParam.isInsert && inputParam.isBefore ){
                //Call method to create Household accounts for contacts with no account associated
                //createHouseholdAccounts(inputParam.newlist);
            }
            if( inputParam.isInsert && inputParam.isAfter ){
            
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
    
    }
    
    /**********************************************************************************************
    @author        Accenture : Satish Nair
    @date          16th Aug,2017
    @param         List<Contact> newconList, Map<Id,Contact> oldconMap
    @return        void
    @description   This utility method is used to create Household Account associated to the Contact
    **********************************************************************************************/
    /*public void createHouseholdAccounts(List<Contact> newconList){
        List<Contact> needAccountsList = new List<Contact>();
        List<Account> newAccounts = new List<Account>();
        Map<String,Contact> conMap = new Map<String,Contact>();

        for (Contact conRec : newconList) {
            //check if account on contact is blank and contact record type is Household Contact
            if (String.isBlank(conRec.accountid) && conRec.RecordTypeId.equals(ContacthhRecordTypeId)) {
                needAccountsList.add(conRec);
            }
        }
        
        if (!needAccountsList.isEmpty()) {
            //fetch contact to account mapping from custom metadata type
            List<HHAccounttoContactMapping__mdt> AccToConList = new List<HHAccounttoContactMapping__mdt>([Select id, DeveloperName, AccountField__c, ContactField__c from HHAccounttoContactMapping__mdt limit 50000]);
            integer i = 1;
            //Create account for each contact
            for (Contact contacts : needAccountsList) {
                String accountName = contacts.firstname + ' ' + contacts.lastname + i;
                i++;
                conMap.put(accountName,contacts);
                Account accNew = new Account();
                for(HHAccounttoContactMapping__mdt AccToCon : AccToConList){
                    String fieldName = AccToCon.AccountField__c;
                    //Set account field values from mapping fetched from custom metadata type
                    accNew.put(fieldName,contacts.get(AccToCon.ContactField__c));
                    accNew.recordtypeId = AccounthhRecordTypeId;
                    accNew.Name = contacts.firstname + ' ' + contacts.lastname;
                }
                newAccounts.add(accNew);
            }            
            
        }
        if(!newAccounts.isEmpty()){
            insert newAccounts;
        }
        if(!newAccounts.isEmpty()){
            integer j =1;
            for (Account hhacc : newAccounts) {
                //Put account ids on contacts
                if (conMap.containsKey(hhacc.Name+j)) {
                    conMap.get(hhacc.Name+j).accountId = hhacc.Id;
                    j++;
                }
            }
        }
    }*/
}
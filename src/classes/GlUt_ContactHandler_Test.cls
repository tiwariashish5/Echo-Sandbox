/******************************************************************************
@author        Accenture : Shivangi Gaur
@date          13-Sep-2017
@description: Test Class for GlUt_ContactHandler
Revision(s):  20-09-2017 - Shivangi Gaur - Commented the methods due to createHouseholdAccounts() commented in GlUt_ContactHandler.
*******************************************************************************/
@isTest
Public Class GlUt_ContactHandler_Test{
    private static string contactFirstName = 'John';
    private static string contactLastName = 'William';
    private static string addressStreet = '21 New Province';
    private static string addressState = 'Berkshire';
    private static string addressCity = 'Bracknell';
    private static string addressCountry = 'UK';
    private static string addressPostalCode = 'RG12';
    private static string otherContactRecordType = 'Other Contact';
    
    /*******************************************************************
    Purpose: method to create test data used by all test methods
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/    
    @TestSetup
    Static void createTestData(){
        //Create setup data that can be referenced by test methods
    }
    
    /*******************************************************************
    Author:  Shivangi Gaur
    Details: Bulk testing Method to insert contacts and test for accounts
             inserted.
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    /*static testmethod void insertHHContact_Bulk(){
        Id accounthhRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(system.Label.AccAp_AccountRecordTypeHouseholdAccount).getRecordTypeId(); 
        Id contacthhRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(system.Label.CuAp_ContactRecordTypeHouseholdContact).getRecordTypeId();
    
        List<Contact> conList = new List<Contact>();
        for(integer i = 0; i<200; i++){
            Contact newCon = GlUt_TestFactoryData.CreateContact(contactFirstName,contactLastName+i);
            newCon.RecordTypeId = contacthhRecordTypeId;
            newCon.AccountId = null;
            newCon.MailingStreet = addressStreet;
            newCon.MailingState = addressState;
            newCon.MailingCity = addressCity;
            newCon.MailingCountry = addressCountry;
            newCon.MailingPostalCode = addressPostalCode;
            newCon.OtherStreet = addressStreet;
            newCon.OtherState = addressState;
            newCon.OtherCity = addressCity;
            newCon.OtherCountry = addressCountry;
            newCon.OtherPostalCode = addressPostalCode;
            conList.add(newCon);
        }
        
        Test.startTest();
        Database.insert(conList);        
        Test.StopTest();
        
        Contact objCon = [Select id, AccountId from Contact where id =: conList[10].id limit 1];
        //Assert to check account is inserted with contact insert
        System.assert(objCon.AccountId != null);
        Account accObj = [Select id, RecordTypeId, Name from Account where Id =: objCon.AccountId limit 1];
        //Asserts to check details of account inserted to be in sync with contact inserted and linked
        System.assertEquals(accObj.RecordTypeId,AccounthhRecordTypeId);
        System.assertEquals(accObj.Name,contactFirstName+' ' +contactLastName+'10');
    }*/
    
    /**************************************************************************
    Author:  Shivangi Gaur
    Purpose: Method to insert household contact and check for account inserted.
             {Positive scenario}
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    **************************************************************************/
    /*static testmethod void insertHHContact_Positive(){
        Id accounthhRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(system.Label.AccAp_AccountRecordTypeHouseholdAccount).getRecordTypeId(); 
        Id contacthhRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(system.Label.CuAp_ContactRecordTypeHouseholdContact).getRecordTypeId();
        
        Contact newCon = GlUt_TestFactoryData.CreateContact(contactFirstName,contactLastName);
        newCon.RecordTypeId = contacthhRecordTypeId;
        newCon.AccountId = null;
        newCon.MailingStreet = addressStreet;
        newCon.MailingState = addressState;
        newCon.MailingCity = addressCity;
        newCon.MailingCountry = addressCountry;
        newCon.MailingPostalCode = addressPostalCode;
        newCon.OtherStreet = addressStreet;
        newCon.OtherState = addressState;
        newCon.OtherCity = addressCity;
        newCon.OtherCountry = addressCountry;
        newCon.OtherPostalCode = addressPostalCode;
        
        Test.startTest();
        Database.insert(newCon);        
        Test.StopTest();
        
        Contact objCon = [Select id, AccountId from Contact where id =: newCon.id limit 1];
        //Assert to check account is inserted and linked to contact on contact insert
        System.assert(objCon.AccountId != null);
        Account accObj = [Select id, RecordTypeId, Name from Account where Id =: objCon.AccountId limit 1];
        //Asserts to check record type of inserted account to be household and other details in sync with contact
        System.assertEquals(accObj.RecordTypeId,AccounthhRecordTypeId);
        System.assertEquals(accObj.Name,contactFirstName+' ' +contactLastName);
    }*/
    /**************************************************************************
    Author:  Shivangi Gaur
    Purpose: Method to insert non-household contact and check no account is inserted.
             {Positive scenario}
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    **************************************************************************/
    static testmethod void insertHHContact_Negative(){
        Id contactOtherRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(otherContactRecordType).getRecordTypeId();
        
        Contact newCon = GlUt_TestFactoryData.CreateContact(contactFirstName,contactLastName);
        newCon.RecordTypeId = contactOtherRecordTypeId;
        newCon.AccountId = null;
        newCon.MailingStreet = addressStreet;
        newCon.MailingState = addressState;
        newCon.MailingCity = addressCity;
        newCon.MailingCountry = addressCountry;
        newCon.MailingPostalCode = addressPostalCode;
        newCon.OtherStreet = addressStreet;
        newCon.OtherState = addressState;
        newCon.OtherCity = addressCity;
        newCon.OtherCountry = addressCountry;
        newCon.OtherPostalCode = addressPostalCode;
        
        Test.startTest();
        Database.insert(newCon);        
        Test.StopTest();
        
        Contact objCon = [Select id, AccountId from Contact where id =: newCon.id limit 1];
        //Assert to check no account is inserted on contact insert and AccountId on contact is blank
        System.assertEquals(objCon.AccountId,null);
    }
}
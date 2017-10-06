/******************************************************************************
@author        Accenture : Vandana Anshu
@date          13-Sep-2017
@description: Test Class for GlUt_AccountHandler
*******************************************************************************/
@isTest
Public Class GlUt_AccountHandler_Test{

    private static string userProfileName = 'System Administrator';
    private static string userName = 'TestUser';
    private static string managerId = Null;
    private static string accName = 'TestAccount';
    
   /******************************************************************************
    @author:      Accenture: Vandana Anshu
    @date:        27th September 2017
    @description: Test data setup method
    *******************************************************************************/    
    @TestSetup
    static void createTestData(){
        User objUser = GlUt_TestFactoryData.createUser(userProfileName, userName, managerId);
        Database.insert(objUser);
        
        Account objAccount = GlUt_TestFactoryData.CreateAccount(accName);
        Database.insert(objAccount);

  }     
        
        //Create setup data that can be referenced by test methods
    
    /*******************************************************************
    @author  Accenture : Vandana Anshu
    Details: Bulk testing Method to insert Accounts
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testmethod void insertHHAccount_Bulk(){
        Id accounthhRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(system.Label.AccAp_AccountRecordTypeHouseholdAccount).getRecordTypeId(); 
         Id ContacthhRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(system.Label.CuAp_ContactRecordTypeHouseholdContact).getRecordTypeId(); 
        List<Account> accList = new List<Account>();
        for(integer i = 0; i<200; i++){
            Account newAcc = GlUt_TestFactoryData.CreateAccount('TestAccount'+i);
            newAcc.RecordTypeId = accounthhRecordTypeId;
            newAcc.Type = 'Domestic Tenant';
            newAcc.BillingStreet = 'billingStreet';
            newAcc.BillingState = 'billingState';
            newAcc.BillingCity = 'billingCity';
            newAcc.BillingCountry = 'billingCountry';
            newAcc.BillingPostalCode = 'billingPostalCode';
            newAcc.ShippingStreet = 'shippingStreet';
            newAcc.ShippingState = 'shippingState';
            newAcc.ShippingCity = 'shippingCity';
            newAcc.ShippingCountry = 'shippingCountry';
            newAcc.ShippingPostalCode = 'shippingPostalCode';
            accList.add(newAcc);
        }
        
        Test.startTest();
        Database.insert(accList);        
        Test.StopTest();
        
    }

  }
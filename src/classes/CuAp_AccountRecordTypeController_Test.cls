/******************************************************************************
@author:      Accenture: Vivek Chauhan
@date:        13 September 2017
@description: Test Class for CuAp_AccountRecordTypeController
*******************************************************************************/

@isTest
Public Class CuAp_AccountRecordTypeController_Test{
    private static String USER_PROFILE ='System Administrator';
    private static String USER_NAME ='TestUser'; 
    private static String ACCOUNT_NAME = 'TestAccount'; 
    private static String CONTRACT_NAME ='TestContract';
    private static String BILLNAME = 'testBill';
    public static String HOUNSEHOLDACCOUNT ='Household Account';
    public static String HOUNSEHOLDCONTACT ='Household Contact';
    public static String NONHOUNSEHOLDACCOUNT ='Non-Household Account';
    
/******************************************************************************
@author:      Accenture: Vivek Chauhan
@date:        13 September 2017
@description: Test data setup method
*******************************************************************************/
    @TestSetup
    Static void createTestData(){
        User objUser = GlUt_TestFactoryData.createUser(USER_PROFILE,USER_NAME,null);
        Database.insert(objUser); 
        
        Account objAccount = GlUt_TestFactoryData.CreateAccount(ACCOUNT_NAME);
        Database.insert(objAccount);
        
        Contract__c con = GlUt_TestFactoryData.CreateContract(CONTRACT_NAME,objAccount); 
        Database.insert(con);
         
        Bill__c objBill = GlUt_TestFactoryData.CreateBill(BILLNAME,con);
        Database.insert(objBill);
    }
    
/******************************************************************************
@author:      Accenture: Vivek Chauhan
@date:        13 September 2017
@description: Test method for fetchRecordTypeValues,getRecTypeId methods
*******************************************************************************/
    static testmethod void fetchRecordTypeValuesTest_Positive(){
        User objUser =[select id,name from user where isActive=true limit 1];
        system.runas(objUser){
            Test.startTest();
            list<String>lstOfRecordType=CuAp_AccountRecordTypeController.fetchRecordTypeValues();
            system.assert(lstOfRecordType.size()>0);
            Id recordTypeIdContact = CuAp_AccountRecordTypeController.getRecTypeId(HOUNSEHOLDACCOUNT);
            system.assert(recordTypeIdContact !=null);
            Id recordTypeIdAccount = CuAp_AccountRecordTypeController.getRecTypeId(NONHOUNSEHOLDACCOUNT);
            system.assert(recordTypeIdAccount!=null);
            Test.stopTest();
        }
    }   
}
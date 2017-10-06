/******************************************************************************
@author:      Accenture: Sucharu Gupta
@date:        05 September 2017
@description: Test Class for BlIn_BillCalcExtractData 
*******************************************************************************/

@isTest
//test data creation for BlIn_BillCalcExtractData class
Public Class BlIn_BillCalcExtractData_Test{
    
    private static string DEBT_RECOVERY_PROFILE = 'Standard HH Debt Recovery Process';
    private static string BILLING_FREQUENCY = 'Monthly';
    private static string BILLING_ADDRESS = 'Test Address';
    private static string PROFILE_NAME = 'System Administrator';
    private static String USER_PROFILE ='System Administrator';
    private static String USER_NAME ='TestUser'; 
    private static String ACCOUNT_NAME = 'TestAccount'; 
    private static String CONTRACT_NAME_ONE ='TestContract';
    private static String CONTRACT_NAME_SECOND ='TestContract2';
    
/*******************************************************************
Purpose: method to create test data used by all test methods
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    
    @TestSetup
    Static void createTestData(){
        
        User objUser = GlUt_TestFactoryData.createUser(USER_PROFILE ,USER_NAME ,null);
        Database.insert(objUser); 
        
        Account objAccount = GlUt_TestFactoryData.CreateAccount(ACCOUNT_NAME );
        Database.insert(objAccount);
        BillCalculation__c objBillCalculation = GlUt_TestFactoryData.createBillCalculation();
        Database.insert(objBillCalculation);
        
        list<Contract__c >lstContract = new list<Contract__c>(); 
        
        Contract__c con = GlUt_TestFactoryData.CreateContract(CONTRACT_NAME_ONE ,objAccount); 
        con.DebtRecoveryProfile__c = DEBT_RECOVERY_PROFILE;
        con.BillingFrequency__c = BILLING_FREQUENCY;
        con.BillingAddress__c = BILLING_ADDRESS;
        con.BillCalculation__c = objBillCalculation.id;
        lstContract.add(con);
        
        Contract__c con2 = GlUt_TestFactoryData.CreateContract(CONTRACT_NAME_SECOND ,objAccount);
        con2.DebtRecoveryProfile__c = DEBT_RECOVERY_PROFILE;
        con2.BillingFrequency__c = BILLING_FREQUENCY;
        con2.BillingAddress__c = BILLING_ADDRESS;
        con2.BillCalculation__c = objBillCalculation.id;

        lstContract.add(con2);
        
        Database.insert(lstContract);
    }
    

    
/*******************************************************************
Purpose: Method to test Retrives and packages billing data (List of ID'S) {Positive scenario}
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    
    static testmethod void retriveDataListContract_Positive(){
        User objUser =[select id,name from user where isActive=true limit 1];
        Contract__c con =[Select id,name from Contract__c limit 1];
        BillCalculation__c objBillCalculation = [select id from BillCalculation__c];
        Id billCalculationId = objBillCalculation .id;
        List<Id> lstContractIds = new List<Id>();
        lstContractIds.add(con.id);
        system.runas(objUser){
            Test.startTest();
            String str1 = BlIn_BillCalcExtractData.retrieveData(billCalculationId);
            Test.StopTest();
            system.assertNotEquals(null,str1);
        }
        
    }
    

}
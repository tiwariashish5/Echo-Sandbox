/******************************************************************************
@author:      Accenture: Sucharu Gupta
@date:        05 September 2017
@description: Test Class for BlIn_ExecuteBillCalculation 
*******************************************************************************/

@isTest
//test data creation for BlIn_BillCalcExtractData class
Public Class BlIn_ExecuteBillCalculation_Test{
    
    //Variable declaration startTest
    
    private static string BILLINGRESPONSEMOCKPOSITIVE = 'GlUt_Mock_createBilling_Response_Positive';
    private static string BILLINGRESPONSEMOCKNEGATIVE = 'GlUt_Mock_createBilling_Response_Negative';
    private static String PROFILENAME  = 'System Administrator';
    private static String USERNAME = 'TestUser';
    
/*******************************************************************
Purpose: method to create test data used by all test methods
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/

    @TestSetup
    Static void createTestData(){
        User objUser = GlUt_TestFactoryData.createUser(PROFILENAME,USERNAME,null);
        Database.insert(objUser); 
        
        BillCalculation__c  objBillCalculation = GlUt_TestFactoryData.createBillCalculation();
        Database.insert(objBillCalculation);
         
    }
        
/*******************************************************************
Purpose: Method to test HEROKU REST callout to  request a bill calculation{Positive scenario}
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    static testmethod void requestBillCalculation_PositiveTest(){
        User objUser =[select id,name from user where isActive=true limit 1];
        BillCalculation__c objBillCalculation =[Select id from BillCalculation__c limit 1];
        
        system.runas(objUser ){
            
            Test.startTest();
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new GlUt_TestMockAPIProvider(BILLINGRESPONSEMOCKPOSITIVE));
            boolean b = BlIn_ExecuteBillCalculation.requestBillCalculation(objBillCalculation.id);
            Test.StopTest();
            
            System.assertEquals(true,b);
        }   
    }
    
/*******************************************************************
Purpose: Method to test HEROKU REST callout to get the bill calculation result{Positive scenario}
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    
    static testmethod void getBillCalculationResult_PositiveTest(){
        User objUser =[select id,name from user where isActive=true limit 1];
        BillCalculation__c objBillCalculation =[Select id from BillCalculation__c limit 1];
        List<Id> getBillCalculationResultList = new List<Id>();
        getBillCalculationResultList.add(objBillCalculation.id);
        
        system.runas(objUser ){
            
            Test.startTest();
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new GlUt_TestMockAPIProvider(BILLINGRESPONSEMOCKPOSITIVE));
            getBillCalculationResultList = BlIn_ExecuteBillCalculation.getBillCalculationResult(objBillCalculation.id);
            Test.StopTest();
            
            System.assert( objBillCalculation.id!= null);
        }   
    }
    
/*******************************************************************
Purpose: Method to test HEROKU REST callout to get the bill calculation result{Negative scenario}
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    
    static testmethod void getBillCalculationResult_NegativeTest(){
        User objUser =[select id,name from user where isActive=true limit 1];
        BillCalculation__c objBillCalculation =[Select id from BillCalculation__c limit 1];
        List<Id> getBillCalculationResultList = new List<Id>();
        getBillCalculationResultList.add(objBillCalculation.id);
        
        system.runas(objUser ){
            
            Test.startTest();
            try{
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new GlUt_TestMockAPIProvider(BILLINGRESPONSEMOCKNEGATIVE));
            getBillCalculationResultList = BlIn_ExecuteBillCalculation.getBillCalculationResult(objBillCalculation.id); 
            } catch(exception e){
                System.assert(e.getmessage()!= null);
            }
            Test.StopTest();
            
        }   
    }
}
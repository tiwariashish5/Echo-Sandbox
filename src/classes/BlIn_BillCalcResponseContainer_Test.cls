/******************************************************************************
@author:      Accenture: Sucharu Gupta
@date:        06 September 2017
@description: Test Class for BlIn_BillCalcResponseContainer 
*******************************************************************************/
@isTest
//test data creation for BlIn_BillCalcResponseContainer class
Public Class BlIn_BillCalcResponseContainer_Test{
    
/*******************************************************************
Purpose: method to create test data used by all test methods
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    
    @TestSetup
    Static void createTestData(){
        User objUser = GlUt_TestFactoryData.createUser('System Administrator','TestUser',null);
        Database.insert(objUser); 
    }
    
/*******************************************************************
Purpose: Method to test JSON response Parsing {Positive scenario}
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    static testmethod void parseJSONString_Positive(){
        User objUser =[select id,name from user where isActive=true limit 1];
        String jsonStr = GlUt_TestFactoryData.createJson('TestString');
        system.runas(objUser){
        Test.startTest();
        BlIn_BillCalcResponseContainer objBlIn_BillCalcResponseContainer = BlIn_BillCalcResponseContainer.parse(jsonStr);
        Test.StopTest();
        system.assertNotEquals(null,objBlIn_BillCalcResponseContainer);
        }
    }
        
}
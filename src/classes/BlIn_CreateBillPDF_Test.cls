/******************************************************************************
@author:      Accenture: Sucharu Gupta
@date:        06 September 2017
@description: Test Class for BlIn_CreateBillPDF 
*******************************************************************************/
@isTest
//test data creation for BlIn_CreateBillPDF class
Public Class BlIn_CreateBillPDF_Test{
    
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
Purpose: Method to test HEROKU callout to generate a PDF {Positive scenario}
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    static testmethod void callPDFGenerationAPI_Positive(){
        User objUser =[select id,name from user where isActive=true limit 1];
        Dom.Document doc = GlUt_TestFactoryData.createBillPDFDataXML();
        system.runas(objUser ){
        Test.startTest();
        String str1 = BlIn_CreateBillPDF.callPDFGenerationAPI(doc);
        Test.StopTest();
        system.assertNotEquals(null,str1);
        }
    }
        
}
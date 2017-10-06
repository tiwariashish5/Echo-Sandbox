/******************************************************************************
@author:      Accenture: Sucharu Gupta
@date:        29 September 2017
@description: Test Class for    BlIn_PDFXMLDefinition 
*******************************************************************************/

@isTest
//test data creation for    BlIn_PDFXMLDefinition class
Public Class BlIn_PDFXMLDefinition_Test{
    
    private static String USER_PROFILE ='System Administrator';
    private static String USER_NAME ='TestUser'; 
       
/*******************************************************************
Purpose: method to create test data used by all test methods
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    @TestSetup
    Static void createTestData(){
        User objUser = GlUt_TestFactoryData.createUser(USER_PROFILE,USER_NAME,null);
        Database.insert(objUser); 
    }
    
/*******************************************************************
Purpose: Method to test  XML data records
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    static testmethod void BlIn_PDFXMLDefinition_Positive(){
        User objUser =[select id,name from user where isActive=true limit 1];
        
        List<BlIn_PDFBillData.XMLObject> XMLObjects = new List<BlIn_PDFBillData.XMLObject>();
        system.runas(objUser){
            Test.startTest();
            BlIn_PDFXMLDefinition objBlIn_PDFXMLDefinition = new BlIn_PDFXMLDefinition(); 
            XMLObjects = objBlIn_PDFXMLDefinition.XMLObjects;
            Test.stopTest();
            system.assert(XMLObjects!=null);
        }
    }
}
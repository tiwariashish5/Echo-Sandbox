/******************************************************************************
@author:      Accenture: Sucharu Gupta
@date:        28 September 2017
@description: Test Class for BlAp_CombinedRecord 
*******************************************************************************/

@isTest
//test data creation for BlAp_CombinedRecord class
Public Class BlAp_CombinedRecord_Test{
    
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
Purpose: Method to test BlAp_CombinedRecord class
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    static testmethod void BlAp_CombinedRecord_Positive(){
        User objUser =[select id,name from user where isActive=true limit 1];
        BlAp_CombinedRecord objBlAp_CombinedRecord = new BlAp_CombinedRecord();
        system.runas(objUser){
            Test.startTest();
            boolean isSelected = objBlAp_CombinedRecord.isSelected;
            isSelected = true;
            string uniqueId =objBlAp_CombinedRecord.uniqueId ;
            string checkboxId = objBlAp_CombinedRecord.checkboxId;
            Map<string, sObject> objectMap = new Map<string, sObject>();
            objectMap.put(objUser.Id, objUser);
            objectMap = objBlAp_CombinedRecord.objectMap;
            Test.stopTest();
            system.assert(checkboxId!=null);
        }
    }
}
/******************************************************************************
@author:      Accenture: Vandana Anshu
@date:        25 September 2017
@description: Test Class for GlAp_ReferenceFieldController
*******************************************************************************/

@isTest
Public Class GlAp_ReferenceFieldController_Test{

    private static string userProfileName = 'System Administrator';
    private static string userName = 'TestUser';
    private static string managerId = Null;
    private static string accName = 'TestAccount';
    private static string searchKeyWord= 'Test';    
    private static string sObjectType= 'Account';
    private static string fieldName= 'Name';
    private static string parentObject= 'Account';

/******************************************************************************
@author:      Accenture: Vandana Anshu
@date:        25 September 2017
@description: Test data setup method
*******************************************************************************/
    @TestSetup
    static void createTestData(){
        User objUser = GlUt_TestFactoryData.createUser(userProfileName, userName, managerId);
        Database.insert(objUser);
        
        Account objAccount = GlUt_TestFactoryData.CreateAccount(accName);
        Database.insert(objAccount);     
        
    }

/******************************************************************************
@author:      Accenture: Vandana Anshu
@date:        25 September 2017
@description: Test method for fetchRecords,getObjectType, getObjectTypeForField, getRecordName methods.
*******************************************************************************/
     static testmethod void referenceFieldController_Positive(){

            Test.startTest();  
            List<sObject> newAcc = GlAp_ReferenceFieldController.fetchRecords(searchKeyWord, sObjectType);
            System.assert(newAcc.size()>0);
           
            Account acc = [Select id,name from Account where name='TestAccount' Limit 1];
            GlAp_ReferenceFieldController.getObjectType(acc.id);
            
            GlAp_ReferenceFieldController.getObjectTypeForField(fieldName, parentObject);
            
            String recName = GlAp_ReferenceFieldController.getRecordName(acc.id);
         
            Test.stopTest();

   }
  }
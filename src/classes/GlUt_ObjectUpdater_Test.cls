/****************************************************************************************************
@author:      Accenture: Shivangi Gaur
@date:        27 September 2017
@description: Test Class for GlUt_ObjectUpdater
Revision(s):  28-09-2017 - Shivangi Gaur - Removed hardcoding from test methods
                                           and implemented other code quality related aspects.
****************************************************************************************************/

@isTest
Public Class GlUt_ObjectUpdater_Test{
    
    //Variable declaration start
    
    private static String PROFILENAME = 'System Administrator';
    private static String USERNAME = 'TestUser';
    private static String ACCNAME = 'TestAccount';
    private static String CONFIRSTNAME = 'Test';
    private static String CONLASTNAME = 'Contact 101';
    private static String PASSWORDFIELD = 'ConsiderationPassword__c';
    private static String PASSWORDDATA = 'New Password';
    private static String LOCATIONFIELD = 'NumberofLocations__c';
    private static Integer LOCATIONDATA = 3;
    private static String ACCOUNTOBJECTNAME = 'Account';
    private static String CONTACTOBJECTNAME = 'Contact';
    
    //Variable declaration end

/******************************************************************************
@author:      Accenture: Shivangi Gaur
@date:        27 September 2017
@description: Test data setup method
*******************************************************************************/
    @TestSetup
    static void createTestData(){
        //Create user record
        User objUser = GlUt_TestFactoryData.createUser(PROFILENAME,USERNAME,null);
        Database.insert(objUser); 

        //Create account record
        Account objAccount = GlUt_TestFactoryData.CreateAccount(ACCNAME);
        objAccount.NumberofLocations__c = LOCATIONDATA;
        Database.insert(objAccount);
        
        //Create contact record
        Contact objCon = GlUt_TestFactoryData.CreateContact(CONFIRSTNAME,CONLASTNAME);
        objCon.ConsiderationPassword__c = PASSWORDDATA;
        Database.insert(objCon);
    }
    
/******************************************************************************
@author:      Shivangi Gaur
@date:        27 September 2017
@description: Test method for obscufateField() method
*******************************************************************************/
    static testmethod void obscufateField_Positive(){
        
        //Query user record created in test setup data method
        User objUser = [Select id,name from user where isActive = true limit 1];
        //Query contact record created in test setup data method
        Contact conObj = [Select id, ConsiderationPassword__c from Contact limit 1];
        
        //Run test class in user context
        System.runAs(objUser){
            
            Test.startTest();
            
            GlUt_ObjectUpdater objUpdate = new GlUt_ObjectUpdater(conObj, CONTACTOBJECTNAME);
            objUpdate.obscufateField(PASSWORDFIELD);
            SObject conNew = objUpdate.getSObject();
            
            Test.stopTest();
            
            System.assertEquals(conNew.getSObjectType().getDescribe().getName(), CONTACTOBJECTNAME);
            
        }
    }
/******************************************************************************
@author:      Shivangi Gaur
@date:        27 September 2017
@description: Test method for obscufateField() method
*******************************************************************************/
    static testmethod void obscufateField_Negative(){
        
        //Query user record created in test setup data method
        User objUser = [Select id,name from user where isActive = true limit 1];
        //Query account record created in test setup data method
        Account accObj = [Select id, NumberofLocations__c from Account limit 1];
        
        //Run test class in user context
        System.runAs(objUser){
            
            Test.startTest();
            
            GlUt_ObjectUpdater objUpdate = new GlUt_ObjectUpdater(accObj, ACCOUNTOBJECTNAME);
            objUpdate.obscufateField(LOCATIONFIELD);
            SObject accNew = objUpdate.getSObject();
            
            Test.stopTest();
            
            System.assertEquals(accNew.getSObjectType().getDescribe().getName(), ACCOUNTOBJECTNAME);
            
        }
    }
/******************************************************************************
@author:      Shivangi Gaur
@date:        27 September 2017
@description: Test method for removeField() method
*******************************************************************************/
    static testmethod void removeField_Positive(){
        
        //Query user record created in test setup data method
        User objUser = [Select id,name from user where isActive = true limit 1];
        //Query contact record created in test setup data method
        Contact conObj = [Select id, ConsiderationPassword__c from Contact limit 1];
        
        //Run test class in user context
        System.runAs(objUser){
            
            Test.startTest();
            
            GlUt_ObjectUpdater objUpdate = new GlUt_ObjectUpdater(conObj, CONTACTOBJECTNAME);
            objUpdate.removeField(PASSWORDFIELD);
            SObject conNew = objUpdate.getSObject();
            
            Test.stopTest();
            
            System.assertEquals(conNew.getSObjectType().getDescribe().getName(), CONTACTOBJECTNAME);
            
        }
    }
}
/****************************************************************************************************
@author:      Accenture: Shivangi Gaur
@date:        29 September 2017
@description: Test Class for GlUt_TriggerHandlerBase
Revision(s):  Shivangi Gaur -- 03/Oct/2017 -- Added method MainEntry_Positive().
****************************************************************************************************/

@isTest
Public Class GlUt_TriggerHandlerBase_Test{
    
    //Variable declaration start
    
    private static String PROFILENAME = 'System Administrator';
    private static String USERNAME = 'TestUser';
    private static String ACCOUNTOBJECTNAME = 'Account';
    private static String EXCEPTIONMESSAGE = 'Error Not Implemented';
    
    //Variable declaration end

/******************************************************************************
@author:      Accenture: Shivangi Gaur
@date:        29 September 2017
@description: Test data setup method
*******************************************************************************/
    @TestSetup
    static void createTestData(){
        
        //Create user record
        User objUser = GlUt_TestFactoryData.createUser(PROFILENAME,USERNAME,null);
        Database.insert(objUser); 
        
    }
    
/******************************************************************************
@author:      Shivangi Gaur
@date:        29 September 2017
@description: Test method for InProgressEntry() method
*******************************************************************************/
    static testmethod void InProgressEntry_Positive(){
        
        //Query user record created in test setup data method
        User objUser = [Select id,name from user where isActive = true limit 1];
        
        //Run test class in user context
        System.runAs(objUser){
            
            Test.startTest();
            GlUt_TriggerHandlerObj triggerObj = new GlUt_TriggerHandlerObj ();
            triggerObj.TriggerObject = ACCOUNTOBJECTNAME;
            GlUt_TriggerHandlerBase objUpdate = new GlUt_TriggerHandlerBase();
            objUpdate.InProgressEntry(triggerObj);
            
            Test.stopTest();
            
        }
    }
/******************************************************************************
@author:      Shivangi Gaur
@date:        03 October 2017
@description: Test method for MainEntry() method
*******************************************************************************/
    static testmethod void MainEntry_Positive(){
        
        //Query user record created in test setup data method
        User objUser = [Select id,name from user where isActive = true limit 1];
        
        //Run test class in user context
        System.runAs(objUser){
            
            Test.startTest();
            GlUt_TriggerHandlerObj triggerObj = new GlUt_TriggerHandlerObj ();
            triggerObj.TriggerObject = ACCOUNTOBJECTNAME;
            GlUt_TriggerHandlerBase objUpdate = new GlUt_TriggerHandlerBase();
            try{
                objUpdate.MainEntry(triggerObj);
            }
            catch(exception ex){
                System.assertEquals(ex.getMessage(), EXCEPTIONMESSAGE);
            }
            
            Test.stopTest();
            
        }
    }
}
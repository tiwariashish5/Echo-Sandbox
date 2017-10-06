/******************************************************************************
@author:      Accenture: Vandana Anshu
@date:        27 September 2017
@description: Test Class for GlUt_CentralDispatcher
*******************************************************************************/
   @isTest
   public class GlUt_CentralDispatcher_Test{

        private static string userProfileName = 'System Administrator';
        private static string userName = 'TestUser';
        private static string managerId = Null;

/******************************************************************************
@author:      Accenture: Vandana Anshu
@date:        27 September 2017
@description: Test data setup method
*******************************************************************************/
    @TestSetup
    static void createTestData(){
    
        User objUser = GlUt_TestFactoryData.createUser(userProfileName, userName, managerId);
        Database.insert(objUser);
        
        GlUt_DisableAutomation__c automationSetting = new GlUt_DisableAutomation__c();
        automationSetting.AccountTriggers__c = False;
        DataBase.Insert(automationSetting);
    
    }

/******************************************************************************
@author:      Accenture: Vandana Anshu
@date:        27 September 2017
@description: To test mainEntry method
*******************************************************************************/    
    static testmethod void testMainEntry(){
        GlUt_TriggerHandlerObj inputParam= new GlUt_TriggerHandlerObj ();
        inputParam.TriggerObject ='Account';
        inputParam.IsBefore = true;
        inputParam.IsInsert = true;
        GlUt_CentralDispatcher.MainEntry(inputParam);
        GlUt_CentralDispatcher.MainEntry(inputParam);
        
    }
    
    static testmethod void testInProgressEntry(){
    
    }

}
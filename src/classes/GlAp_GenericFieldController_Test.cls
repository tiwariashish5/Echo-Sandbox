/******************************************************************************
@author:      Accenture: Satish Nair
@date:        27th September 2017
@description: Test Class for GlAp_GenericFieldController
*******************************************************************************/

@isTest
Public Class GlAp_GenericFieldController_Test{


/******************************************************************************
@author:      Accenture: Satish Nair
@date:        27th September 2017
@description: Test data setup method
*******************************************************************************/
    @TestSetup
    Static void createTestData(){
        User objUser = GlUt_TestFactoryData.createUser('System Administrator','TestUser',null);
        Database.insert(objUser); 
        
        Account objAccount = GlUt_TestFactoryData.CreateAccount('TestAccount');
        Database.insert(objAccount);
        
        Contact con = GlUt_TestFactoryData.CreateContact('TestFirstName','TestLastName'); 
        Database.insert(con);
         
    }
    
/******************************************************************************
@author:      Accenture: Satish Nair
@date:        25th September 2017
@description: Test method for fetching the HH Accounts
*******************************************************************************/
    static testmethod void getHHAccount(){
        User objUser =[select id,name from user where isActive=true limit 1];
        List<Account> acc = [Select id,name from Account where name='TestAccount' Limit 1];
        system.assertEquals(acc.size()>0,true);
        system.runas(objUser){
        Test.startTest();
        GlAp_GenericFieldController.getObjectType(acc[0].Id);
        GlAp_GenericFieldController.getRecordName(acc[0].Id);
        Test.stopTest();
        }
    } 
}
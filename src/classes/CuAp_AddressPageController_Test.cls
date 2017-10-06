/******************************************************************************
@author:      Accenture: Shivangi Gaur
@date:        27 September 2017
@description: Test Class for CuAp_AddressPageController
*******************************************************************************/

@isTest
Public Class CuAp_AddressPageController_Test{
    
    //Variable declaration start
    
    private static String profileName = 'System Administrator';
    private static String userName = 'TestUser';
    private static String accName = 'TestAccount';
    private static String conFirstName = 'Test';
    private static String conLastName = 'Contact 101';
    private static String passwordField = 'ConsiderationPassword__c';
    private static String passwordData = 'New Password';
    private static String locationField = 'NumberofLocations__c';
    private static Integer locationData = 3;
    private static String accountObject = 'Account';
    private static String contactObject = 'Contact';
    
    //Variable declaration end

/******************************************************************************
@author:      Accenture: Shivangi Gaur
@date:        27 September 2017
@description: Test data setup method
*******************************************************************************/
    @TestSetup
    static void createTestData(){
        //Create user record
        User objUser = GlUt_TestFactoryData.createUser(profileName,userName,null);
        Database.insert(objUser); 

        //Create account record
        Account objAccount = GlUt_TestFactoryData.CreateAccount(accName);
        objAccount.NumberofLocations__c = locationData;
        Database.insert(objAccount);
        
        //Create contact record
        Contact objCon = GlUt_TestFactoryData.CreateContact(conFirstName,conLastName);
        objCon.ConsiderationPassword__c = passwordData;
        Database.insert(objCon);
    }
    
/******************************************************************************
@author:      Shivangi Gaur
@date:        27 September 2017
@description: Test method for retrieveLocationPropDetails() method
*******************************************************************************/
    static testmethod void retrieveLocationPropDetails_Positive(){
        
        //Query user record created in test setup data method
        User objUser = [Select id,name from user where isActive=true limit 1];
        
        //Run test class in user context
        System.runAs(objUser){
            List<GLAp_FieldProps> lstFieldProps = CuAp_AddressPageController.retrieveLocationPropDetails();
        }
    }
}
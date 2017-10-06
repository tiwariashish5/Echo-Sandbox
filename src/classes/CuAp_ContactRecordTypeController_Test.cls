/******************************************************************************
@author:      Accenture: Vivek Chauhan
@date:        05 September 2017
@description: Test Class for BlAp_GeneratePDFComponentCtrlr
*******************************************************************************/

@isTest
//test data creation for CuAp_ContactRecordTypeController_Test class
Public Class CuAp_ContactRecordTypeController_Test{
      private static final String USER_ALIAS = 'standt';
      private static final String USER_EMAIL = '@unitest.com';
      private static final String USER_UTF = 'UTF-8';
      private static final String USER_LNAME= 'UnitTest';
      private static final String USER_LAN_LOCALKEY= 'en_US';
      private static final String USER_TIMEZONEKEY= 'America/Los_Angeles';
      private static final String USER_PHONE = '1234567891';
      private static final String USER_MPHONE = '0111111111';
      private static String USER_PROFILE ='System Administrator';
      private static String USER_NAME ='TestUser'; 
      private static String ACCOUNT_NAME = 'TestAccount'; 
      private static String CONTRACT_NAME_ONE ='TestContract';
      private static String CONTRACT_NAME_SECOND ='TestContract2';
      private static String DEVICE_NAME = 'TestDevice';
      private static String DEVICE_TYPE ='TestDeviceType';
      private static String SUB_DEVICE_TYPE ='TestSubDevice';
      private static String TEST_SERVICE_TYPE ='TestServiceType';
      private static String LOCATION_NAME ='A99 9AA';
      private static String LOCATION_SUB_TYPE = 'Detached';
      private static String STREET = 'teststreet';
      private static String YES ='yes';
      private static String MEASURED = 'measured';
      private static String WHOLESALER ='TestWholesaler';
      private static String AVAILABLESERVICES ='TestAvailableService';
      private static String SERVICEITEMFAMILY ='TestServiceItemFamily';
      private static String SERVICEITEMTYPE ='TestServiceitemtype';
      private static String BUNDLE ='TestBundle';
      private static String AVAILABLEBUNDLE ='TestAvailableBundle';
      private static String BUNDLEITEM ='TestBundleItem';
      private static String AVAILABLESERVIEITEM='TestAvailableServiceItem';
      private static String SITESAMPLE ='Testsitesample';
      private static String SAMPLE ='TestSample';
      private static String AGREERATE ='TestAgreeRate';
      private static String BILL_NAME ='TestBill';
      private static Integer LIMIT1 =1;
      private static String RECORDTYPELABEL ='Household Contact';


      
    
/*******************************************************************
Purpose: method to create test data used by all test methods
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    
@TestSetup
    Static void createTestData(){
        User objUser = GlUt_TestFactoryData.createUser(USER_PROFILE ,USER_NAME ,null);
        Database.insert(objUser); 
        }
        
/*******************************************************************
Purpose: Method to test fetchRecordTypeValues method
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    static testmethod void fetchRecordTypeValuesTest(){
    User objuser = [select id from user limit 1];
    system.runas(objuser){
    list<String>lstRecordtypeIds = CuAp_ContactRecordTypeController.fetchRecordTypeValues();
    Id RecordTypeId = CuAp_ContactRecordTypeController.getRecTypeId(RECORDTYPELABEL);
    system.assert(lstRecordtypeIds!=null);
    system.assert(RecordTypeId!=null);
    }
 }
        
 }
/******************************************************************************
@author:      Accenture: Vivek Chauhan
@date:        05 September 2017
@description: Test Class for BlIn_BillCalcDataContainer
*******************************************************************************/

@isTest
//test data creation for BlIn_BillCalcDataContainer class
Public Class BlIn_BillCalcDataContainer_Test{
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
      private static Integer LIMIT1 =1;


      
    
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
        system.Runas(objUser){
        Account objAccount = GlUt_TestFactoryData.CreateAccount(ACCOUNT_NAME);
        Database.insert(objAccount);
        BillCalculation__c objBillCalculation = GlUt_TestFactoryData.createBillCalculation();
        Database.insert(objBillCalculation);
        Contract__c objContract = GlUt_TestFactoryData.CreateContract(CONTRACT_NAME_ONE,objAccount);
        objContract.BillCalculation__c = objBillCalculation.id;
        Contract__c objContract2 = GlUt_TestFactoryData.CreateContract(CONTRACT_NAME_SECOND ,objAccount);
        objContract2.BillCalculation__c = objBillCalculation.id;

        list<Contract__c >lstContract = new list<Contract__c>(); 
        lstContract.add(objContract);
        lstContract.add(objContract2);
        Database.insert(lstContract);
        DeviceType__c  objDeviceType = GlUt_TestFactoryData.CreateDeviceType(DEVICE_TYPE);
        Database.insert(objDeviceType);
        Device__c objDevice = GlUt_TestFactoryData.CreateDevice(DEVICE_NAME ,objDeviceType );
        Database.insert(objDevice);
        Device__c objsubDevice = GlUt_TestFactoryData.CreateDevice(SUB_DEVICE_TYPE ,objDeviceType );
        Database.insert(objsubDevice);
        ServiceType__c objServiceType = GlUt_TestFactoryData.CreateServiceType(TEST_SERVICE_TYPE );
        Database.insert(objServiceType);
        Reading__c  objReading = GlUt_TestFactoryData.CreateReading(objDevice);
        Database.insert(objReading);
        Reading__c  objReadingSecond = GlUt_TestFactoryData.CreateReading(objsubDevice);
        Database.insert(objReadingSecond);
        
        Location__c objLocation = GlUt_TestFactoryData.CreateLocation(LOCATION_NAME);
        objLocation.LocationSubType__c=LOCATION_SUB_TYPE ; 
        objLocation.Street__c =STREET ;
        Database.insert(objLocation);
        SupplyPoint__c  objSupplyPoint = GlUt_TestFactoryData.CreateSupplyPoint(objLocation);
        objSupplyPoint.Measured__c=YES ;
        objSupplyPoint.ReadFrequency__c = MEASURED;
        Database.insert(objSupplyPoint);
        Division__c  objDivision = GlUt_TestFactoryData.CreateDivision();
        Database.insert(objDivision);
        Wholesaler__c objWholesaler = GlUt_TestFactoryData.CreateWholesaler(WHOLESALER);
        Database.insert(objWholesaler);
        AvailableService__c  objAvailableService = GlUt_TestFactoryData.CreateAvailableService(AVAILABLESERVICES ,objDivision,objServiceType,objSupplyPoint,objWholesaler);
        Database.insert(objAvailableService);
        Service__c  objService = GlUt_TestFactoryData.CreateService(objContract,objReading,objServiceType,objSupplyPoint,objDevice,objAvailableService);
        Database.insert(objService);
        ServiceItemFamily__c  objServiceItemFamily = GlUt_TestFactoryData.CreateServiceItemFamily(SERVICEITEMFAMILY,objServiceType);
        Database.insert(objServiceItemFamily);
        ServiceItemType__c  objServiceItemType = GlUt_TestFactoryData.CreateServiceItemType(SERVICEITEMTYPE,objServiceItemFamily,objDivision,objDeviceType,objWholesaler);
        Database.insert(objServiceItemType);
        Bundle__c objBundle = GlUt_TestFactoryData.CreateBundle(BUNDLE,objServiceType);
        Database.insert(objBundle);
        AvailableBundle__c  objAvailableBundle = GlUt_TestFactoryData.CreateAvailableBundle(AVAILABLEBUNDLE,objBundle,objAvailableService);
        Database.insert(objAvailableBundle);
        BundleItem__c  objBundleItem = GlUt_TestFactoryData.CreateBundleItem(BUNDLEITEM,objBundle,objServiceItemType,objServiceItemFamily);
        Database.insert(objBundleItem);
        AvailableServiceItem__c  objAvailableServiceItem = GlUt_TestFactoryData.CreateAvailableServiceItem(AVAILABLESERVIEITEM,objBundleItem,objServiceItemType,objAvailableBundle);
        Database.insert(objAvailableServiceItem); 
        ServiceItem__c  objServiceItem = GlUt_TestFactoryData.CreateServiceItem(objAvailableServiceItem,objServiceItemType,objService);
        Database.insert(objServiceItem);
        DeviceRelationship__c  objDeviceRelationship = GlUt_TestFactoryData.CreateDeviceRelationship(objDevice,objsubDevice);
        Database.insert(objDeviceRelationship);
        SiteArea__c objSiteArea = GlUt_TestFactoryData.CreateSiteArea(SITESAMPLE ,objSupplyPoint);
        Database.insert(objSiteArea);
        Sample__c  objSample =GlUt_TestFactoryData.CreateSample(SAMPLE ,objSupplyPoint);
        Database.insert(objSample);
        AgreedRate__c  objAgreedRate =GlUt_TestFactoryData.CreateAgreedRate(AGREERATE,objServiceItem);
        Database.insert(objAgreedRate);
        }
           
    }
    
/*******************************************************************
Purpose: Method to test BlIn_BillCalcDataContainer  {Positive scenario}
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    static testmethod void BlIn_BillCalcDataContainer_Positive(){
     Contract__c objContract =[Select id,name from Contract__c limit  1 ];
     User objUser =[select id,name from user where isActive=true limit 1];
     BillCalculation__c objBillCalculation = [select id from BillCalculation__c];
     Id billCalculationId = objBillCalculation .id;
     List<Id>lstContractIds = new List<Id>();
     lstContractIds.add(objContract.id);
     system.Runas(objUser){
     Test.starttest();
     BlIn_BillCalcDataContainer objBlIn_BillCalcDataContainer = new BlIn_BillCalcDataContainer(billCalculationId); 
     system.assert(objBlIn_BillCalcDataContainer.billData!=null);

     Test.stoptest();
     }
    }
    
    
    
    
}
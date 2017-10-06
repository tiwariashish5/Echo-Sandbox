/******************************************************************************
@author:      Accenture: Sucharu Gupta
@date:        08 September 2017
@description: Test Class for BlIn_PDFPrepareBillData 
*******************************************************************************/

@isTest
//test data creation for BlIn_PDFPrepareBillData class
Public Class BlIn_PDFPrepareBillData_Test{
    public static final String PDF_TEMPLATE_NAME = 'pdfTemplateName';
    private static String USER_PROFILE ='System Administrator';
    private static String USER_NAME ='TestUser'; 
    private static String ACCOUNT_NAME = 'TestAccount'; 
    private static String CONTRACT_NAME ='TestContract';
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
    private static String BILLNAME = 'testBill';
    private static String BILLSERVICENAME = 'Test Bill Service';
    private static String BILLITEMNAME = 'Test Bill Item';
    private static String PAYMENTPLANNAME = 'Test Payment Plan Type';
    private static Integer VOLUMEUSED = 200;
    private static Integer BILLEDAMOUNT = 67878;
    private static String HEROKUPOSTGRESID = 'Test ID';
    private static Integer PLANAMOUNT = 56557;
    private static Integer NUMBEROFINSTALLMENTS =12;    
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
        
        Account objAccount = GlUt_TestFactoryData.CreateAccount(ACCOUNT_NAME);
        Database.insert(objAccount);
        
        Contract__c con = GlUt_TestFactoryData.CreateContract(CONTRACT_NAME,objAccount); 
        Database.insert(con);
        
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
        
        Service__c  objService = GlUt_TestFactoryData.CreateService(con,objReading,objServiceType,objSupplyPoint,objDevice,objAvailableService);
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
        
        Bill__c objBill = GlUt_TestFactoryData.CreateBill(BILLNAME ,con);
        objBill.CustomerNumber__c = objAccount.id; 
        Database.insert(objBill);
        
        BillServiceType__c objBillServiceType = GlUt_TestFactoryData.createBillServiceType(BILLSERVICENAME, objBill, HEROKUPOSTGRESID);
        Database.insert(objBillServiceType);
        
        BillItem__c objBillItems = GlUt_TestFactoryData.createBillItem(BILLITEMNAME, objServiceItem , VOLUMEUSED ,BILLEDAMOUNT, objBillServiceType, HEROKUPOSTGRESID);
        Database.insert(objBillItems);
        
        PaymentPlanType__c objPaymentPlanType = GlUt_TestFactoryData.createPaymentPlanType(PAYMENTPLANNAME);
        Database.insert(objPaymentPlanType);
        
        PaymentPlan__c objPaymentPlan = GlUt_TestFactoryData.createPaymentPlan(objPaymentPlanType,con,PLANAMOUNT,NUMBEROFINSTALLMENTS);
        Database.insert(objPaymentPlan);
    }
    
/*******************************************************************
Purpose: Method to test object node added to the XML parent {Positive scenario}
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    static testmethod void addToXmlDoc_Positive(){
        User objUser =[select id,name from user where isActive=true limit 1];
        Bill__c objBill =[Select id from Bill__c limit 1];
        system.runas(objUser){
        Test.startTest();
        BlIn_PDFPrepareBillData objBlInPDFPrepareBillData = new BlIn_PDFPrepareBillData(objBill.id, PDF_TEMPLATE_NAME);
        Test.stopTest();
        system.assertNotEquals(null,objBlInPDFPrepareBillData);
        }
    }
}
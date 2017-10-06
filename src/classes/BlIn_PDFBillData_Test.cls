/******************************************************************************
@author:      Accenture: Sucharu Gupta
@date:        25 September 2017
@description: Test Class for BlIn_PDFBillData 
*******************************************************************************/

@isTest
//test data creation for BlIn_PDFBillData class
Public Class BlIn_PDFBillData_Test{
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
    private static String ACTUALDEVICEREADING = 'ActualDeviceReading__c';
    private static String DEVICEREFERENCE = 'DeviceReference__r.SerialNo__c';
    private static String GROSSCONSUMPTION ='GrossConsumption__c';  
    private static String READING = 'Reading__c';  
    private static String READINGDATE = 'ReadingDate__c'; 
    private static String READER ='Reader__c';
    private static String FIELDVALUE = 'Test';
    private static String SERVICE = 'Service__c';
    private static String DEVICE = 'Device__c'; 
    private static String SUPPLYPOINT = 'SupplyPoint__c';
    private static String SERVICETYPENAME = 'ServiceType__r.Name'; 
    private static String DEVICESERIAL = 'Device__r.SerialNo__c';
    private static String SUPPLYLOCATION = 'SupplyPoint__r.Location__r.PostalZIPCode__c';
    private static String CONTRACT = 'Contract__c';
    private static String TESTNAME = 'Name';
    private static String TESTDEVICEREFERENCE = 'DeviceReference__c';
    
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
Purpose: Method to test record's parent in the XML data structure
         and adds the record to the correct parent record 
         (Positive scenario)
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
 
    static testmethod void addChildRecord_PositiveTest(){
        User objUser =[select id,name from user where isActive=true limit 1];
        Service__c  objService = [select id, name from Service__c limit 1 ];
        Reading__c  objReading = [select id from Reading__c limit 1 ];
        
        // Parent Record Data
        
        Set<String> idFields1 = new set<String>{};
        Set<String> XMLFields1 = new Set<String>{ACTUALDEVICEREADING, DEVICEREFERENCE, GROSSCONSUMPTION,READING,  READINGDATE,READER};
        Map<String, String> fieldMap1 = new Map<String, String>();
        fieldMap1.put(READER,FIELDVALUE);
        fieldMap1.put(SERVICE, objService.name);
        Set<Id> parentIds1 = new Set<Id>{objReading.id};
        
        //Record To Add Data
        
        Set<String> idFields2 = new set<String>{DEVICE, SUPPLYPOINT};
        Set<String> XMLFields2 = new Set<String>{SERVICETYPENAME,DEVICESERIAL,SUPPLYLOCATION};
        Map<String, String> fieldMap2 = new Map<String, String>();
        fieldMap2.put(SERVICETYPENAME,FIELDVALUE);
        Set<Id> parentIds2 = new Set<Id>{objReading.id, objService.id};
        
        BlIn_PDFBillData.XMLObject objXML2 = new BlIn_PDFBillData.XMLObject( SERVICE,CONTRACT,CONTRACT,idFields2, XMLFields2);
        
        BlIn_PDFBillData.XMLRecord objXMLRecord2 = new BlIn_PDFBillData.XMLRecord(objXML2);
        
        List<BlIn_PDFBillData.XMLRecord> xmlLst2 = new List<BlIn_PDFBillData.XMLRecord>();
        xmlLst2.add(objXMLRecord2);
        
        Map<String,List<BlIn_PDFBillData.XMLRecord>> objectListMap2 = new Map<String,List<BlIn_PDFBillData.XMLRecord>>();
        objectListMap2.put(TESTNAME, xmlLst2);
        
        objXMLRecord2.name = objXML2.name;
        objXMLRecord2.parentName = objXML2.parentName;
        objXMLRecord2.fieldMap = fieldMap2;
        objXMLRecord2.parentIds = parentIds2;
        objXMLRecord2.objectListMap = objectListMap2;
        objXMLRecord2.parentLookup = objReading.id;
        
        //End of Child XML Record
        
        BlIn_PDFBillData.XMLObject objXML1 = new BlIn_PDFBillData.XMLObject(READING, SERVICE, TESTDEVICEREFERENCE, idFields1, XMLFields1);
        
        BlIn_PDFBillData.XMLRecord objXMLRecord1 = new BlIn_PDFBillData.XMLRecord(objXML1);
        
        List<BlIn_PDFBillData.XMLRecord> xmlLst1 = new List<BlIn_PDFBillData.XMLRecord>();
        xmlLst1.add(objXMLRecord1);
        
        Map<String,List<BlIn_PDFBillData.XMLRecord>> objectListMap1 = new Map<String,List<BlIn_PDFBillData.XMLRecord>>();
        objectListMap1.put(SERVICE, xmlLst2);
        objXMLRecord1.name = objXML1.name;
        objXMLRecord1.parentName = objXML1.parentName;
        objXMLRecord1.fieldMap = fieldMap1;
        objXMLRecord1.parentIds = parentIds1;
        objXMLRecord1.objectListMap = objectListMap1;
        
        system.runas(objUser){
            Test.startTest();
            BlIn_PDFBillData objPDF = new BlIn_PDFBillData();
            boolean b = objPDF.addChildRecord(objXMLRecord1,objXMLRecord2);
            Test.stopTest();
        }
    } 
    
/*******************************************************************
Purpose: Method to test record's parent in the XML data structure
         and adds the record to the correct parent record (Negative Scenario)
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
 
    static testmethod void addChildRecord_NegativeTest(){
        User objUser =[select id,name from user where isActive=true limit 1];
        Service__c  objService = [select id, name from Service__c limit 1 ];
        Reading__c  objReading = [select id from Reading__c limit 1 ];
        
        // Parent Record Data
        
        Set<String> idFields1 = new set<String>{};
        Set<String> XMLFields1 = new Set<String>{ACTUALDEVICEREADING,DEVICEREFERENCE,GROSSCONSUMPTION, READING,READINGDATE,READER};
        Map<String, String> fieldMap1 = new Map<String, String>();
        fieldMap1.put(READER, FIELDVALUE);
        fieldMap1.put(SERVICE, objService.name);
        Set<Id> parentIds1 = new Set<Id>{objReading.id};
        
        //Record To Add Data
        
        Set<String> idFields2 = new set<String>{DEVICE,SUPPLYPOINT};
        Set<String> XMLFields2 = new Set<String>{SERVICETYPENAME,DEVICESERIAL, SUPPLYLOCATION};
        Map<String, String> fieldMap2 = new Map<String, String>();
        fieldMap2.put(SERVICETYPENAME,FIELDVALUE);
        Set<Id> parentIds2 = new Set<Id>{objReading.id, objService.id};
        
        BlIn_PDFBillData.XMLObject objXML2 = new BlIn_PDFBillData.XMLObject(SERVICE,CONTRACT,CONTRACT,idFields2, XMLFields2);
        
        BlIn_PDFBillData.XMLRecord objXMLRecord2 = new BlIn_PDFBillData.XMLRecord(objXML2);
        
        List<BlIn_PDFBillData.XMLRecord> xmlLst2 = new List<BlIn_PDFBillData.XMLRecord>();
        xmlLst2.add(objXMLRecord2);
        
        Map<String,List<BlIn_PDFBillData.XMLRecord>> objectListMap2 = new Map<String,List<BlIn_PDFBillData.XMLRecord>>();
        objectListMap2.put(TESTNAME, xmlLst2);
        
        objXMLRecord2.name = objXML2.name;
        objXMLRecord2.parentName = objXML2.parentName;
        objXMLRecord2.fieldMap = fieldMap2;
        objXMLRecord2.parentIds = parentIds2;
        objXMLRecord2.objectListMap = objectListMap2;
        objXMLRecord2.parentLookup = objReading.id;
        
        //End of Child XML Record
        
        BlIn_PDFBillData.XMLObject objXML1 = new BlIn_PDFBillData.XMLObject(READING,SERVICE,TESTDEVICEREFERENCE, idFields1, XMLFields1);
        
        BlIn_PDFBillData.XMLRecord objXMLRecord1 = new BlIn_PDFBillData.XMLRecord(objXML1);
        
        List<BlIn_PDFBillData.XMLRecord> xmlLst1 = new List<BlIn_PDFBillData.XMLRecord>();
        xmlLst1.add(objXMLRecord1);
        
        Map<String,List<BlIn_PDFBillData.XMLRecord>> objectListMap1 = new Map<String,List<BlIn_PDFBillData.XMLRecord>>();
        objectListMap1.put(READING, xmlLst2);
        objXMLRecord1.name = objXML1.name;
        objXMLRecord1.parentName = objXML1.parentName;
        objXMLRecord1.fieldMap = fieldMap1;
        objXMLRecord1.parentIds = parentIds1;
        objXMLRecord1.objectListMap = objectListMap1;
        
        system.runas(objUser){
            Test.startTest();
            BlIn_PDFBillData objPDF = new BlIn_PDFBillData();
            boolean b = objPDF.addChildRecord(objXMLRecord1,objXMLRecord2);
            Test.stopTest();
        }
    }
    
/*******************************************************************
Purpose: Method to test record's parent in the XML data structure
         and adds the record to the correct parent record
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
 
    static testmethod void addChildRecord_Test(){
        User objUser =[select id,name from user where isActive=true limit 1];
        Set<String> idFields1 = new set<String>();
        Set<String> XMLFields1 = new Set<String>();
        Map<String, String> fieldMap1 = new Map<String, String>();
        Set<Id> parentIds1 = new Set<Id>();
        
        //Adding child Xml Record
        
        Set<String> idFields2 = new set<String>();
        Set<String> XMLFields2 = new Set<String>();
        Map<String, String> fieldMap2 = new Map<String, String>();
        Set<Id> parentIds2 = new Set<Id>();
        
        BlIn_PDFBillData.XMLObject objXML2 = new BlIn_PDFBillData.XMLObject(SERVICE,CONTRACT,CONTRACT, idFields2, XMLFields2);
        
        BlIn_PDFBillData.XMLRecord objXMLRecord2 = new BlIn_PDFBillData.XMLRecord(objXML2);
        
        List<BlIn_PDFBillData.XMLRecord> xmlLst2 = new List<BlIn_PDFBillData.XMLRecord>();
        
        Map<String,List<BlIn_PDFBillData.XMLRecord>> objectListMap2 = new Map<String,List<BlIn_PDFBillData.XMLRecord>>();
        
        objXMLRecord2.name = objXML2.name;
        objXMLRecord2.parentName = objXML2.parentName;
        objXMLRecord2.fieldMap = fieldMap2;
        objXMLRecord2.parentIds = parentIds2;
        objXMLRecord2.objectListMap = objectListMap2;
        
        //End of Child XML Record
        
        BlIn_PDFBillData.XMLObject objXML1 = new BlIn_PDFBillData.XMLObject(READING,SERVICE, TESTDEVICEREFERENCE, idFields1, XMLFields1);
        
        BlIn_PDFBillData.XMLRecord objXMLRecord1 = new BlIn_PDFBillData.XMLRecord(objXML1);
        
        List<BlIn_PDFBillData.XMLRecord> xmlLst1 = new List<BlIn_PDFBillData.XMLRecord>();
        
        Map<String,List<BlIn_PDFBillData.XMLRecord>> objectListMap1 = new Map<String,List<BlIn_PDFBillData.XMLRecord>>();
        objXMLRecord1.name = objXML1.name;
        objXMLRecord1.parentName = objXML1.parentName;
        objXMLRecord1.fieldMap = fieldMap1;
        objXMLRecord1.parentIds = parentIds1;
        objXMLRecord1.objectListMap = objectListMap1;
        
        system.runas(objUser){
            Test.startTest();
            BlIn_PDFBillData objPDF = new BlIn_PDFBillData();
            boolean b = objPDF.addChildRecord(objXMLRecord1,objXMLRecord2);
            Test.stopTest();
        }
    }

/*******************************************************************
Purpose: Method to test object node added to the XML parent {Positive scenario}
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    static testmethod void addObjectRecord_PositiveTest(){
        User objUser =[select id,name from user where isActive=true limit 1];
        Bill__c objBill =[Select id from Bill__c limit 1];
        system.runas(objUser){
        Test.startTest();
        BlIn_PDFPrepareBillData objBlInPDFPrepareBillData = new BlIn_PDFPrepareBillData(objBill.id, PDF_TEMPLATE_NAME);
        Test.stopTest();
        system.assertNotEquals(null,objBlInPDFPrepareBillData);
        }
    }
    
/*******************************************************************
Purpose: Method to test object node added to the XML parent {Negative scenario}
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
 
    static testmethod void addObjectRecord_NegativeTest(){
        User objUser =[select id,name from user where isActive=true limit 1];
        Set<String> idFields1 = new set<String>();
        Set<String> XMLFields1 = new Set<String>();
        Map<String, String> fieldMap1 = new Map<String, String>();
        Set<Id> parentIds1 = new Set<Id>();
        
        //Adding child Xml Record
        
        Set<String> idFields2 = new set<String>();
        Set<String> XMLFields2 = new Set<String>();
        Map<String, String> fieldMap2 = new Map<String, String>();
        Set<Id> parentIds2 = new Set<Id>();
        
        BlIn_PDFBillData.XMLObject objXML2 = new BlIn_PDFBillData.XMLObject(SERVICE,CONTRACT,CONTRACT, idFields2, XMLFields2);
        
        BlIn_PDFBillData.XMLRecord objXMLRecord2 = new BlIn_PDFBillData.XMLRecord(objXML2);
        
        List<BlIn_PDFBillData.XMLRecord> xmlLst2 = new List<BlIn_PDFBillData.XMLRecord>();
        
        Map<String,List<BlIn_PDFBillData.XMLRecord>> objectListMap2 = new Map<String,List<BlIn_PDFBillData.XMLRecord>>();
        
        objXMLRecord2.name = objXML2.name;
        objXMLRecord2.parentName = objXML2.parentName;
        objXMLRecord2.fieldMap = fieldMap2;
        objXMLRecord2.parentIds = parentIds2;
        objXMLRecord2.objectListMap = objectListMap2;
        
        //End of Child XML Record
        
        BlIn_PDFBillData.XMLObject objXML1 = new BlIn_PDFBillData.XMLObject(READING,SERVICE,TESTDEVICEREFERENCE, idFields1, XMLFields1);
        
        BlIn_PDFBillData.XMLRecord objXMLRecord1 = new BlIn_PDFBillData.XMLRecord(objXML1);
        
        List<BlIn_PDFBillData.XMLRecord> xmlLst1 = new List<BlIn_PDFBillData.XMLRecord>();
        
        Map<String,List<BlIn_PDFBillData.XMLRecord>> objectListMap1 = new Map<String,List<BlIn_PDFBillData.XMLRecord>>();
        objXMLRecord1.name = objXML1.name;
        objXMLRecord1.parentName = objXML1.parentName;
        objXMLRecord1.fieldMap = fieldMap1;
        objXMLRecord1.parentIds = parentIds1;
        objXMLRecord1.objectListMap = objectListMap1;
        
        system.runas(objUser){
            Test.startTest();
            BlIn_PDFBillData objPDF = new BlIn_PDFBillData();
            boolean b = objPDF.addObjectRecord(objXMLRecord2);
            Test.stopTest();
        }
    }

}
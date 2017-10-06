/******************************************************************************
@author:      Accenture: Manish Singh
@date:        07 September 2017
@description: Test Class for GlUt_ReadingHandler
*******************************************************************************/
@isTest
Public Class GlUt_ReadingHandler_Test{
    private static string accountName1 = 'Test Account1';
    private static string contractName = 'Test Contract';
    private static string testDeviceType = 'TestDeviceType';
    private static string testsubDevice =    'TestsubDevice';
    private static string testServiceType ='TestServiceType';
    private static string location= 'A99 9AA';
    private static string detached = 'Detached';
    private static string customerName = 'Test customer';
    private static string STRTEST ='test';
    private static string measured= 'measured';
    private static string YES = 'yes';
    private static string DEVICENAME= 'TestDeviceName';
    private static User dummyUser;
    private static integer actualReading = 20;
    private static integer actualDeviceReading = 120;
    private static integer readingDate = 12;
    private static integer listSize = 200;
    private static integer listStart = 0;
    private static integer dailyUseInsertedSize = 1;
    public static String profileName = 'System Administrator';
    public static String userName = 'TestUser';
    
    /*******************************************************************
    Purpose: method to create test data used by all test methods
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/    
    @TestSetup
    Static void createTestData(){  

        User objUser = GlUt_TestFactoryData.createUser(profileName,userName,null);
        Database.insert(objUser);
        
        Account objAccount = GlUt_TestFactoryData.CreateAccount(accountName1);
        Database.insert(objAccount);
        Contract__c objContract = GlUt_TestFactoryData.CreateContract(contractName ,objAccount);
        Database.insert(objContract);
        DeviceType__c  objDeviceType = GlUt_TestFactoryData.CreateDeviceType(testDeviceType );
        Database.insert(objDeviceType);        
        Location__c objLocation = GlUt_TestFactoryData.CreateLocation(location);
        objLocation.LocationSubType__c=detached ; 
        objLocation.Street__c =STRTEST ;
        Database.insert(objLocation);
        list<Device__c > listDevice = new list<Device__c >();
            for(integer i=listStart; i<listSize; i++){
                listDevice.add(GlUt_TestFactoryData.CreateDevice(DEVICENAME,objDeviceType) );
            }
        Database.insert(listDevice);
        SupplyPoint__c  objSupplyPoint = GlUt_TestFactoryData.CreateSupplyPoint(objLocation);
        objSupplyPoint.Measured__c=YES;
        objSupplyPoint.ReadFrequency__c =measured;
        Database.insert(objSupplyPoint);
        list<Reading__c> listReading = new list<Reading__c>();
        list<SupplyPointDevice__c > listSupplyPointDevice = new list<SupplyPointDevice__c >();
        for(integer i=listStart; i<listSize; i++){
            listSupplyPointDevice.add(GlUt_TestFactoryData.CreateSupplyPointDevices(listDevice[i], objSupplyPoint ));
            Reading__c  objReading = GlUt_TestFactoryData.CreateReading(listDevice[i]);
            objReading.ActualDeviceReading__c= actualReading;
            objReading.ReadingDate__c = Date.today();
            listReading.add(objReading);
        }
        
        Database.insert(listSupplyPointDevice);
        Database.insert(listReading);
        
    }
    
    /*******************************************************************
    Purpose: Bulk testing Method to insert average daily uses records while 
             new reading is captured.
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testmethod void calAvgDailyUses_Bulk(){
        User dummyUser = [select id,name from user where isActive=true limit 1];
        system.runAs(dummyUser){
            list<Device__c> listDevice = new list<Device__c>([Select Id from Device__c]); 
            list<Reading__c> listReading = new List<Reading__c>();           
            Test.startTest();
            for(integer i=listStart; i<listSize; i++){
                Reading__c  objReading = GlUt_TestFactoryData.CreateReading(listDevice[i]);
                objReading.ActualDeviceReading__c= actualDeviceReading;
                objReading.ReadingDate__c = Date.today()+readingDate;
                listReading.add(objReading);
            }
            Database.insert(listReading);      
            
            list<AverageDailyUse__c> listDailyUse = [Select Id from AverageDailyUse__c ];
            Test.StopTest();
            system.assertEquals(listDailyUse .size(), listSize);
        }
    }
    
    /*******************************************************************
    Purpose: Method to insert average daily uses records while new reading is captured.
             {Positive scenario}
    Parameters: N/A 
    Returns: void
    Throws [Exceptions]: N/A
    ********************************************************************/
    static testmethod void calAvgDailyUses_Positive(){
        User dummyUser =[select id,name from user where isActive=true limit 1];
        system.runAs(dummyUser){            
            Device__c device = [Select Id from Device__c limit 1];            
            Test.startTest();
            Reading__c  objReading = GlUt_TestFactoryData.CreateReading(device );
            objReading.ActualDeviceReading__c= actualDeviceReading;
            objReading.ReadingDate__c = Date.today()+readingDate; 
            Database.insert(objReading);
            GlUt_TriggerHandlerObj dataHandler = new GlUt_TriggerHandlerObj();
            GlUt_ReadingHandler readingHandler = new GlUt_ReadingHandler();
            Test.StopTest();
            list<AverageDailyUse__c> listDailyUse = [Select Id from AverageDailyUse__c ];
            system.assertEquals(listDailyUse.size(), dailyUseInsertedSize);
        }
    }
}
/******************************************************************************
@author        Accenture: Vivek Chauhan
@date          5 Sep 2017
@description   This is global class which will be used to created data of various object for 
test classes.
@version    
@Accenture Sucharu-- Date 6 Sept'17 -- Added method createUser for user creation
*******************************************************************************/
  
  public with sharing class GlUt_TestFactoryData {
      private static final String USER_ALIAS = 'standt';
      private static final String USER_EMAIL = '@unitest.com';
      private static final String USER_UTF = 'UTF-8';
      private static final String USER_LNAME= 'UnitTest';
      private static final String USER_LAN_LOCALKEY= 'en_US';
      private static final String USER_TIMEZONEKEY= 'America/Los_Angeles';
      private static final String USER_PHONE = '1234567891';
      private static final String USER_MPHONE = '0111111111';
  
  
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         string sName
  @return        Account - objAccount
  @description   Create Account  object instance and return it.
  *******************************************************************************/
  public static Account CreateAccount(string sName){
    Account objAccount = new Account(Name=sName,BillingStreet='testBillingStreet',BillingCity='testBillingCity',BillingState='testBillingState',BillingCountry='testBillingCountry',
                                      BillingPostalCode='testPostcode',ShippingStreet='testShippingStreet ',ShippingCity='testShippingCity',ShippingState='testShippingState',ShippingCountry='ShippingCountry',ShippingPostalCode='testPostCode');
    return objAccount;
  }
  
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         string sFirstName, string sLastName
  @return        Contact  - con
  @description   Create contact object instance and return it.
  *******************************************************************************/
  public static Contact CreateContact(string sFirstName, string sLastName){
    Contact con = new Contact(FirstName=sFirstName, LastName=sLastName);
    return con;
  }
  
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         string-sName,Account objAccount
  @return        Contract  - objContract
  @description   Create Contract object instance and return it.
  *******************************************************************************/
  public static Contract__c CreateContract(string sName,Account objAccount){
    Contract__c objContract = new Contract__c(CustomerName__c =objAccount.id ,BillingFrequency__c='Monthly',DebtRecoveryProfile__c='Standard HH Debt Recovery Process');
    return objContract;
  }
  
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         string-sName
  @return        DeviceType__c - objDeviceType
  @description   Create DeviceType__c  object instance and return it.
  *******************************************************************************/
  public static DeviceType__c CreateDeviceType(string sName){
    DeviceType__c objDeviceType = new DeviceType__c (Name = sName,DeviceSize__c='10mm',Manufacturer__c='Kent',UnitOfMeasure__c='Metric' );
    return objDeviceType;
  }
  
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         string-sName
  @return        Device__c - objDevice
  @description   Create Device__c object instance and return it.
  *******************************************************************************/
  public static Device__c CreateDevice(string sName, DeviceType__c objDeviceType){
    Device__c objDevice = new Device__c (DeviceType__c= objDeviceType.id,MaximumReading__c=1000.00,Digit__c=10  );
    return objDevice;
  }

 /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         string-sName
  @return        ServiceType__c- objServiceType
  @description   Create ServiceType__c object instance and return it.
  *******************************************************************************/
  public static ServiceType__c CreateServiceType(string sName){
    ServiceType__c objServiceType = new ServiceType__c(Name = sName,ServiceTypeDescription__c='testdescription');
    return objServiceType;
  }

 /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String -sName,Device__c objDevice
  @return        Reading__c- objReading  
  @description   Create Reading__c object instance and return it.
  *******************************************************************************/
  public static Reading__c CreateReading(Device__c objDevice){
    Reading__c  objReading  = new Reading__c (DeviceReference__c =objDevice.id);
    return objReading ;
  }

/******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String -sName  
  @return        Location__c  - objLocation    
  @description   Create Location__c    object instance and return it.
  *******************************************************************************/
  public static Location__c CreateLocation(string sZipcode){
    Location__c objLocation  = new Location__c(PostalZIPCode__c= sZipcode,LocationType__c='Domestic');
    return objLocation;
  }

/******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String -sName,Location__c objLocation  
  @return        SupplyPoint__c  - objSupplyPoint
  @description   Create SupplyPoint__c  object instance and return it.
  *******************************************************************************/
  public static SupplyPoint__c CreateSupplyPoint(Location__c objLocation){
    SupplyPoint__c objSupplyPoint  = new SupplyPoint__c(Location__c= objLocation.id,Description__c='testsupplypoint');
    return objSupplyPoint;
  }
  
  
/******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         none  
  @return        Division__c - objDivision
  @description   Create Division__c object instance and return it.
  *******************************************************************************/
  public static Division__c CreateDivision(){
    Division__c objDivision  = new Division__c(ChargingArea__c= 'STW - Lower Severn',ChargingDivision__c='Lower Severn');
    return objDivision;
  }
  
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String-sName
  @return        Division__c - objDivision
  @description   Create Division__c object instance and return it.
  *******************************************************************************/
  public static Wholesaler__c CreateWholesaler(String sName){
    Wholesaler__c  objWholesaler   = new Wholesaler__c (Name = sName);
    return objWholesaler;
  }
  
  
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String-sName
  @return        AvailableService__c- objAvailableService   
  @description   Create AvailableService__c object instance and return it.
  *******************************************************************************/
  public static AvailableService__c CreateAvailableService(String sName ,Division__c objDivision,ServiceType__c objServiceType,SupplyPoint__c objSupplyPoint,Wholesaler__c  objWholesalers){
    AvailableService__c objAvailableService   = new AvailableService__c (Name = sName,Division__c = objDivision.id,ServiceType__c =objServiceType.id,SupplyPoint__c =objSupplyPoint.id,Wholesalers__c =objWholesalers.id);
    return objAvailableService;
  }
  
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String-sName
  @return        Service__c - objService   
  @description   Create Service__c object instance and return it.
  *******************************************************************************/
  public static Service__c CreateService(Contract__c objContract,Reading__c objReading,ServiceType__c objServiceType,SupplyPoint__c objSupplyPoint,Device__c objDevice,AvailableService__c objAvailableService){
    Service__c objService   = new Service__c(ServiceType__c =objServiceType.id,SupplyPoint__c =objSupplyPoint.id,AvailableService__c=objAvailableService.id,Device__c= objDevice.id,Contract__c=objContract.id );
    return objService;
  }
  
  /******************************************************************************
  @author        Accenture: Sucharu Gupta
  @date          06 Sep 2017
  @param         String,String,Id
  @return        User   
  @description   Used for creating the User
  *******************************************************************************/
    
    public static User createUser (String profileName, String uName,ID mgrId){
            UserRole r = [Select Id From UserRole limit 1 ]; //where Name = 'All Echo User'
            Profile prof = [select id from Profile where Name =:profileName LIMIT :1];
            User newUser = new User(alias = USER_ALIAS, 
                                    email=uName+USER_EMAIL, 
                                    emailencodingkey=USER_UTF,
                                    lastname=USER_LNAME,
                                    languagelocalekey=USER_LAN_LOCALKEY, 
                                    localesidkey=USER_LAN_LOCALKEY, 
                                    profileid = prof.Id, 
                                    timezonesidkey=USER_TIMEZONEKEY,
                                    username= uName+USER_EMAIL,
                                    isActive=true);
            if(mgrId != null){
                newUser.ManagerId = mgrId;
            }
            newUser.Phone = USER_PHONE;
            newUser.MobilePhone =USER_MPHONE; 
            return newUser;
                
    }
    
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String-sName
  @return        ServiceItemFamily__c - objServiceItemFamily   
  @description   Create     ServiceItemFamily__c object instance and return it.
  *******************************************************************************/
  public static  ServiceItemFamily__c CreateServiceItemFamily(String sName,ServiceType__c objServiceType){
    ServiceItemFamily__c objServiceItemFamily  = new ServiceItemFamily__c(Name =sName,ServiceType__c=objServiceType.id);
    return objServiceItemFamily;
  }
  
    /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String-sName
  @return        ServiceItemType__c - objServiceItemType  
  @description   Create ServiceItemFamily__c object instance and return it.
  *******************************************************************************/
  public static     ServiceItemType__c CreateServiceItemType(String sName, ServiceItemFamily__c objServiceItemFamily,Division__c objDivision,DeviceType__c  objDeviceType,Wholesaler__c  objWholesaler){
    ServiceItemType__c objServiceItemType  = new ServiceItemType__c(Name =sName,Division__c=objDivision.id,ServiceItemFamily__c=objServiceItemFamily.id,ServiceCompany__c=objWholesaler.id);
    return objServiceItemType;
  }
   /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String-sName,ServiceType__c-objServiceType
  @return        Bundle__c - objBundle
  @description   Create     Bundle__c object instance and return it.
  *******************************************************************************/
  public static  Bundle__c CreateBundle(String sName,ServiceType__c objServiceType){
    Bundle__c objBundle  = new Bundle__c(Name =sName,ServiceType__c=objServiceType.id);
    return objBundle;
  }
  
     /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String-sName,Bundle__c -objBundle,AvailableService__c -objAvailableService
  @return        AvailableBundle__c- objAvailableBundle
  @description   Create AvailableBundle__c object instance and return it.
  *******************************************************************************/
  public static  AvailableBundle__c CreateAvailableBundle(String sName,Bundle__c  objBundle,AvailableService__c  objAvailableService){
    AvailableBundle__c objAvailableBundle  = new AvailableBundle__c(Name =sName,Bundle__c =objBundle.id,AvailableService__c=objAvailableService.id);
    return objAvailableBundle;
  }
  
  
       /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String-sName,Bundle__c -objBundle,AvailableService__c -objAvailableService
  @return        BundleItem__c - objBundleItem  
  @description   Create BundleItem__c object instance and return it.
  *******************************************************************************/
  public static  BundleItem__c CreateBundleItem(String sName,Bundle__c  objBundle,ServiceItemType__c objServiceItemType,ServiceItemFamily__c  objServiceItemFamily){
    BundleItem__c objBundleItem  = new BundleItem__c(Name =sName,Bundle__c =objBundle.id,ServiceItemFamily__c=objServiceItemFamily.id,ServiceItemType__c=objServiceItemType.id);
    return objBundleItem ;
  }
  
   
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String-sName,Bundle__c -objBundle,AvailableService__c -objAvailableService
  @return        AvailableServiceItem__c - objAvailableServiceItem
  @description   Create AvailableServiceItem__c  object instance and return it.
  *******************************************************************************/
  public static  AvailableServiceItem__c CreateAvailableServiceItem (String sName,BundleItem__c  objBundleItem,ServiceItemType__c objServiceItemType,AvailableBundle__c objAvailableBundle){
    AvailableServiceItem__c objAvailableServiceItem  = new AvailableServiceItem__c(Name =sName,AvailableBundle__c=objAvailableBundle.id,BundleItem__c=objBundleItem.id);
    return objAvailableServiceItem ;
  }
  
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         String-sName,Bundle__c -objBundle,AvailableService__c -objAvailableService
  @return        ServiceItem__c - objServiceItem 
  @description   Create AvailableServiceItem__c  object instance and return it.
  *******************************************************************************/
  public static  ServiceItem__c CreateServiceItem (AvailableServiceItem__c objAvailableServiceItem,ServiceItemType__c objServiceItemType,Service__c objService){
    ServiceItem__c objServiceItem  = new ServiceItem__c(AvailableServiceItems__c=objAvailableServiceItem.id,ServiceItemType__c=objServiceItemType.id,Service__c=objService.id);
    return objServiceItem ;
  }
  
   /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         Device__c objmaindevice,Device__c objsubdevice  
  @return        DeviceRelationship__c - objDeviceRelationship  
  @description   Create DeviceRelationship__c  object instance and return it.
  *******************************************************************************/
  public static  DeviceRelationship__c CreateDeviceRelationship (Device__c objmaindevice,Device__c objsubdevice){
    DeviceRelationship__c objDeviceRelationship  = new DeviceRelationship__c(MainDevice__c=objmaindevice.id,SubDevice__c=objsubdevice.id);
    return objDeviceRelationship;
  }
  
   /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          05 Sep 2017
  @param         Device__c objmaindevice,Device__c objsubdevice  
  @return        DeviceRelationship__c - objDeviceRelationship  
  @description   Create DeviceRelationship__c  object instance and return it.
  *******************************************************************************/
  public static  SupplyPointDevice__c CreateSupplyPointDevices (Device__c device ,SupplyPoint__c supplypoint){
    SupplyPointDevice__c supplyPointDevices = new SupplyPointDevice__c (Device__c=device.Id ,SupplyPoint__c = supplypoint.Id, 
        InstallationDate__c = system.today(), RemovalDate__c = system.today()+10);
        
    return supplyPointDevices ;
  }
  
  
     /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          07 Sep 2017
  @param         String sName ,SupplyPoint__c objsupplypoint  
  @return        Sample__c - objSample
  @description   Create Sample__c object instance and return it.
  *******************************************************************************/
  public static  Sample__c CreateSample (String sName ,SupplyPoint__c objsupplypoint){
    Sample__c  objSample= new Sample__c (Name=sName,SupplyPoint__c= objsupplypoint.Id);

    return objSample;
  }
  
  
  
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          07 Sep 2017
  @param         String sName ,SupplyPoint__c objsupplypoint  
  @return        SiteArea__c - objSiteArea
  @description   Create SiteArea__c  object instance and return it.
  *******************************************************************************/
  public static  SiteArea__c CreateSiteArea (String sName ,SupplyPoint__c objsupplypoint){
    SiteArea__c objSiteArea = new SiteArea__c (Name=sName,SupplyPoint__c= objsupplypoint.Id);

    return objSiteArea;
  }
  
     /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          07 Sep 2017
  @param         String sName ,ServiceItem__c objServiceItem
  @return        AgreedRate__c - objAgreedRate
  @description   Create AgreedRate__c  object instance and return it.
  *******************************************************************************/
  public static  AgreedRate__c CreateAgreedRate (String sName ,ServiceItem__c objServiceItem){
    AgreedRate__c objAgreedRate = new AgreedRate__c(ServiceItem__c= objServiceItem.Id);

    return objAgreedRate;
  }
  
  /******************************************************************************
  @author        Accenture: Sucharu Gupta
  @date          12 Sep 2017
  @param         String sName
  @return        string jsonStr
  @description   Create Billing Calculation JSON
  *******************************************************************************/
  Public static string createJson (string str1) {
    String jsonStr = '{"bills" :['+ '{"extId": 12,"CustomerNumber":12345,"ContractNumber":6889, "BilledAmount":568,"TotalDue" : 678, "BillItems" :[{"extId": 34,"VolumeUsed":978,"ChargeBasisValue":898979,"FromDate":"2017-09-06T16:58:54.858Z", "ToDate":"2017-10-04T16:58:54.858Z","BilledAmount":7867}]}]}';      
    return jsonStr; 
  }
  
  /******************************************************************************
  @author        Accenture: Sucharu Gupta
  @date          12 Sep 2017
  @param         Dom.Document - billPDFDataXML
  @return        Dom.Document - doc
  @description   Create Billing PDF
  *******************************************************************************/
   Public static Dom.Document createBillPDFDataXML () {
       Dom.Document doc = new Dom.Document();
       return doc;
   }
   
  /******************************************************************************
  @author        Accenture: Sucharu Gupta
  @date          12 Sep 2017
  @param         string-sName, Contract__c objContract 
  @return        Bill__c  - objBill
  @description   Create Bill__c object instance and return it.
  *******************************************************************************/
  
  public static Bill__c createBill(string sName,Contract__c objContract){
      Bill__c objBill = new Bill__c(Name = sName, ContractNumber__c = objContract.id, BilledAmount__c = 567, HerokuPostgresId__c = 'id123',
      TotalDue__c = 6788, BillDate__c = date.newInstance(2017, 09, 17));
      return objBill; 
    }
    
  /******************************************************************************
  @author        Accenture: Vivek Chauhan
  @date          21 Sep 2017
  @param         None
  @return        BillCalculation__c - objBillCalculation
  @description   Create BillCalculation__c object instance and return it.
  *******************************************************************************/
  
  public static BillCalculation__c  createBillCalculation(){
      BillCalculation__c objBillCalculation = new BillCalculation__c(RequestDate__c = system.today(),Status__c='Pending');
      return objBillCalculation ; 
    }
  
  /******************************************************************************
  @author        Accenture: Sucharu Gupta
  @date          26 Sep 2017
  @param         string sName, Bill__c  objBill, string 
                 HerokuPostgresId
  @return        BillServiceType__c -- objBillServiceType
  @description   Create BillServiceType__c object instance and return it.
  *******************************************************************************/
    Public static BillServiceType__c createBillServiceType(string sName, Bill__c  objBill, string 
    HerokuPostgresId){
        BillServiceType__c objBillServiceType = new BillServiceType__c(Name = sName, Bill__c = objBill.id, HerokuPostgresId__c = HerokuPostgresId);
        return objBillServiceType;
    }
      
  /******************************************************************************
  @author        Accenture: Sucharu Gupta
  @date          26 Sep 2017
  @param         string sName, ServiceItem__c objServiceItem, Integer VolumeUsed , 
                 Integer BilledAmount ,   BillServiceType__c objBillServiceType , string HerokuPostgresId
  @return        BillItem__c -- objBillItems
  @description   Create BillItem__c object instance and return it.
  *******************************************************************************/
  Public static BillItem__c createBillItem(string sName, ServiceItem__c objServiceItem, Integer VolumeUsed , Integer BilledAmount , BillServiceType__c objBillServiceType , string HerokuPostgresId){
      BillItem__c objBillItems = new BillItem__c(Name = sName, ServiceItem__c = objServiceItem.id, VolumeUsed__c = VolumeUsed, BilledAmount__c = BilledAmount, BillServiceType__c = objBillServiceType.id, HerokuPostgresId__c = HerokuPostgresId);
      objBillItems.From__c = system.Today();
      objBillItems.To__c = system.Today();
      return objBillItems;  
  }
  
  /******************************************************************************
  @author        Accenture: Sucharu Gupta
  @date          26 Sep 2017
  @param         string sName
  @return        PaymentPlanType__c -- objPaymentPlanType
  @description   Create PaymentPlanType__c object instance and return it.
  *******************************************************************************/
  public static PaymentPlanType__c createPaymentPlanType(string sName){
      PaymentPlanType__c objPaymentPlanType = new PaymentPlanType__c(Name = sName);
      return objPaymentPlanType;  
    }
    
  /******************************************************************************
  @author        Accenture: Sucharu Gupta
  @date          26 Sep 2017
  @param         string sName
  @return        PaymentPlan__c -- objPaymentPlan
  @description   Create PaymentPlan__c object instance and return it.
  *******************************************************************************/
  public static PaymentPlan__c createPaymentPlan(PaymentPlanType__c objPaymentPlanType, Contract__c objContract, Integer PlanAmount, Integer NumberOfInstalments){
      PaymentPlan__c objPaymentPlan = new PaymentPlan__c(PaymentPlanType__c = objPaymentPlanType.id, 
        ContractOrder__c = objContract.id, PlanAmount__c = PlanAmount, NumberOfInstalments__c = NumberOfInstalments);
      return objPaymentPlan;  
    }
  /******************************************************************************
  @author        Accenture: Manish
  @date          03 Oct 2017
  @param         string sName
  @return        HerokuSecurity__c -- objPaymentPlan
  @description   Create HerokuSecurity__c object instance and return it.
  *******************************************************************************/
  public static HerokuSecurity__c createHerokuSecurity(String AuthenticationToken){
      HerokuSecurity__c objHerokuSecurity = new HerokuSecurity__c(Name= USER_LNAME,AuthenticationToken__c=AuthenticationToken);
      return objHerokuSecurity;  
    }
 
 }
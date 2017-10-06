// TO DO
// Logger
// try catch
// limits on SOQL eg Dates, Active flag etc???

/******************************************************************************
@author         Accenture: Patrick Dixon
@date           29 Aug 2017
@description    A data transfer object (DTO) class used to create an instance 
                of the data extracted from Salesforce records to format the 
                JSON message which is passed to the bill calculation REST service
*******************************************************************************/
/******************************************************************************
                Object Hierarchy
                ----------------
				BillCalculation__c
				->	BlIn_BillCalcObj
	                BlIn_BillCalcContractObj
		            Contract__c
	                    ->	BlIn_BillCalcServiceObj
	                        Service__c
	                        (-> SupplyPoint__c)
	                            ->  BlIn_BillCalcServSiteAreaObj
	                                SiteAreas__c
	                            ->  BlIn_BillCalcSamplesObj
	                                Samples__c
	                            (-> AvailableServices__c)
	                                ->  BlIn_BillCalcServCrgBasisObj
	                                    ChargeBases__c
	                        ->	BlIn_BillCalcServiceItemObj
	                            ServiceItems__c
	                            ->  BlIn_BillCalcServItmAgreedRateObj
	                                AgreedRates__c
	                        ->	BlIn_BillCalcServDeviceObj
	                            Device__c
	                            ->  BlIn_BillCalcServReadingObj
	                                Readings__c
	                            ->  BlIn_BillCalcServSubDeviceObj
	                                SubDevices__c
	                                ->  BlIn_BillCalcServReadingObj
	                                    Readings__c
                                    
*******************************************************************************/
public with sharing class BlIn_BillCalcDataContainer {
	
	// utility methods used to format date and datetime fields for json as yyyy-MM-dd HH:mm:ss
	public static String dateToString(Date d) {return d != null ? String.valueOf(d) + ' 00:00:00' : '2000-01-01 00:00:00';}
	public static String dateToString(DateTime dt) {return dt != null ? String.valueOf(dt) : '2000-01-01 00:00:00';}
	   
    @TestVisible private BlIn_BillCalcObj billData;

    // the records required for the billing data payload
    private BillCalculation__c billCalculation;
    private List<Contract__c> contracts;
    private List<Service__c> services;      // includes related service item records
    private List<SupplyPoint__c> supplyPoints;      // includes related site area and sample records
    private List<AvailableService__c> availableServices;        // includes related charge basis records
    private List<AgreedRate__c> agreedRates;
    private List<Device__c> devices;        // includes related reading records
    private List<Device__c> subDevices;     // includes related reading records
    
    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           29 Aug 2017
    @param          Id - contract Id
    @description    Constructor
    *******************************************************************************/
    public BlIn_BillCalcDataContainer(Id billCalculationId) {

        List<Id> contractIds = new List<Id>();

        // get the bill calculation record and the list of related contract Ids
        for (BillCalculation__c billCalculation : [select Id,
														Status__c,
														RequestDate__c,

        												(select Id from Contracts__r) 

        											from BillCalculation__c 
        											where Id = :billCalculationId]) {

        	for (Contract__c contract : billCalculation.Contracts__r) {
        		contractIds.add(contract.Id);
        	}
        	this.billCalculation = billCalculation;
        	break;		// one only
        }

        /* STEP 1: get all the data records required */

        // get the contract records
        contracts = getContracts(contractIds);

        // get all the related service/service items records
        services = getServices(contractIds);
        
        // get all the related agreed rate records
        agreedRates = getAgreedRates(contractIds);

        // get all the supply point related records
        supplyPoints = getSupplyPoints(contractIds);
                                            
        // get all the available services related records
        availableServices = getAvailableServices(contractIds);

        // get all the related devices and their device relationships and readings records
        devices = getDevices(contractIds);

        // and build a set of all the devices' sub device Ids
        Set<Id> subDeviceIds = new Set<Id>();
        for (Device__c device : devices) {
            for (DeviceRelationship__c subDevice : device.DeviceRelationships__r) {
                subDeviceIds.add(subDevice.SubDevice__c);
            }
        }
        
        // so we can get all the sub devices and their related readings records
        subDevices = getDevices(true, subDeviceIds);

        /* STEP 2: build the data using the DTO hierachy */

        billData = new BlIn_BillCalcObj(this, billCalculation);
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           04 Sep 2017
    @return         List<BlIn_BillCalcContractObj> - structured bill data
    @description    gets the structured bill data
    *******************************************************************************/
    public BlIn_BillCalcObj getBillData() {
        return billData;
    }
        
    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           18 Sep 2017
    @description    Subclass for Contract
    *******************************************************************************/
    public class BlIn_BillCalcObj {
    	
    	private String CalculationId;
    	private String Status;
        private List<BlIn_BillCalcContractObj> Contracts;

        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           18 Sep 2017
        @param          BlIn_BillCalcDataContainer - container class instance
        @param          BillCalculation__c - bill calculation record
        @description    Constructor
        *******************************************************************************/
        public BlIn_BillCalcObj(BlIn_BillCalcDataContainer container, BillCalculation__c billCalculation) {
        	
            // add the contract fields to this DTO
            CalculationId = billCalculation.Id;
            Status = billCalculation.Status__c;
            
            // build the list of contract DTOs
            Contracts = new List<BlIn_BillCalcContractObj>();
            for (Contract__c contract : container.contracts) {
                Contracts.add(new BlIn_BillCalcContractObj(container, contract));
            }
        }            
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           29 Aug 2017
    @description    Subclass for Contract
    *******************************************************************************/
    private class BlIn_BillCalcContractObj {
        
        private String ContractId;
        private String CustomerName;
        private String LastBillCalculationDate;
        private String ContractEndDate;
        private String ContractStartDate;
        private List<BlIn_BillCalcServiceObj> Services;

        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           29 Aug 2017
        @param          BlIn_BillCalcDataContainer - container class instance
        @param          Contract__c - contract record
        @description    Constructor
        *******************************************************************************/
        public BlIn_BillCalcContractObj(BlIn_BillCalcDataContainer container, Contract__c contract) {
            
            // add the contract fields to this DTO
            ContractId = contract.Id;
            CustomerName = contract.CustomerName__r.Name;
            ContractStartDate = dateToString(contract.StartDate__c);
            ContractEndDate = dateToString(contract.EndDate__c);
            LastBillCalculationDate = dateToString(contract.LastBillCalculationDate__c);
            
            // build the list of service DTOs
            Services = new List<BlIn_BillCalcServiceObj>();
            for (Service__c service : container.services) {
                if (service.Contract__c == contract.Id) {
                    Services.add(new BlIn_BillCalcServiceObj(container, service));
                }
            }
        }
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           04 Sep 2017
    @param          List<Id> - contract Ids
    @return         List<Contract__c> - contracts
    @description    gets the contract records
    *******************************************************************************/
    private List<Contract__c> getContracts(List<Id> contractIds) {
        return [select Id, 
                        CustomerName__c,
                        CustomerName__r.Name,
                        StartDate__c,
                        EndDate__c,
                        LastBillCalculationDate__c, 

                        (select Id from Services__r)
                                                
                from Contract__c 
                where Id in :contractIds];
    }
    
    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           29 Aug 2017
    @description    Subclass for Service
    *******************************************************************************/
    private class BlIn_BillCalcServiceObj {
        
        private String ServiceId;
        private String ServiceTypeId;
        private List<BlIn_BillCalcServDeviceObj> ServiceDevices;
        private List<BlIn_BillCalcServiceItemObj> ServiceItems;
        private List<BlIn_BillCalcServCrgBasisObj> ServiceChargeBases;
        private List<BlIn_BillCalcServSiteAreaObj> ServiceSiteAreas;
        private List<BlIn_BillCalcSamplesObj> ServiceSamples;   

        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           29 Aug 2017
        @param          BlIn_BillCalcDataContainer - instance of the container class
        @param          Service__c - service record
        @description    Constructor
        *******************************************************************************/
        public BlIn_BillCalcServiceObj(BlIn_BillCalcDataContainer container, Service__c service) {
            
            // add the service fields to this DTO
            ServiceId = service.Id;
            ServiceTypeId = service.ServiceType__c;
            
            // build the list of device DTOs
            ServiceDevices = new List<BlIn_BillCalcServDeviceObj>();
            for (Device__c device : container.devices) {
                ServiceDevices.add(new BlIn_BillCalcServDeviceObj(container, device));
            }
            
            // build the list of service item DTOs
            ServiceItems = new List<BlIn_BillCalcServiceItemObj>();
            for (ServiceItem__c serviceItem : service.ServiceItems__r) {
                ServiceItems.add(new BlIn_BillCalcServiceItemObj(container, serviceItem));
            }

            // build the list of charge basis DTOs
            ServiceChargeBases = new List<BlIn_BillCalcServCrgBasisObj>();
            for (AvailableService__c availableService: container.availableServices) {
                if (service.SupplyPoint__c == availableService.SupplyPoint__c) {

                    for (ChargeBasis__c chargeBasis : availableService.ChargeBases__r)
                        ServiceChargeBases.add(new BlIn_BillCalcServCrgBasisObj(container, chargeBasis));
                }
            }

            // build the lists of site area and sample DTOs
            ServiceSiteAreas = new List<BlIn_BillCalcServSiteAreaObj>();
            ServiceSamples = new List<BlIn_BillCalcSamplesObj>();

            for (SupplyPoint__c supplyPoint : container.supplyPoints) {
                if (supplyPoint.Id == service.SupplyPoint__c) {
                        
                    for (SiteArea__c siteArea : supplyPoint.SiteAreas__r) {
                        ServiceSiteAreas.add(new BlIn_BillCalcServSiteAreaObj(container, siteArea));
                    }
                        
                    for (Sample__c sample : supplyPoint.Samples__r) {
                        ServiceSamples.add(new BlIn_BillCalcSamplesObj(container, sample));
                    }
                }
            }
        }
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           04 Sep 2017
    @param          List<Id> - contract Ids
    @return         List<Service__c> - services
    @description    gets the service and related service item records
    *******************************************************************************/
    private List<Service__c> getServices(List<Id> contractIds) {
        return  [select Id, 
                        Contract__c, 
                        ServiceType__c,
                        Device__c,
                        SupplyPoint__c, 
                                                
                        (select Id,  
                            ServiceItemType__c, 
                            StartDate__c, 
                            EndDate__c, 
                            Quantity__c 
                        from ServiceItems__r)
                                            
                from Service__c 
                where Contract__c in :contractIds];
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           29 Aug 2017
    @description    Subclass for Service Item
    *******************************************************************************/
    private class BlIn_BillCalcServiceItemObj {

        private String ServiceItemId;
        private String ServiceItemTypeId;
        private String StartDate;
        private String EndDate;
        private Decimal Quantity;
        private List<BlIn_BillCalcServItmAgreedRateObj> ServiceItemAgreedRates;

        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           29 Aug 2017
        @param          BlIn_BillCalcDataContainer - instance of the container class
        @param          ServiceItem__c - serviceItem record
        @description    Constructor
        *******************************************************************************/
        public BlIn_BillCalcServiceItemObj(BlIn_BillCalcDataContainer container, ServiceItem__c serviceItem) {
            
            // add the service item fields to this DTO
            StartDate = dateToString(serviceItem.StartDate__c);
            EndDate = dateToString(serviceItem.EndDate__c);
            ServiceItemId = serviceItem.Id;
            ServiceItemTypeId = serviceItem.ServiceItemType__c;
            Quantity = serviceItem.Quantity__c;

            // build the list of related agreed rate DTOs
            ServiceItemAgreedRates = new List<BlIn_BillCalcServItmAgreedRateObj>();
            for (AgreedRate__c agreedRate : container.agreedRates) {
                if (agreedRate.ServiceItem__c == serviceItem.Id) {
                    ServiceItemAgreedRates.add(new BlIn_BillCalcServItmAgreedRateObj(container, agreedRate));
                }
            }
        }
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           29 Aug 2017
    @description    Subclass for Service Item Agreed Rate
    *******************************************************************************/
    private class BlIn_BillCalcServItmAgreedRateObj {

        private Id AgreedRateId;
        private String StartDate;
        private String EndDate;
        private Decimal Value;

        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           31 Aug 2017
        @param          BlIn_BillCalcDataContainer - instance of the container class
        @param          AgreedRate__c - agreedRate record
        @description    Constructor
        *******************************************************************************/
        public BlIn_BillCalcServItmAgreedRateObj(BlIn_BillCalcDataContainer container, AgreedRate__c agreedRate) {
            
            // add the agreed rate fields to this DTO
            AgreedRateId = agreedRate.Id;
            StartDate = dateToString(agreedRate.StartDate__c);
            EndDate = dateToString(agreedRate.EndDate__c);
            Value = agreedRate.Value__c;
        }
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           04 Sep 2017
    @param          List<Id> - contract Ids
    @return         List<AgreedRate__c> - agreed rates
    @description    gets the agreed rate records
    *******************************************************************************/
    private List<AgreedRate__c> getAgreedRates(List<Id> contractIds) {
        return [select Id, 
                        ServiceItem__r.Service__r.Contract__c, 
                        ServiceItem__c, 
                        Value__c,
                        StartDate__c,
                        EndDate__c 
                from AgreedRate__c 
                where ServiceItem__r.Service__r.Contract__c in :contractIds];
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           29 Aug 2017
    @description    Subclass for Device
    *******************************************************************************/
    private class BlIn_BillCalcServDeviceObj {

        private Id ServiceDeviceId;
//      TDB I2+
        private List<BlIn_BillCalcServSubDeviceObj> SubDevices;
        private List<BlIn_BillCalcServReadingObj> ServiceReadings;  

        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           30 Aug 2017
        @param          BlIn_BillCalcDataContainer - instance of the container class
        @param          Device__c - device record
        @description    Constructor
        *******************************************************************************/
        public BlIn_BillCalcServDeviceObj(BlIn_BillCalcDataContainer container, Device__c device) {

            // add the sub device fields to this DTO
            ServiceDeviceId = device.Id;
            // TDB I2+

            // build the list of related sub devices DTOs
            SubDevices = new List<BlIn_BillCalcServSubDeviceObj>();
            for (Device__c subDevice : container.subDevices) {
                for (DeviceRelationship__c relationship : device.DeviceRelationships__r) {
                    if (relationship.MainDevice__c == device.Id) {
                        SubDevices.add(new BlIn_BillCalcServSubDeviceObj(container, subDevice));
                    }
                }
            }

            // build the list of related readings DTOs
            ServiceReadings = new List<BlIn_BillCalcServReadingObj>();  
            for (Reading__c reading : device.Readings__r) {
                ServiceReadings.add(new BlIn_BillCalcServReadingObj(container, reading));
            }
        }
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           04 Sep 2017
    @param          List<Id> - contract Ids
    @return         List<Device__c> - devices
    @description    gets the devices, their device relationships and readings records
    *******************************************************************************/
    private List<Device__c> getDevices(List<Id> contractIds) {
        return getDevices(false, new Set<Id>(contractIds));
    }
    
    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           05 Sep 2017
    @param          Boolean - isSubDevicesQuery (uses device Ids rather than contract ids)
    @param          Set<Id> - Ids (contract Ids for main devices, device Ids for sub devices)
    @return         List<Device__c> - devices
    @description    gets the devices, their device relationships and readings records
    *******************************************************************************/
    private List<Device__c> getDevices(Boolean isSubDevicesQuery, Set<Id> ids) {

        String query =  Database.getQueryLocator(
                            [select Id, 
                                    Name, 
            
                                    (select Id, 
                                            MainDevice__c,
                                            MainDevice__r.Name, 
                                            SubDevice__c, 
                                            SubDevice__r.Name 
                                    from DeviceRelationships__r),
            
                                    (select Id, 
                                            DeviceReference__c,
                                            Reading__c,ReadingDate__c 
                                    from Readings__r)
                                                        
                                from Device__c]
                            ).getQuery();

        // add 'where' clause depending on query context
        query += isSubDevicesQuery ? ' where Id in :ids' : ' where Id in (select Device__c from Service__c where Contract__c =:ids)';
        return Database.query(query);
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           29 Aug 2017
    @description    Subclass for Sub Device
    *******************************************************************************/
    private class BlIn_BillCalcServSubDeviceObj {

        private Id ServiceDeviceId;
//      TDB I2+
        private List<BlIn_BillCalcServReadingObj> ServiceReadings;  

        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           31 Aug 2017
        @param          BlIn_BillCalcDataContainer - instance of the container class
        @param          Device__c - sub device record
        @description    Constructor
        *******************************************************************************/
        public BlIn_BillCalcServSubDeviceObj(BlIn_BillCalcDataContainer container, Device__c subDevice) {
            
            // add the sub device fields to this DTO
            ServiceDeviceId = subDevice.Id;
            // TDB I2+

            // build the list of related readings DTOs
            ServiceReadings = new List<BlIn_BillCalcServReadingObj>();  
            for (Reading__c reading : subDevice.Readings__r) {
                ServiceReadings.add(new BlIn_BillCalcServReadingObj(container, reading));
            }
        }
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           29 Aug 2017
    @description    Subclass for Reading
    *******************************************************************************/
    private class BlIn_BillCalcServReadingObj {
        
        private Id ServiceReadingId;
        private Decimal Reading;
        private String ReadingDate;

        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           30 Aug 2017
        @param          BlIn_BillCalcDataContainer - instance of the container class
        @param          Reading__c - reading record
        @description    Constructor
        *******************************************************************************/
        public BlIn_BillCalcServReadingObj(BlIn_BillCalcDataContainer container, Reading__c reading) {
            
            // add the reading fields to this DTO
            ServiceReadingId = reading.Id;
            this.Reading = reading.Reading__c;
            ReadingDate = dateToString(reading.ReadingDate__c);
        }
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           29 Aug 2017
    @description    Subclass for Charging Basis
    *******************************************************************************/
    private class BlIn_BillCalcServCrgBasisObj {

        private Id ServiceChargeBasisId;
//      TDB I2+

        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           31 Aug 2017
        @param          BlIn_BillCalcDataContainer - instance of the container class
        @param          ChargeBasis__c - charge basis record
        @description    Constructor
        *******************************************************************************/
        public BlIn_BillCalcServCrgBasisObj(BlIn_BillCalcDataContainer container, ChargeBasis__c chargeBasis) {
            
            // add the charge basis fields to this DTO
            ServiceChargeBasisId = chargeBasis.Id;
            // TDB I2+
        }
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           04 Sep 2017
    @param          List<Id> - contract Ids
    @return         List<AvailableService__c> - availableServices
    @description    gets all the available services related related records
    *******************************************************************************/
    private List<AvailableService__c> getAvailableServices(List<Id> contractIds) {
        return [select Id, 
                        SupplyPoint__c, 

                        (select Id from ChargeBases__r)

                from AvailableService__c
                where Id in (select AvailableService__c from Service__c where Contract__c in :contractIds)];
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           29 Aug 2017
    @description    Subclass for Site Area
    *******************************************************************************/
    private class BlIn_BillCalcServSiteAreaObj {

        private Id ServiceSiteAreaId;
//      TDB I2+

        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           31 Aug 2017
        @param          BlIn_BillCalcDataContainer - instance of the container class
        @param          SiteArea__c - site area record
        @description    Constructor
        *******************************************************************************/
        public BlIn_BillCalcServSiteAreaObj(BlIn_BillCalcDataContainer container, SiteArea__c siteArea) {
            
            // add the site area fields to this DTO
            ServiceSiteAreaId = siteArea.Id;
            // TDB I2+
        }
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           29 Aug 2017
    @description    Subclass for Sample
    *******************************************************************************/
    private class BlIn_BillCalcSamplesObj {

        private Id SampleId;
//      TDB I2+

        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           31 Aug 2017
        @param          BlIn_BillCalcDataContainer - instance of the container class
        @param          Sample__c - sample record
        @description    Constructor
        *******************************************************************************/
        public BlIn_BillCalcSamplesObj(BlIn_BillCalcDataContainer container, Sample__c sample) {
            
            // add the sample fields to this DTO
            SampleId = sample.Id;
            // TDB I2+
        }
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           04 Sep 2017
    @param          List<Id> - contract Ids
    @return         List<SupplyPoint__c> - subDevices
    @description    gets all the supply point related records
    *******************************************************************************/
    private List<SupplyPoint__c> getSupplyPoints(List<Id> contractIds) {
        return [select Id, 
                        
                        (select Id from SiteAreas__r),
                        (select Id from Samples__r)
                                                
                from SupplyPoint__c 
                where Id in (select SupplyPoint__c from Service__c where Contract__c = :contractIds)];
    }
}
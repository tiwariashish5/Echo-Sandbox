/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		15 Sep 2017
@description 	Class to define the objects, fields and relationships that will 
				be used to construct the PDF XML data records submitted to the  
				the PDF generation webservice
*******************************************************************************/
public with sharing class BlIn_PDFXMLDefinition {
	
	// list of XMLObjects used to generate the PDF data
	public List<BlIn_PDFBillData.XMLObject> XMLObjects;
	
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		15 Sep 2017
	@description 	Constructor
	*******************************************************************************/
	public BlIn_PDFXMLDefinition() {
    	
    	// define a list of XML objects
		XMLObjects = new List<BlIn_PDFBillData.XMLObject>{
		
			/* Bill */
			new BlIn_PDFBillData.XMLObject(
			
					'Bill__c', 				/* Object API name */
					null, 					/* Parent object API name */
					null, 					/* Parent Id field */
					new Set<String>{		/* Id fields used to match object records*/
									'CustomerNumber__c', 		// Account
									'ContractNumber__c' 		// Contract__c
									}, 
					new Set<String>{		/* XML fields */
									'BillDate__c', 
									'Name', 
									'TotalDue__c' 
									} 
					),
		
			/* Bill Items */
			new BlIn_PDFBillData.XMLObject(
			
					'BillItem__c', 				/* Object API name */
					'Bill__c', 					/* Parent object API name */
					'BillServiceType__r.Bill__c', 					/* Parent Id field */
					new Set<String>(),			/* Id fields used to match object records*/
					new Set<String>{		/* XML fields */
									'ServiceItem__r.Name', 
									'VolumeUsed__c', 
									'NumberOfDays__c', 
									'RateBand__r.Rate__c', 
									'BilledAmount__c'//, 
//									'VATAmount__c' 
									} 
					),
		
			/* Account */
			new BlIn_PDFBillData.XMLObject(
			
					'Account', 				/* Object API name */
					null, 					/* Parent object API name */
					null, 					/* Parent Id field */
					new Set<String>(), 		/* Id fields used to match object records*/
					new Set<String>{		/* XML fields */
									'Email__c', 
									'Fax', 
									'Website', 
									'VATRegistrationNumber__c' 
									} 	
					),

			/* Contract */
			new BlIn_PDFBillData.XMLObject(
			
					'Contract__c', 			/* Object API name */
					null, 					/* Parent object API name */
					null, 					/* Parent Id field */
					new Set<String>(), 		/* Id fields used to match object records*/
					new Set<String>{		/* XML fields */
									'Name', 
									'BillingAddress__c', 
									'BillingFrequency__c'  
									} 
					),

			/* Payment Plans */
			new BlIn_PDFBillData.XMLObject(
			
					'PaymentPlan__c', 			/* Object API name */
					'Contract__c', 			/* Parent object API name */
					'ContractOrder__c', 			/* Parent Id field */
					new Set<String>(), 		/* Id fields used to match child object records*/
					new Set<String>{		/* XML fields */
									'DayOfWeek__c',
									'DayOfMonth__c', 
									'PaymentFrequency__c', 
									'PaymentPlanType__r.Name', 
									'PlanAmount__c', 
									'StartDate__c'  
									} 
					),

			/* Services */
			new BlIn_PDFBillData.XMLObject(
			
					'Service__c', 			/* Object API name */
					'Contract__c', 			/* Parent object API name */
					'Contract__c', 			/* Parent Id field */
					new Set<String>{ 		/* Id fields used to match child object records*/
									'Device__c', 		// Device__c
									'SupplyPoint__c'		// SupplyPoint__c
									}, 
					new Set<String>{		/* XML fields */
									'ServiceType__r.Name',
									'Device__r.SerialNo__c', 
									'SupplyPoint__r.Location__r.PostalZIPCode__c'  
									} 
					),

			/* Readings */
			new BlIn_PDFBillData.XMLObject(
			
					'Reading__c', 			/* Object API name */
					'Service__c', 			/* Parent object API name */
					'DeviceReference__c', 	/* Parent Id field */
					new Set<String>(), 		/* Id fields used to match child object records*/
					new Set<String>{		/* XML fields */
									'ActualDeviceReading__c', 
									'DeviceReference__r.SerialNo__c', 
									'GrossConsumption__c', 
									'Reading__c', 
									'ReadingDate__c', 
									'ReadingType__c'  
									} 
					)
		};
	}
}
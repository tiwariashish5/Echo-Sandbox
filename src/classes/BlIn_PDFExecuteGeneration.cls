/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		08 Sep 2017
@description 	Class for PDF callout
*******************************************************************************/
public with sharing class BlIn_PDFExecuteGeneration {
    
	public static final String CLASS_NAME = 'BlAp_CalculateBillComponentCtrlr';
	public static final String DEBUG = '[' + CLASS_NAME + '] ';

	public static final Integer PDF_GENERATION_TIMEOUT = 2000;		// ms

	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		08 Sep 2017
	@param			Id - bill Id
	@param			String - PDF template name
	@return			Id - attachment Id
	@description 	HEROKU callout to generate a PDF
	*******************************************************************************/
	public static Id executePDF(Id billId) {
		
		String PDFId;
		String PDFTemplateName = 'PDFFormBillTemplate001';		// TO-DO - get this by querying the contract record

//		try {
			
			/* STEP 1: extract all the object records required */
			system.debug(DEBUG + 'EXTRACTING RECORDS ...');
	
			// prepare the bill data
			BlIn_PDFPrepareBillData prepareData = new BlIn_PDFPrepareBillData(billId, PDFTemplateName);
	
			/* STEP 2: build the XML output using the object records */
			system.debug(DEBUG + 'BUILDING XML ...');
	
			// create the XML payload
			BlIn_PDFCreateBillDataXML XMLData = new BlIn_PDFCreateBillDataXML(prepareData.billData);
			
			// setup the document variables
			String documentsRoot = 'Billing';		// TO-DO - get from custom metadata
			String documentDate = String.valueOf(date.today());
			Bill__c bill;
			for (Bill__c b : [select Id, 
									Name 
								from Bill__c
								where Id = :billId]) {
				bill = b;
			}

			/* STEP 3: call the webservice */
			system.debug(DEBUG + 'CALL WEBSERVICE ...');
	
			Http http = new Http();
			HttpRequest request = new HttpRequest();
			
			// retrieve Heroku REST endpoint from custom metadata
			String endPoint;
			for (EnvironmentSettings__mdt settings : [select PDFGenerationEndpoint__c 
														from EnvironmentSettings__mdt]) {
	
				endPoint = settings.PDFGenerationEndpoint__c;
				break;
			}
	
			// retrieve Heroku authentication token from protected custom setting
			String token;
			for (HerokuSecurity__c security : [select AuthenticationToken__c 
														from HerokuSecurity__c]) {
	
				token = security.AuthenticationToken__c;
				break;
			}

			// setup GET request
			request.setMethod('POST');		// TO-DO - GET or POST???
			request.setEndpoint(endPoint);
			request.setCompressed(true);
			request.setHeader(BlIn_Constants.ACCESS_TOKEN, token);		// token stored in protected custom setting
			request.setHeader(BlIn_Constants.CLIENT_SYSTEM_ID, UserInfo.getOrganizationId());		// org Id
			request.setHeader('Content-Type', 'application/xml');
			request.setBody(XMLData.XMLDocument.toXMLString());		// XML data
			request.setTimeout(PDF_GENERATION_TIMEOUT);		// timeout in ms
			
			// invoke the GET endpoint using the Http class
			HttpResponse response = http.send(request);
			
			// handle response
	        if (response.getStatusCode() == 201 && response.getBody() != null) {
	        	
				// save returned pdf as a content document and link it to the bill
				PDFId = GlUt_ContentDocument.saveLinkedDocument(billId, 
																documentsRoot + '/Bill PDFs', 
																'Bill pdf', 
																bill.Name + '-' + bill.Id + '-'  + documentDate + '.pdf', 
																response.getBodyAsBlob());
//																Blob.valueOf(response.getBody()));
	
			} else {
			    System.debug(DEBUG + 'Error response: ' + response.getStatusCode() + ' ' + response.getStatus());
//				throw new AuraHandledException('The pdf generation request returned an error: ' + response.getStatus());		// TO-DO - temp for debug
			}

			system.debug(DEBUG + 'SAVING DOCUMENT ...');
			
			// save the XML as a content document and link it to the bill
			Id XMLId = GlUt_ContentDocument.saveLinkedDocument(billId,
																documentsRoot + '/Bill Data XMLs', 
																'Bill data', 
																bill.Name + '-' + bill.Id + '-'  + documentDate + '.xml', 
																Blob.valueOf(XMLData.XMLDocument.toXMLString()));
				
//		} catch (exception e) {
//			throw new AuraHandledException(e.getMessage());
//		}
		
		// return the pdf Id
		return PDFId;
	}
}
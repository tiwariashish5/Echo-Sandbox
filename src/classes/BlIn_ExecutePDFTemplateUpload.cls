/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		01 Sep 2017
@description 	Class for billing callout
*******************************************************************************/
public with sharing class BlIn_ExecutePDFTemplateUpload {

	public static final String CLASS_NAME = 'BlIn_ExecutePDFTemplateUpload';
	public static final String DEBUG = '[' + CLASS_NAME + '] ';
	
	public static final Integer PDF_TEMPLATE_UPLOAD_TIMEOUT = 2000;		// ms
    
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		29 Sep 2017
	@param			Id - bill calculation Id
	@return			Boolean - success
	@description 	HEROKU REST callout to upload a PDF Template to Heroku
	*******************************************************************************/
	public static Boolean UploadTemplate(Id documentId) {
		
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		
		// retrieve Heroku REST endpoint from custom metadata
		String endPoint;
		for (EnvironmentSettings__mdt settings : [select PDFTemplateUploadEndpoint__c 
													from EnvironmentSettings__mdt]) {

			endPoint = settings.PDFTemplateUploadEndpoint__c;
			break;
		}

		// retrieve Heroku authentication token from protected custom setting
		String token;
		for (HerokuSecurity__c security : [select AuthenticationToken__c 
													from HerokuSecurity__c]) {

			token = security.AuthenticationToken__c;
			break;
		}

		System.debug(DEBUG + 'MAKING PDF TEMPLATE UPLOAD CALLOUT');
		
		// setup POST request
		request.setMethod('POST');
		request.setEndpoint(endPoint);
		request.setHeader(BlIn_Constants.ACCESS_TOKEN, token);		// token stored in protected custom setting
		request.setHeader(BlIn_Constants.CLIENT_SYSTEM_ID, UserInfo.getOrganizationId());		// org Id
		request.setHeader('Content-Type', 'application/pdf');

		Blob payload;
		for (ContentVersion document : [select Id, 
												ContentDocumentId, 
												Title, 
												VersionData, 
												PathOnClient
										from ContentVersion 
										where Id = :documentId]) {
											
			payload = document.VersionData;
		}
		request.setBodyAsBlob(payload);		// PDF blob
		request.setTimeout(PDF_TEMPLATE_UPLOAD_TIMEOUT);		// timeout in ms
		
		System.debug(DEBUG + 'request: ' + request);

		// invoke the POST endpoint using the Http class
		HttpResponse response = http.send(request);
		
		// handle response
        if (response.getStatusCode() == 200) {
		    System.debug(DEBUG + 'Good response: ' + response.getStatusCode() + ' ' + response.getStatus());
        	

		} else {
		    System.debug(DEBUG + 'Error response: ' + response.getStatusCode() + ' ' + response.getStatus());
			throw new AuraHandledException('PDF template upload returned an error: ' + response.getStatus());
		}
		return true;
	}
}
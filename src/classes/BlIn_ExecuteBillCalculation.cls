/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		01 Sep 2017
@description 	Class for billing callout
*******************************************************************************/
public with sharing class BlIn_ExecuteBillCalculation {

	public static final String CLASS_NAME = 'BlIn_ExecuteBillCalculation';
	public static final String DEBUG = '[' + CLASS_NAME + '] ';
	
	public static final Integer BILL_CALCULATION_REQUEST_TIMEOUT = 2000;		// ms
	public static final Integer BILL_CALCULATION_RESULT_TIMEOUT = 2000;		// ms
    
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		18 Sep 2017
	@param			Id - bill calculation Id
	@return			Boolean - success
	@description 	HEROKU REST callout to request a bill calculation
	*******************************************************************************/
	public static Boolean requestBillCalculation(Id billCalculationId) {
		
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		
		// retrieve Heroku REST endpoint from custom metadata
		String endPoint;
		for (EnvironmentSettings__mdt settings : [select BillingCalculationEndpoint__c 
													from EnvironmentSettings__mdt]) {

			endPoint = settings.BillingCalculationEndpoint__c;
			break;
		}

		// retrieve Heroku authentication token from protected custom setting
		String token;
		for (HerokuSecurity__c security : [select AuthenticationToken__c 
													from HerokuSecurity__c]) {

			token = security.AuthenticationToken__c;
			break;
		}

		System.debug(DEBUG + 'Making request bill callout');
		
		// setup POST request
		request.setMethod('POST');
		request.setEndpoint(endPoint);
//		request.setCompressed(true);
		request.setHeader(BlIn_Constants.ACCESS_TOKEN, token);		// token stored in protected custom setting
		request.setHeader(BlIn_Constants.CLIENT_SYSTEM_ID, UserInfo.getOrganizationId());		// org Id
		request.setHeader('Content-Type', 'application/json');

		String payload = BlIn_BillCalcExtractData.retrieveData(billCalculationId);		// TO-DO - temp for debug
		request.setBody(payload);		// JSON billing data
		request.setTimeout(BILL_CALCULATION_REQUEST_TIMEOUT);		// timeout in ms
		
		System.debug(DEBUG + 'request: ' + request);
		System.debug(DEBUG + 'payload: ' + payload);

		// invoke the POST endpoint using the Http class
		HttpResponse response = http.send(request);
		
		// handle response
        if (response.getStatusCode() == 200) {
		    System.debug(DEBUG + 'Good response: ' + response.getStatusCode() + ' ' + response.getStatus());
        	
			// clear HasBillingBasisChanged__c ???

		} else {
		    System.debug(DEBUG + 'Error response: ' + response.getStatusCode() + ' ' + response.getStatus());
//			throw new AuraHandledException('The bill calculation request returned an error: ' + response.getStatus());		// TO-DO - temp for debug
		}
		return true;
	}

	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		01 Sep 2017
	@param			Id - bill calculation Id
	@return			List<Id> - generated bill Ids (null if bill results not ready)
	@description 	HEROKU REST callout to get the bill calculation result
	*******************************************************************************/
	public static List<Id> getBillCalculationResult(Id billCalculationId) {
		
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		
		// retrieve Heroku REST endpoint from custom metadata
		String endPoint;
		for (EnvironmentSettings__mdt settings : [select BillingCalculationEndpoint__c 
													from EnvironmentSettings__mdt]) {

			endPoint = settings.BillingCalculationEndpoint__c;
			break;
		}

		// retrieve Heroku authentication token from protected custom setting
		String token;
		for (HerokuSecurity__c security : [select AuthenticationToken__c 
													from HerokuSecurity__c]) {

			token = security.AuthenticationToken__c;
			break;
		}

		System.debug(DEBUG +  'Making bill result callout');

		// setup GET request
		request.setMethod('GET');
		request.setEndpoint(endPoint + '/' + billCalculationId);
		request.setHeader(BlIn_Constants.ACCESS_TOKEN, token);		// token stored in protected custom setting
		request.setHeader(BlIn_Constants.CLIENT_SYSTEM_ID, UserInfo.getOrganizationId());		// org Id
		request.setTimeout(BILL_CALCULATION_RESULT_TIMEOUT);		// timeout in ms
			
		// invoke the REST endpoint using the Http class
		HttpResponse response = http.send(request);
		
		// handle response
      	BlIn_BillCalcResponseContainer billingResponse;
        if (response.getStatusCode() == 200 && response.getBody() != null) {

			System.debug(DEBUG +  'Saving bill result');
			System.debug(DEBUG +  'response.getBody(): ' + response.getBody());
			
			// deserialise JSON into BlIn_BillCalcResponseContainer object
            billingResponse = BlIn_BillCalcResponseContainer.parse(response.getBody());

			// create bill, bill service types and bill items and write them to the database
			List<Id> billIds = BlIn_BillCalcResponseContainer.processResult(billCalculationId, billingResponse);

			// return the created bill Ids
			return billIds;

		} else {
			
		    System.debug(DEBUG + 'Error response: ' + response.getStatusCode() + ' ' + response.getStatus());
			throw new AuraHandledException('The bill result request returned an error: ' + response.getStatus());
		}
		return null;
	}
}
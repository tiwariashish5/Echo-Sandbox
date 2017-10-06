/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		29 Aug 2017
@description 	Extracts billing data and packages as JSON
				to pass to the bill calculation REST service
*******************************************************************************/
public with sharing class BlIn_BillCalcExtractData {
	
	public static final String BILL_CALCULATION = '{"BillCalculation": JSON}';		// JSON root object name
    
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		29 Aug 2017
	@param			Id - bill calculation Id
	@return			String - JSON package
	@description 	Retrives and packages billing data (single contract)
	*******************************************************************************/
	public static String retrieveData(Id billCalculationId) {
		
		// build the billing data DTO
		BlIn_BillCalcDataContainer billCalc = new BlIn_BillCalcDataContainer(billCalculationId);
		
		// serialise
		String JSONPayload = BILL_CALCULATION.replace('JSON', JSON.serialize(billCalc.getBillData()));
		
		System.debug('[BlIn_BillCalcExtractData] Serialized JSON billing data: ' + JSONPayload);
		return JSONPayload;
	}

}
/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		04 Sep 2017
@description 	Class to call the HEROKU API to create a PDF Bill
				Stores the PDF as an attachment on the bill record.
				Called from BlIn_PDFExecuteGeneration and returns the attachment Id
*******************************************************************************/
public with sharing class BlIn_CreateBillPDF {
		
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		04 Sep 2017
	@param			Dom.Document - billPDFDataXML
	@return			Id - Attachment Id
	@description 	HEROKU callout to generate a PDF
	*******************************************************************************/
	public static String callPDFGenerationAPI(Dom.Document billPDFDataXML) {

		BlIn_PDFPrepareBillData test = new BlIn_PDFPrepareBillData(null);
		
		return 'exit';
		String attachmentId;
		return attachmentId;
	}
	
}
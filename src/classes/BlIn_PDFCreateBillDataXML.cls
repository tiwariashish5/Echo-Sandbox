/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		04 Sep 2017
@description 	Class to create the XML billing document
				Called from BlIn_PDFExecuteGeneration once an instance of 
				BlIn_PDFBillData has been created/exists for a bill
*******************************************************************************/
public with sharing class BlIn_PDFCreateBillDataXML {
	
	// XML tags
	public static final String PDF_DATA = 'pdfData';
	public static final String PDF_TEMPLATE_NAME = 'pdfTemplateName';
	public static final String OBJECT_RECORD = 'objectRecord';
	public static final String OBJECT_RECORD_LIST = 'objectRecordList';
	public static final String OBJECT_API_NAME = 'objectApiName';
	public static final String FIELD = 'field';
	public static final String API_NAME = 'apiName';
	public static final String VALUE = 'value';
	
	public Dom.Document XMLDocument {get; private set;}
    
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		04 Sep 2017
	@param			BlIn_PDFBillData.BlIn_PDFBillData - bill data
	@param			String - PDF template name
	@description 	Constructor
	*******************************************************************************/
	public BlIn_PDFCreateBillDataXML(BlIn_PDFBillData billData) {

		// initialise the XML structure
		XMLDocument = new Dom.Document();
		XMLDocument.createRootElement(PDF_DATA, null, null);
		Dom.XmlNode objectNode = XMLDocument.getRootElement();
		
		// add the pdf template node
		objectNode.addChildElement(PDF_TEMPLATE_NAME, null, null).addTextNode(billData.PDFFormName);
		
		// for each object in the data structure		
		for (BlIn_PDFBillData.XMLRecord XMLRecord : billData.XMLObjectRecords) {

			// add the object record node
			addToXmlDoc(objectNode, XMLRecord);
		}
		system.debug('[BlIn_PDFCreateBillDataXML] XML: ' + XMLDocument.toXMLString());
	}

	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		08 Sep 2017
	@param			Dom.XmlNode - parentNode
	@param			BlIn_PDFBillData.XMLObject - XMLObject structured object
	@description 	adds an object node to the XML parent
	*******************************************************************************/
	public void addToXmlDoc(Dom.XmlNode parentNode, BlIn_PDFBillData.XMLRecord XMLRecord) {

		// add object
		parentNode = parentNode.addChildElement(OBJECT_RECORD, null, null);
		parentNode.addChildElement(OBJECT_API_NAME, null, null).addTextNode(XMLRecord.name);
		
		// add fields
		Dom.XmlNode fieldNode;
		for (String fieldName : XMLRecord.fieldMap.keySet()) {
			fieldNode = parentNode.addChildElement(FIELD, null, null);
			fieldNode.addChildElement(API_NAME, null, null).addTextNode(fieldName);
			fieldNode.addChildElement(VALUE, null, null).addTextNode(XMLRecord.fieldmap.get(fieldName));
		}

		// add list objects		
		if (XMLRecord.objectListMap != null) {
			for (String objectListName : XMLRecord.objectListMap.keySet()) {
				parentNode = parentNode.addChildElement(OBJECT_RECORD_LIST, null, null);
				parentNode.addChildElement(OBJECT_API_NAME, null, null).addTextNode(objectListName);
				
				// add the object record node
				for (BlIn_PDFBillData.XMLRecord XMLChildRecord : XMLRecord.objectListMap.get(objectListName)) {
					addToXmlDoc(parentNode, XMLChildRecord);
				}
			}
		}
	}
}
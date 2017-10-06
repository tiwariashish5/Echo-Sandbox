/******************************************************************************
@author         Accenture: Patrick Dixon
@date           04 Sep 2017
@description    This class creates an XML formatted document using the 
                BlIn_PDFXMLDefinition class to extract and format the 
                salesforce data required for Bill PDF Generation.
*******************************************************************************/
public with sharing class BlIn_PDFPrepareBillData {
    
    // XML tags
    public static final String PDF_DATA = 'pdfData';
    public static final String PDF_TEMPLATE_NAME = 'pdfTemplateName';
    public static final String OBJECT_RECORD = 'objectRecord';
    public static final String OBJECT_RECORD_LIST = 'objectRecordList';
    public static final String OBJECT_API_NAME = 'objectApiName';
    public static final String FIELD = 'field';
    public static final String API_NAME = 'apiName';
    public static final String VALUE = 'value';
    
    public BlIn_PDFBillData billData {get; private set;}

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           04 Sep 2017
    @param          Id - bill Id
    @description    Constructor
    *******************************************************************************/
    public BlIn_PDFPrepareBillData(Id billId, String PDFTemplateName) {

        // start with the bill Id and pick up the other parent Ids along the way        
        Set<Id> matchIds = new Set<Id>();
        matchIds.add(billId);
        
        // instantiate an instance of the XML definition
        BlIn_PDFXMLDefinition XMLDefinition = new BlIn_PDFXMLDefinition();

        // instantiate the XML data structure
        billData = new BlIn_PDFBillData();
        
        // add pdf template name
        billData.PDFFormName = PDFTemplateName;

        // populate the rest of the XML using the definition class objects
        for (BlIn_PDFBillData.XMLObject XMLObject : XMLDefinition.XMLObjects) {
            
            // build the records for each of the objects
            for (BlIn_PDFBillData.XMLRecord XMLObjectRecord : buildXMLObjectRecords(XMLObject, matchIds)) {

                // add them to the XML structure
                billData.addObjectRecord(XMLObjectRecord);
            }
        }
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           13 Sep 2017
    @param          SObject - record
    @param          String - API name of the field
    @return         String - field value
    @description    gets a field value as a string from a record using the API field name
    *******************************************************************************/
    private String getValue(SObject record, String fieldName) {
                
        // initialise the field's parent object
        SObject parentRecord = record;

        // split the query field into a list of its parent objects and its field name
        List<String> fieldNameElements = fieldName.normalizeSpace().split('\\.');
        
        // get the parent object name from the schema, and then get the field value
        for (Integer i = 0; i < fieldNameElements.size(); i++) {

            // the last element is the actual field name
            if (i == fieldNameElements.size() - 1) {
                        
                // return the value
                return parentRecord.get(fieldNameElements[i]) != null ? String.valueOf(parentRecord.get(fieldNameElements[i])) : '';
                        
            // other elements are parent object references
            } else {
                
                // update the parent object
                parentRecord = parentRecord.getSobject(fieldNameElements[i]);
                
                // return empty string if no parent record
                if (parentRecord == null) {
                    return '';
                }
            }
        }
        
        // error exit - parent record match not found
        return null;
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           12 Sep 2017
    @param          XMLObject - the XMLObject prototype for this SObject
    @param          Set<Id> - set of record Ids to match with the parentIdName field 
    @return         List<XMLObject> - a list of the populated XMLObjects
    @description    builds a list of XMLObject records for an object type
    *******************************************************************************/
    private List<BlIn_PDFBillData.XMLRecord> buildXMLObjectRecords(BlIn_PDFBillData.XMLObject XMLObject, Set<Id> matchIds) {

        List<BlIn_PDFBillData.XMLRecord> objectXMLList = new List<BlIn_PDFBillData.XMLRecord>();

        // build a set of all fields required in the query
        Set<String> fieldSet = new Set<String>();
        
        // start with the XML fields
        fieldSet.addAll(XMLObject.XMLFields);
        
        // and add the match Id fields
        if (XMLObject.idFields != null) {
            fieldSet.addAll(XMLObject.idFields);
        }

        // and the Id, parent Id and where fields
        fieldSet.add('Id');
        if (XMLObject.parentIdName != null) {
            fieldSet.add(XMLObject.parentIdName);
        }

        // build a string of query fields from the set
        String fieldList = '';
        for (String field : fieldSet) {
            fieldList += String.isBlank(fieldList) ? field : ', ' + field;
        }
        
        // default the query 'where field' to Id if the parent Id is null
        String parentIdName = XMLObject.parentIdName != null ? XMLObject.parentIdName : 'Id';
        
        // build the query and get the return record
        String query = 'select '
                    + fieldList + ' '
                    + 'from ' + XMLObject.name + ' '
                    + 'where ' + parentIdName + ' in :matchIds';
    
        system.debug('[BlIn_PDFPrepareBillData] query ' + query);
                
        for (SObject record : Database.query(query)) {
            BlIn_PDFBillData.XMLRecord XMLObjectRecord = new BlIn_PDFBillData.XMLRecord(XMLObject);
            
            // for each field returned in the query     
            for (String fieldName : fieldSet) {
                
                // get the field value as a string
                String value = getValue(record, fieldName);
                
                // if it's a Id field add it to the global match Ids and to the parent Ids for this record
                if (!String.isBlank(value) && XMLObject.idFields != null && XMLObject.idFields.contains(fieldName)) {
                    matchIds.add((Id)value);
                    XMLObjectRecord.parentIds.add((Id)value);
                } 

                // save the parent Id match
                if (!String.isBlank(value) && fieldName == XMLObject.parentIdName) {
                    XMLObjectRecord.parentLookup = (Id)value;
                }

                // add the record Id to the parent Ids
                if (fieldName == 'Id') {
                    XMLObjectRecord.parentIds.add((Id)value);
                }

                // populate the object field map
                if (XMLObject.XMLFields.contains(fieldName)) {
                    XMLObjectRecord.fieldMap.put(fieldName, value);
                }
            }
            objectXMLList.add(XMLObjectRecord);
        }
        return objectXMLList;
    }
}
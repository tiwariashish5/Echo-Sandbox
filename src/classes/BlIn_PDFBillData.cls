/******************************************************************************
@author         Accenture: Patrick Dixon
@date           04 Sep 2017
@description    PDF Bill Data class used to prepare the bill data
                includes XMLObject and XMLRecord sub classes
*******************************************************************************/
public with sharing class BlIn_PDFBillData {
        
    public String PDFFormName;
    public List<XMLRecord> XMLObjectRecords = new List<XMLRecord>();
    private Integer level;      // for debug

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           15 Sep 2017
    @param          XMLRecord - parentRecord
    @param          XMLRecord - the record to add
    @description    adds an object record to a parent record in the XML data structure
    *******************************************************************************/
    public Boolean addChildRecord(XMLRecord parentRecord, XMLRecord recordToAdd) {

        // check if this is the correct parent record
        if (parentRecord.parentIds.contains(recordToAdd.parentLookup)) {
                
            // add it to the child list
            if (parentRecord.objectListMap.keySet().contains(recordToAdd.Name)) {
                parentRecord.objectListMap.get(recordToAdd.Name).add(recordToAdd);
                
            } else {
                List<XMLRecord> XMLObjectRecords = new List<XMLRecord>();
                XMLObjectRecords.add(recordToAdd);
                parentRecord.objectListMap.put(recordToAdd.Name, XMLObjectRecords);
            }

            // sucessfully added the record
            system.debug('[BlIn_PDFBillData] sucessfully added the record ' + recordToAdd.name + ' to ' + recordToAdd.parentName);
            return true;
        }
            
        system.debug('[BlIn_PDFBillData] failed to find ' + recordToAdd.parentName + ' for ' + recordToAdd.name);
        return false;
    }
    
    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           15 Sep 2017
    @param          List<XMLRecord> - this level record's child records
    @param          XMLRecord - the record to add
    @description    finds a record's parent in the XML data structure
                    and adds the record to the correct parent record
    *******************************************************************************/
    public Boolean checkBranch(List<XMLRecord> childRecords, XMLRecord recordToAdd) {
            
        system.debug('[BlIn_PDFBillData] level: ' + level++);

        // check the lower branches
        for (XMLRecord parentCandidate : childRecords) {

            // if this is the parent
            if (recordToAdd.parentName == parentCandidate.Name) {
                    
                // add the record to the parent record's children and exit
                return addChildRecord(parentCandidate, recordToAdd);
            }
                    
            // this is not the parent so check each level down the hierachy until the parent is found or we reach the bottom
            for (List<XMLRecord> parentCandidateChildren : parentCandidate.objectListMap.values()) {

                // check the next level down the hierachy until the parent is found or we reach the bottom
                Boolean found = checkBranch(parentCandidateChildren, recordToAdd);
                if (found) return true;
            }
        }
        return false;
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           14 Sep 2017
    @param          XMLRecord - the record to add
    @description    adds an object record to XML data structure
    *******************************************************************************/
    public Boolean addObjectRecord(XMLRecord recordToAdd) {
            
        level = 0;
        system.debug('[BlIn_PDFBillData] adding: ' + recordToAdd.name);
            
        // base record 
        if (recordToAdd.parentName == null) {
                
            // add it to the data structure
            XMLObjectRecords.add(recordToAdd);
            system.debug('[BlIn_PDFBillData] sucessfully added base record ' + recordToAdd.name);
            return true;

        // child records
        } else {
                
            // check each record branch for the parent, starting at the top
            for (XMLRecord parentCandidate : XMLObjectRecords) {
                    
                // if this is the parent
                if (recordToAdd.parentName == parentCandidate.Name) {
                        
                    // add the record to the parent record's children and exit
                    return addChildRecord(parentCandidate, recordToAdd);
                }

                // this is not the parent so check the lower branches
                for (List<XMLRecord> parentCandidateChildren : parentCandidate.objectListMap.values()) {
                        
                    // check the next level down the hierachy until the parent is found or we reach the bottom
                    Boolean found = checkBranch(parentCandidateChildren, recordToAdd);
                    if (found) return true;
                }
            }
        }
            
        // error exit
        system.debug('[BlIn_PDFBillData] failed to add ' + recordToAdd.name);
        return false;
    }
    
    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           08 Sep 2017
    @description    Subclass for XML Object data structure
    *******************************************************************************/
    public class XMLObject {
        
        public String name;     // name of the object
        public String parentName;       // name of the parent object
        public String parentIdName;     // name of the parent lookup field (also constrains the scope of the query to this bill)
        public Set<String> idFields;        // any additional fields on this object that can link to child objects
        public Set<String> XMLFields;       // the fields on this object that are added to the XML
            
        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           13 Sep 2017
        @description    Constructor
        *******************************************************************************/
        public XMLObject(String name, String parentName, String parentIdName, Set<String> idFields, Set<String> XMLFields) {
            
            this.name = name;
            this.parentName = parentName;
            this.parentIdName = parentIdName;
            this.idFields = idFields;
            this.XMLFields = XMLFields;
        }
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           14 Sep 2017
    @description    Subclass for XML Records
    *******************************************************************************/
    public class XMLRecord {
        
        public String name;     // name of the object
        public String parentName;       // name of the parent object

        public Map<String, String> fieldMap;        // a map of field values keyed on the field name for this record
        public Set<Id> parentIds;       // a set of the parent Ids associated with the record (includes the record Id)
        public Id parentLookup;     // the salesforce Id that links to the parent record
        public Map<String, List<XMLRecord>> objectListMap;      // a map of a list of child records keyed on the child object name
            
        /******************************************************************************
        @author         Accenture: Patrick Dixon
        @date           13 Sep 2017
        @description    Constructor
        *******************************************************************************/
        public XMLRecord(XMLObject XMLObject) {

            name = XMLObject.name;
            parentName = XMLObject.parentName;
            
            fieldMap = new  Map<String, String>();
            parentIds = new Set<Id>();
            objectListMap = new Map<String, List<XMLRecord>>();
        }
    }
}
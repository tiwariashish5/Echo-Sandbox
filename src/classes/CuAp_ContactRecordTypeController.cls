/**************************************************************************************************************************************
@author        Accenture : Shivangi Gaur
@date          18-Sep-2017
@description:  This class is uesd to handle lightning component for overriding record type selection page for HH contact.  
@group         Lightning Component Controller
Revision(s)    
***************************************************************************************************************************************/
public with sharing class CuAp_ContactRecordTypeController{
    
    // Variable declaration
    
    public static Map<Id, String> recordTypeMap {get;set;}
    
    // End variable declaration
    
    /**********************************************************************************************
    @author        Accenture: Shivangi Gaur
    @date          18-Sep-2017
    @param         null
    @return        List<String>
    @description   This method is used to return record type values for contact.
    **********************************************************************************************/
   @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordTypes = Contact.SObjectType.getDescribe().getRecordTypeInfos();    
        recordTypeMap = new Map<Id, String>();
        
        for(RecordTypeInfo rt : recordTypes){
            //fetch record types only if it is not Master
            if(rt.getName() != 'Master')
            recordTypeMap.put(rt.getRecordTypeId(), rt.getName());
        }        
        return recordTypeMap.values();
    }
    
    /**********************************************************************************************
    @author        Accenture: Shivangi Gaur
    @date          19-Sep-2017
    @param         String
    @return        Id
    @description   This method is used to return Id of the record type for contact.
    **********************************************************************************************/    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
		Id recid = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
		return recid;
	}
}
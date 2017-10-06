/**************************************************************************************************************************************
@author        Accenture : Shivangi Gaur
@date          12-Sep-2017
@description:  This class is uesd to handle lightning component for overriding record type selection page for HH account.  
@group         Lightning Component Controller
Revision(s)    18-09-2017 - Shivangi Gaur - Updated method getRecTypeId() as per new solution.
***************************************************************************************************************************************/
public with sharing class CuAp_AccountRecordTypeController{
    
    // Variable declaration
    
    public static Map<Id, String> recordTypeMap {get;set;}
    
    // End variable declaration
    
    /**********************************************************************************************
    @author        Accenture: Shivangi Gaur
    @date          12-Sep-2017
    @param         null
    @return        List<String>
    @description   This method is used to return record type values for account.
    **********************************************************************************************/
   @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordTypes = Account.SObjectType.getDescribe().getRecordTypeInfos();    
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
    @date          12-Sep-2017
    @param         String
    @return        Id
    @description   This method is used to return Id of the record type for account.
    **********************************************************************************************/    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        Id recid = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
    }
}
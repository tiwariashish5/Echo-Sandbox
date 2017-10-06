/**********************************************************************************************
@author         Accenture : Shivangi Gaur
@date           18-Sep-2017
@description:    
@group          Customer 
**********************************************************************************************/
public with sharing class CuAp_HHCustomerEditController {
    public Account account{get;set;}    
    public Contact contact{get;set;}
    @AuraEnabled
    public static string getHHAccountRecordTypeName(Id recordId){
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        String recTypeName;
        if(sObjName =='Account'){
            System.debug('@@@@@sObjName'+sObjName);
            Account accObj = [Select id, RecordTypeId from Account where id =: recordId limit 1];
            recTypeName = Schema.SObjectType.Account.getRecordTypeInfosById().get(accObj.RecordTypeId).getName();
        }
        else if(sObjName =='Contact'){ 
            Contact conObj = [Select id, RecordTypeId from Contact where id =: recordId limit 1];
            recTypeName = Schema.SObjectType.Contact.getRecordTypeInfosById().get(conObj.RecordTypeId).getName();
        }
        System.debug('@@@@@recTypeName'+recTypeName);
        return recTypeName;        
    }
}
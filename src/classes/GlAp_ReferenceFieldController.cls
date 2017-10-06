/************************************************************************************************************
@author    		Accenture : Luke Emberton
@date      		26-Aug-2017
@description: 	This class is utilised to 
**************************************************************************************************************/
public with sharing class GlAp_ReferenceFieldController {
		
	/*
	 @AuraEnabled
	 public static List < account > fetchAccount(String searchKeyWord) {
	  	String searchKey = searchKeyWord + '%';
	  	List < Account > returnList = new List < Account > ();
	  	List < Account > lstOfAccount = [select id, Name from account where Name LIKE: searchKey];
	 
	  	for (Account acc: lstOfAccount) {
	     	returnList.add(acc);
	   	}
	  	return returnList;
	 }
	 */
	 
	 
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String searchKeyWord
	@param			string sObjectType
	@return			List<sObject>
	@description		This method takes and object name and a search strnkg to do fuzzy / like
					query on the object to find records of that name
	**********************************************************************************************/
	
	 @AuraEnabled
	 public static List<sObject> fetchRecords(String searchKeyWord, string sObjectType) {
	  	String searchKey = searchKeyWord + '%';
	  	
	  	List<sObject> returnList = new List<sObject>();
	  	
	  	string sOQLQuery = 'SELECT Id, Name FROM ' + sObjectType + ' WHERE Name LIKE \'' + searchKey + '\'' ;
		List<SObject> lstOfObjects = Database.query(sOQLQuery);      	
           
	 
	  	for (sObject objRec: lstOfObjects) {
	     	returnList.add(objRec);
	   	}
	  	return returnList;
	 }
		
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String searchKeyWord
	@return			string
	@description		Method used to get the object type from the id
	**********************************************************************************************/
	
	@AuraEnabled
	public static string getObjectType(string recordIdString){
		Id sId = (Id)recordIdString;
		string objName = sId.getSobjectType().getDescribe().getName();
		return objName;
	}
		
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String searchKeyWord
	@return			string
	@description		Method used to get the reference object type from the field name
	**********************************************************************************************/
	
	@AuraEnabled
	public static string getObjectTypeForField(string fieldName, string parentObject){

		string refObj ='';
		
		//Get describe details from the object
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(parentObject).getDescribe().fields.getMap();
       
        //Get specific field details
        Schema.SObjectField fld = fieldMap.get(fieldName);
        Schema.DescribeFieldResult fldDesRes = fld.getDescribe();
		
		 List <Schema.sObjectType> objRef = fldDesRes.getReferenceTo();
		 if(objRef.size()>0){
		 	refObj = objRef[0].getDescribe().getName();		 	
		 }
		return refObj;
	}
	
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String recordIdString
	@return			string
	@description		Method used to retireve the name record for a passed in id so that the
					display shows the record name and not the salesforce id
	**********************************************************************************************/
	
	@AuraEnabled
	public static string getRecordName(string recordIdString){
		system.debug('recordIdString: ' + recordIdString);
		string recName ='';
		if(recordIdString !=null && recordIdString!= ''){
			string objName;
			objName = getObjectType(recordIdString);
			string sOQLQuery = 'SELECT Name FROM ' + objName + ' WHERE Id =\'' + recordIdString + '\'' ;
			
			List<SObject> retList = Database.query(sOQLQuery);
			if(retList.size() > 0){
	         	SObject retVal = retList[0];
	         	recName = (string)retVal.get('Name');
			}
		}
		
		return recName;
	}
    
}
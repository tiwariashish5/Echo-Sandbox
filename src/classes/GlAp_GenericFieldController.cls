public with sharing class GlAp_GenericFieldController {
    
    //Method used to get the object type from the id
	@testVisible		
	private static string getObjectType(string recordIdString){
		Id sId = (Id)recordIdString;
		return sId.getSobjectType().getDescribe().getName();
	}
	
	@AuraEnabled
	public static string getRecordName(string recordIdString){
		String recName ='';
		if(!String.isBlank(recordIdString)) {
			String objName = getObjectType(recordIdString);
			List<SObject> retList = Database.query('SELECT Name FROM ' + objName + ' WHERE Id = :recordIdString');

			if(retList.size() > 0){
	         	SObject retVal = retList[0];
	         	recName = (String)retVal.get('Name');
			}
		}
		return recName;
	}
}
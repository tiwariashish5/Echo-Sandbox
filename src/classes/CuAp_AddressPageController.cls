public with sharing class CuAp_AddressPageController {
	
	private static List<string> locFields;
	
	static{
			//Get Fields from the Supression Object
		 	locFields = new List<string>();
		 	locFields.add('Street__c');
		 	locFields.add('City__c');
		 	locFields.add('StateProvince__c');
		 	locFields.add('PostalZIPCode__c');
		 	locFields.add('ParentLocation__c');
		 	locFields.add('LocationType__c');
		 	locFields.add('LocationSubType__c');
		 	locFields.add('LocationReference__c');
		 		 	
	}

	
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		04-Sep-2017
	@return			List<GLAp_FieldProps>
	@description		This method returns the field properties for each of the fields that are
					to be displayed on the screen
	**********************************************************************************************/
	 @AuraEnabled
	public static List<GLAp_FieldProps> retrieveLocationPropDetails() {
		
		//Get the field properties for the supression object
	 	List<GLAp_FieldProps> locProps = GlAp_LightningDataAccess.getObjectsFieldProperties(CuAp_Constants.LOCATIONAPINAME, locFields);	 	
	 	
	 	//Want to make all of the contract fields readonly
	 	for(GLAp_FieldProps locProp: locProps){
	 		locProp.isEditable = false;
	 	}

 		return locProps;
		
	}
	
	
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		10-Sep-2017
	@return			List<BlAp_CombinedRecord>
	@description		This method returns the field properties for each of the fields that are
					to be displayed on the screen
	**********************************************************************************************/
	
	@AuraEnabled
	public static List<BlAp_CombinedRecord> queryForLocations(string sPostCode, string sState, string sStreet, string sCity) {
	
		List<BlAp_CombinedRecord>  locationSelectList = new List<BlAp_CombinedRecord>();
	 	
		boolean performQuery = true;
		//Only query datbase if one field is field in
		if((sPostCode == null || sPostCode =='') && (sState == null ||sState =='') &&(sStreet == null || sStreet =='') &&(sCity == null ||sCity =='') ){
				performQuery = false;	
			}
		
		if(performQuery){
			string sOQLQuery ='';
		 	
		 	//Build up start of SOQL Query
		 	sOQLQuery = String.format('SELECT {0} FROM {1}', new List<String>{'Id,' + String.join(locFields,','), CuAp_Constants.LOCATIONAPINAME +' WHERE '});
		 	
		 	boolean isStart = true;
		 	//Add all of the input parameters to the searcg string
		 	if(sPostCode != null && sPostCode!=''){
		 		sOQLQuery += appendLikeClause('PostalZIPCode__c', sPostCode, isStart);
		 		isStart = false;
		 	}
		 	
		 	else if(sStreet != null && sStreet!=''){
		 		sOQLQuery += appendLikeClause('Street__c', sStreet, isStart);
		 		isStart = false;
		 	}
		 	else if(sCity != null && sCity!=''){
		 		sOQLQuery += appendLikeClause('City__c', sCity, isStart);
		 		isStart = false;
		 	}
		 	else if(sState != null && sState!=''){
		 		sOQLQuery += appendLikeClause('StateProvince__c', sState, isStart);
		 		isStart = false;
		 	}
		 	
		 	system.debug('sOQLQuery: ' + sOQLQuery);
		 	List<Location__c> locationList = Database.query(sOQLQuery);
		 	
		 	//Check the security on the location fields
	 		locationList = GlUt_FieldSecurity.cleanseFields(locationList, locFields, true);
		 	
		 	//Loop throught the contract list and capture the appropriate suppresion information
		 	for(Location__c loc : locationList){
		 		
		 		BlAp_CombinedRecord locationSelectRecord = new BlAp_CombinedRecord();	 		
		 		
		 		locationSelectRecord.uniqueId=loc.Id;
		 		locationSelectRecord.isSelected = false;
		 		locationSelectRecord.objectMap = new Map<string, sObject>();
		 		locationSelectRecord.objectMap.put(CuAp_Constants.LOCATIONAPINAME, loc);	 			 			 		
		 		locationSelectList.add(locationSelectRecord);
		 		
		 	}
		}
	 	return locationSelectList;
	}
	
	private static string appendLikeClause(string fieldName, string fieldVal, boolean isStart){
		string retVal;
		if(isStart){
			retVal = fieldName + ' LIKE \'%' + fieldVal + '%\'';
		}
		else{
			retVal = ' OR ' + fieldName + ' LIKE \'%' + fieldVal + '%\'';
		}
		return retVal;
	}
    
}
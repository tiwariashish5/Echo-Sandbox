/************************************************************************************************************
@author    		Accenture : Luke Emberton
@date      		26-Aug-2017
@description: 	This is a class used by all lighting components to retrieve data from the database. It takes
				object names along with a list of fields or a fieldset name and uses that to retrieve data
				from the database. It works in conjunction with the GlUt_FieldSecurity class to ensure that the
				user has access to the field (via FLS) and that the field is encrypted
**************************************************************************************************************/
public with sharing class GlAp_LightningDataAccess {
		
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String objectAPIName
	@param			string sFieldSetName
	@return			List<string>
	@description		Method to return a list of fields from a field set name
	**********************************************************************************************/
	@testVisible
	private static List<string> getFieldSetFields(String objectAPIName, string sFieldSetName){
		List<string> fieldList = new List<string>();
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectAPIName);
		        
        if(sFieldSetName != null){
       		List<Schema.FieldSetMember> fldSetMembers = targetType.getDescribe().FieldSets.getMap().get(sFieldSetName).getFields();
        
	      	for(Schema.FieldSetMember f : fldSetMembers) {
	        	string fldName = f.fieldPath;
	        	fieldList.add(fldName);
	       	} 
        }
        system.debug('getFieldSetFields: ' + fieldList);
        return fieldList; 
	}
	

	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String objectAPIName
	@param			string sFieldSetName
	@param			List<GLAp_FieldProps> fldProps
	@return			List<GLAp_FieldProps> 
	@description		Method processes a field properties object to update it for the respective
					fields that are marked as read only in the field set
	**********************************************************************************************/
	@testVisible
	private static List<GLAp_FieldProps> getFieldSetReadOnlyField(String objectAPIName, string sFieldSetName, List<GLAp_FieldProps> fldProps){
		
		List<GLAp_FieldProps> retFieldProps = new List<GLAp_FieldProps>();
		
		Map<string, GLAp_FieldProps> fldPropsMap = new Map<string, GLAp_FieldProps>();
		
		//First put the fldProps into a Map
		for(GLAp_FieldProps prop : fldProps){
			fldPropsMap.put(prop.fieldName, prop);
		}
		
		List<string> fieldList = new List<string>();
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectAPIName);
		        
        if(sFieldSetName != null){
       		List<Schema.FieldSetMember> fldSetMembers = targetType.getDescribe().FieldSets.getMap().get(sFieldSetName).getFields();
        
	      	for(Schema.FieldSetMember f : fldSetMembers) {
	        	string fldName = f.fieldPath;
	        	GLAp_FieldProps prop = fldPropsMap.get(fldName);
	        	
	        	boolean fldSetIsRequired = f.getRequired();
	        	boolean fldSetDBIsRequired = f.getDBRequired();
	        	prop.isRequired = (fldSetIsRequired||fldSetDBIsRequired);
	        	retFieldProps.add(prop);

	       	}
        }
        return retFieldProps; 
	}
	
	
	
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String objectAPIName
	@param			List<String> fieldNames
	@return			List<GLAp_FieldProps>
	@description		Method that takes an object API Name and also list of field Names to return details 
					about the fields from the system
	**********************************************************************************************/
	@AuraEnabled
	public static List<GLAp_FieldProps> getObjectsFieldProperties(String objectAPIName, List<String> fieldNames){
		List<GLAp_FieldProps> fldProps = new List<GLAp_FieldProps>();
		fldProps = GlUt_FieldSecurity.getFieldPropertiesObject(objectAPIName, fieldNames);
		return fldProps;
	}
	
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String objectAPIName
	@param			string fieldSetName
	@return			List<GLAp_FieldProps>
	@description		Method that takes an object API Name and also list of field Names to return 
					details about the fields from the system in lists of 2
	**********************************************************************************************/
	@AuraEnabled
	public static List<List<GlAp_FieldProps>> getObjectsFieldPropertiesByFieldSetNameFor2ColForm(String objectAPIName, string fieldSetName){
				
		List<List<GlAp_FieldProps>> twoColFormattedList = new List<List<GlAp_FieldProps>>();
		
		//List of fields from the field set Name
		List<string> fieldNames = getFieldSetFields(objectAPIName,  fieldSetName);
		
		//Field prperties
		List<GlAp_FieldProps> fldProps = getObjectsFieldProperties(objectAPIName,  fieldNames);
		
		//Update the field properties to augment the readonly fields from the field set
		fldProps = getFieldSetReadOnlyField(objectAPIName, fieldSetName, fldProps);		
        
		for(integer i=0; i < fldProps.size(); i = i+2){
			List<GlAp_FieldProps> lstEntry = new List<GlAp_FieldProps>();
			integer secondEntryIndex = i+1;
			lstEntry.add(fldProps[i]);
			
			if(secondEntryIndex < fldProps.size()){
				lstEntry.add(fldProps[secondEntryIndex]);	
			}
			twoColFormattedList.add(lstEntry);
		}
		return twoColFormattedList;
	}
	
	
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String objectAPIName
	@param			string fieldSetName
	@return			List<GLAp_FieldProps>
	@description		Method that takes an object API Name and also fieldset Name to return details 
					about the fields from the system
	**********************************************************************************************/
	
	@AuraEnabled
	public static List<GlAp_FieldProps> getObjectsFieldPropertiesByFieldSetName(String objectAPIName, string fieldSetName){
		List<string> fieldNames = getFieldSetFields(objectAPIName,  fieldSetName);
		List<GlAp_FieldProps> fldProps = getObjectsFieldProperties(objectAPIName,  fieldNames);
		fldProps = getFieldSetReadOnlyField(objectAPIName, fieldSetName, fldProps);	
		return fldProps;
	}
	
	
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String objectAPIName
	@param			List<String> fieldNames
	@param			string sWhereClause 
	@return			List<sObject>
	@description		Method to retrieve a list of records from the database filtered by a particular
					where clause
	**********************************************************************************************/
	@AuraEnabled
    public static List<sObject>  getFilteredRecordsByFieldList(String objectAPIName, List<String> fieldNames, string sWhereClause ){
        try{
            string sOQLQuery = String.format('SELECT {0} FROM {1}', new List<String>{'Id,' + String.join(fieldNames,','), objectAPIName});
            sOQLQuery += ' ' + sWhereClause;
            
            List<SObject> resultSObjectList;
            try {
            	resultSObjectList = Database.query(sOQLQuery);
            }
            catch (System.QueryException ex) {
            		throw new GLAp_LightningDataAccessException('Malformed query: ' + sOQLQuery); 
            }
            
         	return GlUt_FieldSecurity.cleanseFields(resultSObjectList, fieldNames, true);       	
        }
        catch (Exception e){
            return new List<sObject>();
        }
   	}
	

	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String objectAPIName
	@param			List<String> fieldNames
	@return			List<sObject> 
	@description		Method that takes an object API Name and also list of field Names to return records
					from the database
	**********************************************************************************************/
	@AuraEnabled
    public static List<sObject>  getRecordsByFieldList(String objectAPIName, List<String> fieldNames ){
        List<sObject> retVal;
        try{
            string sOQLQuery = String.format('SELECT {0} FROM {1}', new List<String>{'Id,' + String.join(fieldNames,','), objectAPIName});
            List<SObject> retQuery = Database.query(sOQLQuery);
         	retVal = GlUt_FieldSecurity.cleanseFields(retQuery, fieldNames, true);       	
        	return retVal;
        }
        catch (Exception e){
            retVal = new List<sObject>();
            return retVal; 
        }
   	}
   	
   	
		
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String sId
	@param			String parentField
	@param			String listFilter
	@param			String objectAPIName
	@param			String fieldSetName
	@return			List<sObject> 
	@description		Method that takes an object API Name and fieldset name to return records from 
					the database
	**********************************************************************************************/
	@AuraEnabled
    public static List<sObject> getRelatedRecordsByFieldSetName(String sId, String parentField, String listFilter, String objectAPIName, String fieldSetName){   	
    	List<string> fieldNames = getFieldSetFields(objectAPIName,  fieldSetName);    	
    	
    	string filterComp = listFilter==null ? '' : ' AND ' + listFilter;
    	
    	string sWhereClause = String.format(' WHERE {0} {1}', new List<String>{parentField + '=\'' + sId + '\'', filterComp});
    	
    	system.debug('sWhereClause: ' + sWhereClause);
    	
    	List<sObject> retVal = getFilteredRecordsByFieldList(objectAPIName, fieldNames, sWhereClause);
    	
    	return retVal;
    }
   	
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String objectAPIName
	@param			String fieldSetName
	@return			List<sObject>
	@description		Method that takes an object API Name and fieldset name to return records 
					from the database
	**********************************************************************************************/
	@AuraEnabled
    public static List<sObject> getRecordsByFieldSetName(String objectAPIName, String fieldSetName){
    	List<string> fieldNames = getFieldSetFields(objectAPIName,  fieldSetName);    	
    	List<sObject> retVal = getRecordsByFieldList(objectAPIName, fieldNames );
    	return retVal;
    }
       
    /**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String objectAPIName
	@param			string sId
	@param			List<String> fieldNames
	@return			sObject
	@description		Method that takes an object API Name and list of field names to return a 
					single record with the sId passed in
	**********************************************************************************************/
    @AuraEnabled
    public static sObject getRecordByIdAndFieldList(String objectAPIName, string sId, List<String> fieldNames){
    	sObject retVal;
    	try{
            string fieldString = String.join(fieldNames,',');
            //if(!fieldString.contains('CurrencyIsoCode'))
			//	fieldString = fieldString + ',CurrencyIsoCode';

            string sOQLQuery = String.format('SELECT {0} FROM {1}', new List<String>{fieldString, objectAPIName});
           	sOQLQuery += ' WHERE Id =\'' + sId + '\'' ;           	
          	system.debug('sOQLQuery:  ' + sOQLQuery);
            List<SObject> retQuery = Database.query(sOQLQuery);           

         	List<sObject> retList = GlUt_FieldSecurity.cleanseFields(retQuery, fieldNames, true);

         	retVal = retList[0];
         	//retVal = retQuery[0];
                    	
        	return retVal;
        }
        catch (Exception e){
            system.debug('Exception: ' + e.getMessage());
            return retVal;
        }
    	
    }
    
    
   	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String objectAPIName
	@param			string sId
	@param			String fieldSetName
	@return			sObject
	@description		Method that takes an object API Name and fieldset name to return a 
					single record with the sId passed in
	**********************************************************************************************/
	
    @AuraEnabled
    public static sObject getRecordByIdAndFieldSetName(String objectAPIName, string sId, String fieldSetName){
    	
    	system.debug('getRecordByIdAndFieldSetName:     objectAPIName: ' + objectAPIName +' sId : ' + sId + ' fieldSetName: ' +fieldSetName );
        sObject retVal;   	
    	List<string> fieldNames = getFieldSetFields(objectAPIName,  fieldSetName);
        retVal = getRecordByIdAndFieldList(objectAPIName, sId, fieldNames);   
        return retVal;
    	
    }
  
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			String objectAPIName
	@param			string sId
	@param			string recordClientString
	@return			string
	@description		Method that takes the JSON string of an object along with the API name to
					do an update of the record in the database (work around passing sObjects in 
					Lightning Components)
	**********************************************************************************************/
	
	@AuraEnabled
	public static string updateObject(string objectAPIName, string recordClientString){
        string retval;
        Type t2 = Type.forName(objectAPIName);        
		sObject sObj = (sObject)JSON.deserialize(recordClientString, t2); 
		retval = updateObjectRecord(sObj);
		return retVal;
	}
	
	
	
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			sObject sObj
	@return			List<sObject>
	@description		Method that takes an object and calls lightning security cleanse fields method 
					to update it	
	**********************************************************************************************/
	public static string updateObjectRecord(sObject sObj){
        string retval;
		
		//Determine which fields are present in the object
		Set<string> fieldNamesSet = sObj.getPopulatedFieldsAsMap().keySet();
		List<string> fieldNames = new List<string>(fieldNamesSet);
		
		//Add the object to a list so that it can be sent to the cleanse fields parameter
		List<sObject> objToClean = new List<sObject>();
		objToClean.add(sObj);
		
		
		//Call the cleasne fields utility to esure that the user is not writing to fields to which
		//they dont have edit rights
		List<sObject> retList = GlUt_FieldSecurity.cleanseFields(objToClean, fieldNames, false);
		
		//Retrive the cleasnsed object from the return parameter
		sObject sObjToUpdate = retList[0];
						
		//Call the update method to save the record to the database
		try{			
			update sObjToUpdate;
			retval = null;
			return retval;
		}
		catch(DMLException ex){
			retval = ex.getMessage();
			return retval;
		}
		catch(Exception ex){
			retval = ex.getMessage();
			return retval;
		}
	}
	
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			sObject sObj
	@return			List<sObject>
	@description		Method that takes an object and calls lightning security cleanse fields method 
					to update it	
	**********************************************************************************************/
	public static List<sObject> retrieveListOfRecordsByQueryString(string sQueryString){
		
		//Parse the query to get the query fields
		
		sQueryString = sQueryString.toUpperCase();
		string selectFields =sQueryString.substringBetween('SELECT', 'FROM');
		selectFields =selectFields.replace(' ', '');
		
		String[] fieldSet = selectFields.split(','); 
		
		//Query the database
		List<SObject> retQuery = Database.query(sQueryString);
		
		return retQuery;
	}
  
}
/************************************************************************************************************
@author    		Accenture : Luke Emberton
@date      		26-Aug-2017
@description: 	This class is used by all classes that retrive data from the database to ensure that FLS
				and encryption rules are respected. This is essential for Lightning Component classes
				it is a requirement for standard Apex classes to pass the AppExchange security review
**************************************************************************************************************/
public class GlUt_FieldSecurity {
	  

    /**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			sObject obj
	@return			string
	@description		Private Method that is used to identify and return the type of an sObject
	**********************************************************************************************/
    private static string getTypeofSObject(sObject obj){
        return obj.getSObjectType().getDescribe().getName();       
    }
    
    /**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			string objectName
	@return			Map<String, Schema.SObjectField> 
	@description		Method calls the desribe method to find out the properties of all fields on the object
	**********************************************************************************************/
    private static Map<String, Schema.SObjectField> getFieldMap(string objectName){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
		return fieldMap;        
    }
    
    //Field property values list
    private static Map<string,boolean> m_encryptedFields;
   	private static Map<string,boolean> m_acessibleFields;
   	private static Map<string,boolean> m_editableFields;
   	private static Map<string,string> m_fieldNames;

   	
   	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			Map<String, Schema.SObjectField> fieldMap
	@param			List<String> fieldNames
	@return			void
	@description		Method that sets up private map values of encrypted fields, field names, 
					encrypted fields
	**********************************************************************************************/
   	private static void getFieldProperties(Map<String, Schema.SObjectField> fieldMap, List<String> fieldNames){
   		
   		if(m_encryptedFields == null || m_encryptedFields.size()==0 || m_acessibleFields == null || m_acessibleFields.size()==0){
   			
   			m_encryptedFields =  new Map<string,boolean>();
   			m_acessibleFields =  new Map<string,boolean>();
   			m_editableFields =  new Map<string,boolean>();
   			m_fieldNames =  new Map<string, string>();
   			
   			
   			//Loop through the list of fields
	        for (String qryFld : fieldNames){
	            
	            Schema.SObjectField fld = fieldMap.get(qryFld);
	            Schema.DescribeFieldResult fldDesRes = fld.getDescribe();
	            
	            string fldName = fldDesRes.getName();
	            boolean isEncrypted = fldDesRes.isEncrypted();
	            boolean isAccessible = fldDesRes.isAccessible();
	            boolean isEditable = fldDesRes.isUpdateable();   
	            
	            m_encryptedFields.put(qryFld, isEncrypted);
	            m_acessibleFields.put(qryFld, isAccessible);
	            m_editableFields.put(qryFld, isEditable);   
	            m_fieldNames.put(qryFld, fldName);

	   		}
   		}
   	}
   	
   	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			string objectName
	@param			List<String> fieldNames
	@return			List<GlAp_FieldProps> 
	@description		This is a method that retrieves the field properties for an object and list
					of field names passed in
	**********************************************************************************************/
    public static List<GlAp_FieldProps> getFieldPropertiesObject(string objectName, List<String> fieldNames){
    	        	
	   	//Get the field properties for the fields on the object 
	    Map<String, Schema.SObjectField> fieldMap = getFieldMap(objectName);
	        	
	    	List<GlAp_FieldProps> propList = new List<GlAp_FieldProps>();
	    	
	    	Map<string, string> pickListEntries;
	    	List<string> pickListValues;
	        
        boolean isAccessible;
        boolean isEncrypted;
        boolean isEditable;
  
        string fldlbl;
	                  
        //Loop through all of the fields that have been passed in as part of the list
        for (String qryFld : fieldNames){
            
            //Get the field information for the corresponding field
            Schema.SObjectField fld = fieldMap.get(qryFld);
            Schema.DescribeFieldResult fldDesRes = fld.getDescribe();
            
            //Retrive various describe field properties for the field
            string fldName = fldDesRes.getName();
            DisplayType fldType = fldDesRes.getType();
            isAccessible = fldDesRes.isAccessible();
            isEncrypted = fldDesRes.isEncrypted();
            isEditable = fldDesRes.isUpdateable();
            fldlbl = fldDesRes.getLabel();
           	         
           	//If the field level secuiry enables the field to be accessed by the user then add it to the field properties object
           	if(isAccessible){
	           	GlAp_FieldProps objData = new GlAp_FieldProps();           
	            objData.setFieldType(fldType);
	            objData.isFLSVisible = isAccessible;
	            objData.isEncrypted = isEncrypted;
	            objData.isEditable = isEditable;
	            objData.fieldName = fldName;
	            objData.fieldLabel = fldlbl;
	            objData.parentObject = objectName;
	                       	
	           	//Determine if the field is a picklist in which the picklist values should be retrieved
	           	if(fldType == Schema.DisplayType.PICKLIST){  		
		            	pickListEntries = new Map<string, string>();
	    				pickListValues = new List<string>();
		            	
		            	//Add a blank value
		            	pickListEntries.put('','');
		            	pickListValues.add('');
		            	
			       	for(Schema.PicklistEntry pEntry : fldDesRes.getPicklistValues()){
						if(pEntry.isActive()){
							pickListEntries.put(pEntry.getLabel(),pEntry.getValue());
							pickListValues.add(pEntry.getValue());
						}
					}
					
					objData.pickListEntries = pickListEntries;
					objData.pickListValues = pickListValues;	            	
	     		}
	     		
	           	propList.add(objData);
           	}  	
       	}
       	  
    		return propList;
    }
        

   	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			List<sObject> objList
	@param			List<String> fieldNames
	@param			boolean isRead
	@return			List<sObject> 
	@description		This method takes the list of records and associated fields and processes them
					any fields which are not accessible to the user are removed from the sObject
					any fields that are encrypted have their value obscufated. A parameter is passed
					in to detail whether this is for reading or writing fields. If the field is
					encrypted and the user does not have permission to see encrypted data the field
					is removed from the sObject so its value is not overwritten
	**********************************************************************************************/
   	public static List<sObject> cleanseFields(List<sObject> objList, List<String> fieldNames, boolean isRead){ 		
   		List<sObject> retList = new List<sObject>();
   		
   		if(objList.size() >0){        
            //Work out what type of object we have
            sObject objInst = objList.get(0);
        		string objectName = getTypeofSObject(objInst);        
        	
        		//Get the field properties for the fields on the object 
        		Map<String, Schema.SObjectField> fieldMap = getFieldMap(objectName);
            
            //Loop through the fields in the object
            for(sObject obj: objList){               
                sObject clensedObj = checkFields(obj, objectName, fieldMap, fieldNames, isRead);
                retList.add(clensedObj);
            }
        }
        return retList;        
   	}
 	
	
	/**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			List<sObject> objList
	@param			boolean isRead
	@return			List<sObject> 
	@description		This method takes the list of records and processes them without needing the
					list of fields to be provided. Any fields which are not accessible to the user are 
					removed from the sObject any fields that are encrypted have their value obscufated. 
					A parameter is passed in to detail whether this is for reading or writing fields. 
					If the field is encrypted and the user does not have permission to see encrypted data 
					the field is removed from the sObject so its value is not overwritten
	**********************************************************************************************/
   	public static List<sObject> cleanseFields(List<sObject> objList, boolean isRead){ 		
   		List<sObject> retList = new List<sObject>();
   		
   		if(objList.size() >0){        
            //Work out what type of object we have
            sObject objInst = objList.get(0);
        		string objectName = getTypeofSObject(objInst);        
        	
        		//Get the field properties for the fields on the object 
        		Map<String, Schema.SObjectField> fieldMap = getFieldMap(objectName);
            
            //Loop through the fields in the object
            for(sObject obj: objList){
            		Set<string> fldSet = obj.getPopulatedFieldsAsMap().keySet();  
            		List<string> fieldNames = new List<string>(fldSet);           
                sObject clensedObj = checkFields(obj, objectName, fieldMap, fieldNames, isRead);
                retList.add(clensedObj);
            }
        }
        return retList;        
   	}
   	
   /**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			sObject obj
	@param			string objectType
	@param			Map<String, Schema.SObjectField> fieldMap
	@param			List<String> fieldNames
	@param			boolean isRead
	@return			sObject
	@description		Go through all of the fields on the object and either blank out or obscufate
	**********************************************************************************************/
   	public static sObject checkFields(sObject obj, string objectType, Map<String, Schema.SObjectField> fieldMap, List<String> fieldNames, boolean isRead){
    	
    		//Create object to allow fields to be removed or updated
        GlUt_ObjectUpdater objUp = new GlUt_ObjectUpdater(obj, objectType);

		//Build maps to define which fields are accessile or encyrpted
		getFieldProperties(fieldMap, fieldNames);

		
        //Work out which fields have a value on the object already (e.g. are set)
        Map<String, Object> populatedFields = obj.getPopulatedFieldsAsMap();
               
        //Loop through the list of fields
        for (String qryFld : fieldNames){
            
       		boolean isAccessible = m_acessibleFields.get(qryFld);
        		boolean isEncrypted = m_encryptedFields.get(qryFld);
        		boolean isEditable = m_editableFields.get(qryFld);
        		string fldName = m_fieldNames.get(qryFld);  
            
            //See if the field is already populated on the object
            if(populatedFields.containsKey(fldName)){
            	           	
            	if(isRead){
            		
	            	//If the user cannot access the field then remove it so long as not id field
	            	if(!isAccessible && (fldName !='Id')){
		                objUp.removeField(fldName);
		            }
		            
		            //If the field is encrypted obscufate the value
		            if(isEncrypted){
		                objUp.obscufateField(fldName);
		            }
	            }
	            else{
	            	
		            	//if the field is encryted or not editable then remove from the map as long as its not the id field            	
		            	if((isEncrypted || !isEditable) && fldName!='Id'){
			               objUp.removeField(fldName);
			       	}
		    		}
            	} 
    		}
    	
    		//Get the sObject back
		sObject retObj = objUp.getSObject();
  		return retObj;
   }  
    
}
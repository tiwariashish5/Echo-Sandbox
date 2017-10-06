/************************************************************************************************************
@author    		Accenture : Luke Emberton
@date      		26-Aug-2017
@description: 	This class is utilised to 
**************************************************************************************************************/
public class GlUt_ObjectUpdater {
    
    @testVisible private string objectString;
    private string objectType;
    private  Map<String, Schema.SObjectField> fieldMap;
    
    /**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			sObject obj
	@param			string oType
	@return			List<sObject>
	@description		Constuctor that takes the object type and sOBject to get list of fields for that
					object and a JSON string equivilent	
	**********************************************************************************************/	
    public GlUt_ObjectUpdater(sObject obj, string oType){
    	objectString = JSON.serialize(obj);
    	objectType = oType;
    	Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        fieldMap = schemaMap.get(objectType).getDescribe().fields.getMap();
    }

    /**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			string fieldName
	@return			void
	@description		This method is used to take a field from the sObject
	**********************************************************************************************/
    public void removeField(string fieldName){
		// NOTE: Do NOT use string manipulation for this method.
		// String manipulation will either fail or become incredibly complicated when the content includes commas or nested objects!    
	    	SObject sObjectInCurrentState = this.getSObject();
	    	
	    	//NOTE: We can't use a new SObject() here because generic SObject has no constructor.
	    	Map<String, Object> revisedSObject = new Map<String, Object>(); 
	   	
	   	//Loop through every field in the describe for this object
	   	for (String key : fieldMap.keySet()) {
	    		
	    		//If this is not the field that we are looking to remove
	    		if (key != fieldName) {
	    			
	    			//Get the value of the object from the sObject field
	    			Object value = sObjectInCurrentState.get(key);
	    			
	    			//If the field has a value then add it into the revised object
	    			if (value != null) {
	    				revisedSObject.put(key, sObjectInCurrentState.get(key));
	    			}
	    		}
	    	}
	
	    //Reserialise the revised object back into the objectString field
	    	objectString = JSON.serialize(revisedSObject);
    }
    
    /**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@param			string fieldName
	@return			void
	@description		This method is used to overwite a field that is encrypted
	**********************************************************************************************/
    public void obscufateField(string fldName){
	    
	    	//Integer fldStart = objectString.indexOf(fldName) - 1;
	    	//Integer valStart = objectString.indexOf(':', fldStart) + 1;
	    	//Integer valEnd = objectString.indexOf(',', fldStart);
	    	
	    //This variable is used for holding the appropriate obscufated value
	    string val;
	    
	    	//Work out what the type of the field is
	    	Schema.SObjectField fld = fieldMap.get(fldName);
	    Schema.DescribeFieldResult fldDesRes = fld.getDescribe();    
	    Schema.DisplayType fldType = fldDesRes.getType();
	    
	  	//If the field is numeric give it a numeric dummy value, if it is text give it a text value
	  	if(fldType == Schema.DisplayType.CURRENCY || fldType == Schema.DisplayType.INTEGER || fldType == Schema.DisplayType.DOUBLE){
        		val = '999999';
    		}
    		else{
    			val = '"xxxxxxxx"';
    		}
	    	 
	    	
	    SObject sObjectInCurrentState = this.getSObject();
	    	
	    	//NOTE: We can't use a new SObject() here because generic SObject has no constructor.
	    	Map<String, Object> revisedSObject = new Map<String, Object>(); 
	   	
	   	//Loop through every field in the describe for this object
	   	for (String key : fieldMap.keySet()) {
	    		
	    		//If this is not the field that we are looking to remove
	    		if (key != fldName) {
	    			
	    			//Get the value of the object from the sObject field
	    			Object value = sObjectInCurrentState.get(key);
	    			
	    			//If the field has a value then add it into the revised object
	    			if (value != null) {
	    				revisedSObject.put(key, sObjectInCurrentState.get(key));
	    			}
	    		}
	    		else{
	    			revisedSObject.put(key, val);
	    		}
	    	}
	
	    //Reserialise the revised object back into the objectString field
	    	objectString = JSON.serialize(revisedSObject); 		
    }
    
    /**********************************************************************************************
	@author      	Accenture: Luke Emberton
	@date      		26-Aug-2017
	@return			sObject
	@description		This method is used to get the updated sObject
	**********************************************************************************************/
    public sObject getSObject(){
    		Type t2 = Type.forName(objectType);   
    		sObject sObj = (sObject)JSON.deserialize(objectString, t2);
    		return sObj;
    }
    

}
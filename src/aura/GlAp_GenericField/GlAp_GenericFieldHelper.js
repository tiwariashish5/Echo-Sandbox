({
	doInit : function(component, event, helper) {
        debugger;
        var object;
        
        var objectList = component.get('v.object');
        var objectName = component.get('v.objectName');
        
        //See if multiple objects are passed in, then get the object for the object type
        //otherwise assume just one object
        try{
        		object = objectList.objectMap[objectName];
        }
        catch(e){
        		object = objectList;
        }
        		
        var fieldType = component.get('v.fieldType');
        var fieldName = component.get('v.fieldName');
        var picklistValues = component.get('v.picklistValues');
        var value;

        if(fieldName.includes(".")) {
            component.set("v.value", object[fieldName.split(".")[0]][fieldName.split(".")[1]]);
        } else {
            try{
            	var fldVal = object[fieldName];
            	component.set("v.value", fldVal);
            }
            catch(ex){
            	component.set("v.value", '');
            }
            
        }
        
        if(fieldType =='reference'){
	        var action = component.get("c.getRecordName");        
	        var recId = component.get("v.value");
	        action.setParams({ 
	            "recordIdString": component.get("v.value")
	        });
	        
	        action.setCallback( this, function(response) {
	            var state = response.getState();
	            if (state === "SUCCESS") {
	                component.set("v.urlLabel", response.getReturnValue());
	                component.set("v.urlString", '/' + component.get("v.value"));
	            }
	        });
	        $A.enqueueAction(action);   
        }
    },
   
    doUpdateValue : function(component, event, helper) {
        
        var fldVal = component.get("v.value");
        var fieldName = component.get("v.fieldName");
        var object;
        
        var objectList = component.get('v.object');
        var objectName = component.get('v.objectName');
        
        //See if multiple objects are passed in, then get the object for the object type
        //otherwise assume just one object
        try{
        		object = objectList.objectMap[objectName];
        }
        catch(e){
        		object = objectList;
        	}
        
        try{
        		object[fieldName] = fldVal;
        		component.set("v.object", objectList);   
        }
        catch(ex){

        }
    }
})
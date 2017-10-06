({
	
	doInit : function(component, event, helper) {           

			debugger;
			helper.getObjectRecord(component, event, helper,       
	    		function(response){
					debugger;
					component.set("v.client", response);
                    if(response)
						
						if(response.hasOwnProperty("CurrencyIsoCode"))
                        	
                        	component.set("v.currencyCode", response.CurrencyIsoCode);
	    		}
	        );
	        
	        helper.getObjectFieldsIn2ColForm(component, event, helper,       
	    		function(response){            					            					 
					component.set("v.fieldSetResults", response);
	    		}
	        );
	             
	      
    },
    
    doSave : function(component, event, helper) {
		
		//Ensure that required fields are populated
		var rqd;
		var fldName;
		var fldVal;
		var fldLabel;
		var rqdFieldErrorList = [];
			
		var fieldSetResults = component.get("v.fieldSetResults");
		var sObj = component.get("v.client");
		
		for (var i in fieldSetResults) {
			
			var propEntry = fieldSetResults[i];
			
			for (var j in propEntry){
				
				var prop = propEntry[j];
				rqd = prop.isRequired;
				fldName = prop.fieldName;
				fldLabel = prop.fieldLabel;
				fldVal = sObj[fldName];
				
				if(rqd && (fldVal=='' || fldVal==null)){
					rqdFieldErrorList.push(fldLabel);
				}
			} 
		} 
		
		if(rqdFieldErrorList.length > 0){
			var errMsg = 'There are required fields on this page that are not populated: ';
			var fstFld = true;
			
			for(var e in rqdFieldErrorList){
				fldLabel = 	rqdFieldErrorList[e];
				if(fstFld){
					fstFld = false;
					errMsg +=  fldLabel;
				}
				else{
					errMsg += ', ' + fldLabel;
				}
				
			}
			helper.setErrorMessage(component, event, helper, errMsg);
		}
		else{
			helper.doObjectSave(component, event, helper,
			
				function(response){
						if(response == null){
							var div1 = component.find("errorMsg")
							div1.set("v.body", null);
							
							component.set("v.editMode", false);
							helper.doInit(component, event, helper);
							
						}
						else{
							helper.setErrorMessage(component, event, helper, response);
						}	
	    		}
			);
		}
		
	},
	setErrorMessage : function(component, event, helper, errorText){
			$A.createComponents([
	                ["ui:message",{
	                    "title" : "Save Error",
	                    "severity" : "error",
	                }],
	                ["ui:outputText",{
	                    "value" : errorText
	                }]
	                ],
	                function(components, status, errorMessage){
	                    if (status === "SUCCESS") {
	                        var message = components[0];
	                        var outputText = components[1];
	                        // set the body of the ui:message to be the ui:outputText
	                        message.set("v.body", outputText);
	                        var div1 = component.find("errorMsg");
	                        // Replace div body with the dynamic component
	                        div1.set("v.body", message);
	                    }
	                    else if (status === "INCOMPLETE") {
	                        console.log("No response from server or client is offline.")
	                        // Show offline error
	                    }
	                    else if (status === "ERROR") {
	                        console.log("Error: " + errorMessage);
	                        // Show error message
	                    }
	                }
				);	
	},
    doToggleSection : function(component, event, helper){
        var sctn = component.find('formSect');
        
        var DownIcon = component.find('DownIcon');
        var RightIcon = component.find('RightIcon');
        
        $A.util.toggleClass(DownIcon, 'slds-hide');
        $A.util.toggleClass(RightIcon, 'slds-hide');
		$A.util.toggleClass(sctn, 'slds-is-open');
	},
	
	doCancel : function(component, event, helper){

		var div1 = component.find("errorMsg")
		div1.set("v.body", null);
		
		helper.doInit(component, event, helper);
		component.set("v.editMode", false);
	}

	

})
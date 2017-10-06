({
	doInit : function(component, event, helper) {           
                 
        //Retrieve the list of contracts and current suppression for the customer
        let params = {
            "customerId": component.get("v.recordId"),
       	};
       					  
        helper.callServer(component,'c.retrieveContractSupressions',
        						function(response){
            						component.set("v.recordList", response);
            						debugger;
            						var recList = component.get("v.recordList");	
            						debugger;				
        						},
        					
        					params);
        					
         //Retrieve list of fields and properties for the suppression contracts
         helper.callServer(component,'c.retrieveSuppFieldPropDetails',
        						function(response){
            						component.set("v.fieldList", response);				
        						},
        					
        					null);
        	 
    },
    doEdit : function(component,event,helper){
		
		var edMode = component.get("v.editMode");
        component.set("v.editMode", !edMode);
        
        var idx = event.target.id;
		var recList = component.get("v.recordList");
		
		for(var i = 0; i < recList.length; i++){
			
            var recordId = recList[i].checkboxId;
			if(idx == recordId){
				recList[i].isSelected = !recList[i].isSelected;
				break;
			}
		}
		
		component.set("v.recordList", recList);
	},
	doSave : function(component,event,helper){
		
		var recList = component.get("v.recordList");
		//Need to loop through all of the entries in the list and then set the sObject types so that the 
		//server can reserialise the records
		for(var i=0; i < recList.length; i++){
			var recEntry = recList[i];
			var supEntry = recEntry.objectMap['Suppression__c'];
			var contEntry = recEntry.objectMap['Contract__c'];
			let suppatributes =  {
						"type": 'Suppression__c',
			};
			
			let contatributes =  {
						"type": 'Contract__c',
			};
			
			supEntry.attributes=suppatributes;
			contEntry.attributes=contatributes;
		}
		
		//Now turn the list into a string to pass to the server as current bug does not permit lists
		//to be sent to Apex class - an internal error occurs
		
		var contractSupressString = JSON.stringify(recList);

		let params = {
            "contractSupressString": contractSupressString,
            "customerId": component.get("v.recordId"),
       	};
       					  
        helper.callServer(component,'c.saveContractSupressions',
        						function(response){
            						if(response!='SUCCESS'){
            							alert(response);
            						}
                                    else{
                                        component.set("v.manageSupressions", false);
                                    }
            									
        						},
        					
        					params);
		
	},
    doManageSupression : function(component,event,helper){
        helper.doInit(component, event, helper);
        component.set("v.manageSupressions", true);
	},
    doCancel : function(component,event,helper){
        component.set("v.manageSupressions", false);
	}
})
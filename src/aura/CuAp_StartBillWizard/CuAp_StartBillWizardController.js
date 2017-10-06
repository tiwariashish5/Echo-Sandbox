({
	doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
	},
    doStartBilling : function(component,event,helper){	
		helper.doStartBilling(component, event, helper);
	},
    handleWizardEvent : function(component,event,helper) {
        
        //Get information from the event and then handle what the
        //wizard should do
    	
        var message = event.getParam("message");
        
        if(message =="CANCEL"){
            helper.doCancel(component, event, helper);
        }
        else if(message =="NEXT"){
            helper.doNext(component, event, helper);
        }
        else if(message =="BACK"){
            helper.doBack(component, event, helper);
        }
        
        //Prevent further event propogation
        event.stopPropagation();
    },
    doCancel : function(component,event,helper){	
		helper.doCancel(component, event, helper);
	},
    doNext : function(component,event,helper){	
		helper.doNext(component, event, helper);
	},
 	doBack : function(component,event,helper){	
		helper.doBack(component, event, helper);
	}
    
})
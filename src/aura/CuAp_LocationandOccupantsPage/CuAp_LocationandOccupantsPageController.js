({
	handleWizardEvent : function(cmp, event) {
        
        //Do any special processing here and then rethrow event
    	var message = event.getParam("message");		
    },
    doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
	}
})
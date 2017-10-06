({
    handleWizardEvent : function(component, event, helper) {
        //Do any special processing here and then rethrow event
        var message = event.getParam("message");
        
        //event.stopPropagation();
    },
    handleRowSelectEvent : function(component, event, helper) {
		helper.handleRowSelectEvent(component, event, helper);
    },
    doInit : function(component,event,helper){	
        helper.doInit(component, event, helper);
    },
    doSearch : function(component,event,helper){	
        helper.doSearch(component, event, helper);
    }
    
})
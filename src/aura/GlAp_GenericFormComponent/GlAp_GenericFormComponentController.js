({
	doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
	},
    saveClient : function(component, event, helper) {
		helper.saveClient(component, event, helper);
    },
    updateValue : function(component, event, helper) {
        helper.updateValue(component, event, helper);
    },
    doToggleSection : function(component, event, helper) {
        helper.doToggleSection(component, event, helper);
	},
	doEdit : function(component, event, helper) {
		component.set("v.editMode", true);
	},
	doCancel : function(component, event, helper) {				
		helper.doCancel(component, event, helper);	
	},
	doSave : function(component, event, helper) {
		helper.doSave(component, event, helper);
	}

})
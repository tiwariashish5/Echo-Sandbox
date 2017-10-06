({
	fetchListOfRecordTypes: function(component, event, helper) {
      component.set("v.manageFields", true);
    },
    doInit : function(component, event, helper) {
		helper.getData(component, event, helper);
        //fetchListOfRecordTypes(component, event, helper);   
	},
    
    closeModal: function(component, event, helper) {
      // set "manageFields" attribute to false for hide/close model box 
        component.set("v.manageFields", false);
        /*var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;*/
    },
    doManageFields : function(component,event,helper){
        helper.getData(component, event, helper);
        component.set("v.manageFields", true);
	}
})
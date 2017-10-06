({
    /* Method to fetch record types for account*/
	fetchListOfRecordTypes: function(component, event, helper) {
      var action = component.get("c.fetchRecordTypeValues");
      action.setCallback(this, function(response) {
         component.set("v.lstOfRecordType", response.getReturnValue());
      });
      $A.enqueueAction(action);
    },
	/* Method to override household account create page 
	 *  with household contact create page
	 */
    createRecord: function(component, event, helper) {
      component.set("v.isOpen", true);
 
      var action = component.get("c.getRecTypeId");
      var recordTypeLabel = component.find("selectid").get("v.value");
      action.setParams({
         "recordTypeLabel": recordTypeLabel
      });
      action.setCallback(this, function(response) {
         var state = response.getState();
         if (state === $A.get("$Label.c.CuAp_LightningStateSuccess")) {
            var createRecordEvent = $A.get("e.force:createRecord");
            var recTypeID  = response.getReturnValue();
             var evt = $A.get("e.force:navigateToComponent");
             if(recordTypeLabel == $A.get("$Label.c.AccAp_AccountRecordTypeHouseholdAccount")){
                evt.setParams({
                   componentDef: "c:CuAp_HHCustomerPage",
                    componentAttributes:{manageFields: "true"}
            	});
                evt.fire();
             }
             else{
                 createRecordEvent.setParams({
                   "entityApiName": 'Account',
                   "recordTypeId": recTypeID
            });
            	createRecordEvent.fire();
            }
            
            
             
         } else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
               "title": $A.get("$Label.c.CuAp_LightningStateNotSuccessTitle"),
               "message": $A.get("$Label.c.CuAp_LightningStateNotSuccessMessage")
            });
            toastEvent.fire();
         }
      });
      $A.enqueueAction(action);
    },
	/* Method to close the record type selection modal box*/
    closeModal: function(component, event, helper) {
      // set "isOpen" attribute to false for hide/close model box 
      component.set("v.isOpen", false);
      var url = window.location.href; 
            var value = url.substr(0,url.lastIndexOf('/') + 1);
            window.history.back();
            return false;
    }
})
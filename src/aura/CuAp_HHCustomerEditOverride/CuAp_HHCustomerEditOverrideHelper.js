({
	doInit : function(component, event, helper) {
		var action = component.get("c.getHHAccountRecordTypeName");
        var recId = component.get("v.recordId");
        console.log('Id is ='+recId);
        action.setParams({
         "recordId": recId
      	});
        action.setCallback(this, function(response) {
            var recTypeName  = response.getReturnValue();
            var evt = $A.get("e.force:navigateToComponent");
			var editRecordEvent = $A.get("e.force:editRecord");
            var alreadyInEdit = false;
            if(recTypeName == "Other Contact"){
                //alreadyInEdit = true;
                alert('Inside if'+recId);
                editRecordEvent.setParams({
                   "recordId": component.get("v.recordId")
            	});
                //if(alreadyInEdit){
                    editRecordEvent.fire();
                //}
                }
            else if(recTypeName == "Household Account"){
                evt.setParams({
                   componentDef: "c:CuAp_HHCustomerPage",
                    componentAttributes:{manageFields: "true",
                                         recordId: recId}
            	});
                evt.fire();
            }
			else if(recTypeName == "Household Contact"){
                evt.setParams({
                   componentDef: "c:CuAp_HHCustomerPage",
                    componentAttributes:{manageFields: "true",
                                         recordId: recId}
            	});
                evt.fire();
            }
			
                
            
            
        });
        $A.enqueueAction(action);
	}
})
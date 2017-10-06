({
	doInit : function(component, event, helper) {
        var recId = component.get("v.recordId");
        var editRecordEvent = $A.get("e.force:editRecord");
		editRecordEvent.setParams({
            "recordId": component.get("v.recordId")
        });
        editRecordEvent.fire();        
	}
})
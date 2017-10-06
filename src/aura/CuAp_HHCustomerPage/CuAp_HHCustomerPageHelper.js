({
	getData : function(component, event, helper) {
        //alert("Do init");
		var action = component.get("c.getHHAccount");
        var recId = component.get("v.recordId");
        //alert(recId);
        //alert(component.get("v.recordId"));
        console.log('Id is ='+recId);
        action.setParams({
         "recordId": recId
      	});
        action.setCallback(this, function(response) {
            //alert(response.getReturnValue());
            //var recTypeName  = response.getReturnValue();
            //alert(response.getReturnValue().contact.FirstName);
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.HHWrapper", response.getReturnValue());
                component.set("v.contact", response.getReturnValue().contact);
                component.set("v.manageFields", true);
                //alert(component.get("v.HHWrapper"));
        	}
        });
        	$A.enqueueAction(action);
	}
})
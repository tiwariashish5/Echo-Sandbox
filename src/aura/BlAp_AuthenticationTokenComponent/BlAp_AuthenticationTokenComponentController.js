({
    // saves the token in the custom setting
	saveToken: function(component, event, helper) {

        console.debug("Saving token: " + component.find("token").get("v.value"));

        var action = component.get("c.updateToken");
        action.setParams({
        	"token": component.find("token").get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.debug(response.getReturnValue());
                component.set("v.response", response.getReturnValue());
            } else {
            	helper.handleError(component, response);
            }
        });
        $A.enqueueAction(action);
    }
})
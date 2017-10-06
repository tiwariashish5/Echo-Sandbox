({
	// clears the response and any errors
    clearResponse: function(component) {
		component.set("v.error", "");
        component.set("v.response", "");
    },

    // called when a request is initiated to render the spinner etc
    requestInitiated: function(component) {
    	this.clearResponse(component);
        component.set("v.calloutInProgress", true);
		component.find("spinner").show();
    },

    // called when a request is completed to hide the spinner etc
    requestComplete: function(component) {
        component.set("v.calloutInProgress", false);
        component.find("spinner").hide();
    },

    // displays any errors
    handleError: function(component, response) {
    	console.log("Exception caught successfully");
        console.log("Error Message", response.getError()[0]);
        console.log("Error Message", response.getError()[0].message);
        component.set("v.error", response.getError()[0].message);
    }
})
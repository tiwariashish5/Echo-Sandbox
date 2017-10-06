({
	// initialise the component
	initialise: function(component, event, helper) {
        helper.clearResponse(component);

        // make server call to check for pdf attachment
        var action = component.get("c.getAttachmentId");
        action.setParams({
        	"billId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.attachmentId", response.getReturnValue());
            } else {
            	helper.handleError(component, response);
            }
        });
        $A.enqueueAction(action);
    },

    // display the pdf attachment
	view : function(component, event, helper) {
		$A.get('e.lightning:openFiles').fire({
		recordIds: [component.get("v.attachmentId")]
		});
    },

    // generates the pdf by calling a Heroku service via the apex controller
	generatePDF: function(component, event, helper) {
		helper.requestInitiated(component);

        // make server call to generate bill
        console.debug("Generating PDF for: " + component.get("v.recordId"));

        var action = component.get("c.getGeneratedPDF");
        action.setParams({
        	"billId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.debug(response.getReturnValue());
                component.set("v.response", response.getReturnValue());
            } else {
            	helper.handleError(component, response);
            }
            helper.requestComplete(component);
        });
        $A.enqueueAction(action);
    }
})
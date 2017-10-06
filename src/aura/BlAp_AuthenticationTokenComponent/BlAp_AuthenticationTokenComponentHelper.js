({
    // displays any errors
    handleError: function(component, response) {
    	console.log("Exception caught successfully");
        console.log("Error Message", response.getError()[0]);
        console.log("Error Message", response.getError()[0].message);
        component.set("v.error", response.getError()[0].message);
    }
})
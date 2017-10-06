({
    // called on component load
	initialise: function(component, event, helper) {
        helper.clearResponse(component);

        // set today's date
        var today = new Date();
        var monthDigit = today.getMonth() + 1;
        if (monthDigit <= 9) {
        	monthDigit = '0' + monthDigit;
        }
        component.set("v.today", today.getFullYear() + "-" + monthDigit + "-" + today.getDate());
    },

    // called on calculate bill button press
	calculateBill: function(component, event, helper) {
		helper.requestInitiated(component);

        // make server call to go to/calculate bill
        helper.callApexGetBillId(component);
    }
})
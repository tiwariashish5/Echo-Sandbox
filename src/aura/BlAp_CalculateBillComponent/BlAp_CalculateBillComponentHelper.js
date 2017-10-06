({
	POLLING_INTERVAL: 2000,		// ms
	MAX_ATTEMPTS: 5,

	// switch to another record page
    goToRecord: function(recordId) {
        console.log('redirecting ...');
        var evt = $A.get("e.force:navigateToURL");
        console.log('record Id: ' + recordId);
        evt.setParams({
            url: "/one/one.app#/sObject/" + recordId
        });
        evt.fire();
    },

    // handle the bill Id response
    handleBillId: function(component, response) {

        if (response.getState() === "SUCCESS") {
        	console.log("getBillId() response: " + response.getReturnValue());
        	
        	// if a bill Id was returned, go straight to the bill
        	if (response.getReturnValue() != null) {

	    		console.log("found a valid bill ... " );
        		component.set("v.billId", response.getReturnValue());

	        	this.requestComplete(component);
				if (component.get("v.billId") != null) {
					this.goToRecord(component.get("v.billId"));
				}
	        	
	        // otherwise initiate a new bill request
	        } else {
	        	this.callApexInitiateBillRequest(component);
	        }
        
        // error exit
        } else {
        	this.handleError(component, response);
        }
       return false;        
	},

    // handle the bill calculation response
    handleBillCalculation: function(component, response) {

        if (response.getState() === "SUCCESS") {
        	var billCalculation = response.getReturnValue();
        	component.set("v.billCalculation", billCalculation);
        	console.log("initiateBillRequest() Response: " + billCalculation);

	        // make the bill request
        	if (billCalculation.Status__c === 'New') {
	        	this.callApexRequestBill(component);
	        	
	        // poll for the bill result
        	} else if (billCalculation.Status__c === 'Pending') {
	        	this.handleBillRequest(component, response);
        	}
        	
        // error exit
        } else {
        	this.handleError(component, response);
        }
       return false;        
	},

    // poll every [interval] until [limit]
	poller: function(callback, interval, limit, component) {
		var loopCounter = 0;
	    callback();

	    var helper = this;
	    var Id = setInterval(function() {
	    	console.log("polling ... " + loopCounter);
	    	callback();
		    if (++loopCounter >= limit - 1) {
		    	clearInterval(Id);
	        	helper.requestComplete(component);
		    }
		}, interval);
		
		// save the Id
        component.set("v.pollerId", Id);
	},
	
	// handle the bill request response
    handleBillRequest: function(component, response) {
    
    	var helper = this;
        if (response.getState() === "SUCCESS") {
        	console.log("requestNewBill() Response: " + response.getReturnValue());
        
        	// poll for the bill result
			helper.poller($A.getCallback(function() {
				helper.callApexGetBill(component);
			}), 
			this.POLLING_INTERVAL, this.MAX_ATTEMPTS, component);        	

        // error exit
        } else {
        	this.handleError(component, response);
        }
       return false;        
	},

	// handle the new bill response
    handleNewBillId: function(component, response) {

        if (response.getState() === "SUCCESS") {
        	console.log("getNewBill() Response: " + response.getReturnValue());
        
        	// good exit when the bill is returned
        	if (response.getReturnValue() != null) {
	    		console.log("got bill result ... " );
        		component.set("v.billId", response.getReturnValue());

	        	// stop polling
		    	clearInterval(component.get("v.pollerId"));

	        	this.requestComplete(component);
				if (component.get("v.billId") != null) {
					this.goToRecord(component.get("v.billId"));
				}

			// bill not ready yet
        	} else {
	    		console.log("bill not ready ... " );
		    }
        	return true;

        // error exit
        } else {
        	this.handleError(component, response);
        }
       return false;        
	},

	// get the bill Id (returns null if bill not valid)
    callApexGetBillId: function(component) {
    
    	// get the bill Id of a valid bill
        var action = component.get("c.getBillId");
        action.setParams({
        	"contractId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {	
        	this.handleBillId(component, response);
        });
        $A.enqueueAction(action);
		console.log("getBillId() call queued");
	},

	// initiate a new bill request
    callApexInitiateBillRequest: function(component) {
    
    	// create or get the bill calculation record
        var action = component.get("c.initiateBillRequest");
        action.setParams({
        	"contractId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {	
        	this.handleBillCalculation(component, response);
        });
        $A.enqueueAction(action);
		console.log("server initiateBillRequest() call queued");
	},

	// request the bill
    callApexRequestBill: function(component) {
        var action = component.get("c.requestNewBill");
        action.setParams({
        	"billCalculation": component.get("v.billCalculation")
        });
        action.setCallback(this, function(response) {
        	this.handleBillRequest(component, response);
        });
        $A.enqueueAction(action);
        console.log("server requestNewBill() call queued");
	},

	// get the bill result
    callApexGetBill: function(component) {
        var action = component.get("c.getNewBill");
        action.setParams({
        	"billCalculation": component.get("v.billCalculation")
        });
        action.setCallback(this, function(response) {
        	this.handleNewBillId(component, response);
        });
        $A.enqueueAction(action);
        console.log("server getNewBill() call queued");
	},

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
({
    doInit : function(component,event,helper){
        
    },
    handleRowSelectEvent : function(component,event,helper){
        var sRowId = event.getParam("RowId");
        var locFound = component.get('v.recordList');
        for(var i = 0; i < locFound.length; i++){
            if(locFound[i].uniqueId != sRowId){
                locFound[i].isSelected = false;
            }
        }
        var wizObj =component.get('v.wizardprop');
        
        wizObj.locationId = sRowId;
        wizObj.allLocations = locFound;
        
        component.set('v.recordList', locFound);
    },
    doSearch : function(component,event,helper){
        debugger;
        var searchLoc = component.get('v.searchLocation');
        var sPostCode = searchLoc['PostalZIPCode__c'];
        var sState = searchLoc['StateProvince__c'];
        var sStreet = searchLoc['Street__c'];
        var sCity = searchLoc['City__c'];
        
        //E14 9SH
        //
        //Retrieve the list of contracts and current suppression for the customer
        let params = {
            "sPostCode": sPostCode,
            "sState": sState,
            "sStreet": sStreet,
            "sCity": sCity    
        };
        
        //Retrieve list of fields and properties for the location
        helper.callServer(component,'c.retrieveLocationPropDetails',
                          function(response){
                              component.set("v.fieldList", response);				
                          },
                          
                          null);
        
        
        helper.callServer(component,'c.queryForLocations',
                          function(response){
                              component.set('v.recordList', response);
                              if(response.length > 0){
          						component.set('v.locationsFound', true);
                              }
                              else{
                                  component.set('v.locationsFound', false);
                              }
                              
                          },
                          
                          params);
    },
    //Had to add the call server here as there was an issue when resolving the
    //component when going to the base class
    callServer : function(component,method,callback,params) {
        debugger;
        var action = component.get(method);
        if (params) {
            action.setParams(params);
        }
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                callback.call(this,response.getReturnValue());   
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log("Errors", errors);
                    if (errors[0] && errors[0].message) {
                        throw new Error("Error" + errors[0].message);
                    }
                } else {
                    throw new Error("Unknown Error");
                }
            }
        });
        
        $A.enqueueAction(action);
    }
})
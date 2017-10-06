({
    doInit : function(component, event, helper) {           
        component.set("v.stepNumber", 1);
        component.set("v.startStep", true);
        component.set("v.endStep", false);
        component.set("v.wizardprop", new Object());
        
        helper.doSetProgressPathDetails(component,event,helper);
    },
    doSetProgressPathDetails: function(component,event,helper){
        var stepNum = component.get("v.stepNumber");
        var stepNames = ["Search for Location", "Verify Location", "Select Supply Points"];
        
        var stageList = [];
        for(var i =0; i < stepNames.length; i++){
            var stepComp = i+1;
            if(stepComp < stepNum){
                stageList.push({
                    Name: stepNames[i],
                    Status: 'PastComplete'
                });
            }
            else if(stepComp == stepNum){
                stageList.push({
                    Name: stepNames[i],
                    Status: 'Current'
                });
            }
                else{
                   stageList.push({
                    Name: stepNames[i],
                    Status: 'Future'
                }); 
                }
        } 
        component.set("v.stageList", stageList);
    },
    doStartBilling : function(component,event,helper){
        helper.doInit(component, event, helper);
        component.set("v.startBilling", true);
    },
    doCancel : function(component,event,helper){
        helper.doInit(component, event, helper);
        component.set("v.startBilling", false);
    },
    doNext : function(component,event,helper){	
        var step = component.get("v.stepNumber");
        helper.resetSteps(component, event, helper);
        
        if(step < 3){
            step++;
        }
        if(step == 3){
            component.set("v.endStep", true);
        }
        
        component.set("v.stepNumber", step);
        helper.doSetProgressPathDetails(component,event,helper);
    },
    doBack : function(component,event,helper){	
        var step = component.get("v.stepNumber");
        
        helper.resetSteps(component, event, helper);
        
        if(step > 1){
            step--;
        }
        if(step == 1){
            component.set("v.startStep", true);
        }
        
        component.set("v.stepNumber", step);
        helper.doSetProgressPathDetails(component,event,helper);
    },
    
    resetSteps : function(component,event,helper){
        component.set("v.startStep", false);
        component.set("v.endStep", false);
    }
    
})
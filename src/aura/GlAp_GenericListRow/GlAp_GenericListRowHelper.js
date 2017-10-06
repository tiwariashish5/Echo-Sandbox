({
	doInit : function(component,event,helper){
    	debugger;
        var rec = component.get("v.record");
        var edMode = rec.isSelected;
        component.set("v.editMode", edMode);
    },
    doEdit : function(component,event,helper){
		
        //retrive the record
       	var rec = component.get("v.record");
        
       	//Toggle the isSelected Value
       	rec.isSelected = !rec.isSelected;
        
        //Set the editMode to true if the rec is not selected
       	var edMode = rec.isSelected;
        
        //Update the component properties
        component.set("v.editMode", edMode);
        component.set("v.record", rec);
        
        var cmpEvent = component.getEvent("rowEvent");
        cmpEvent.setParams({"RowId" :  rec.uniqueId});
        cmpEvent.fire();
	}
})
/**********************************************************************************************
     * @author: Satish Nair
     * @date: 16th Aug,2017
     * @description: This trigger is used to call all operations on Contact.
     * Revisions(s): 05-09-2017 - Shivangi Gaur - Updated code as per trigger framework.             
     **********************************************************************************************/
     
    trigger GlUt_ContactTrigger on Contact (after delete, after insert, after undelete, after update, before delete, before insert, before update){
        
        //Create a new parameters object for the trigger handler
        GlUt_TriggerHandlerObj trigObj = new GlUt_TriggerHandlerObj();
        
        //Update the object with trigger properties
        trigObj.TriggerObject = GlUt_Constants.OBJCONTACT;       
        trigObj.IsBefore = trigger.IsBefore;
        trigObj.IsDelete =trigger.IsDelete;
        trigObj.IsAfter =  trigger.IsAfter;
        trigObj.IsInsert = trigger.IsInsert;
        trigObj.IsUpdate = trigger.IsUpdate;
        trigObj.IsExecuting = trigger.IsExecuting;
        trigObj.newlist = trigger.new;
        trigObj.newmap =  trigger.newmap;
        trigObj.oldlist = trigger.old;
        trigObj.oldmap =trigger.oldmap;
            
        //Invoke the central dispatcher with the parameter object
        GlUt_CentralDispatcher.mainEntry(trigObj); 
        
    }
({
 
   /* On the component Load this function call the apex class method, 
    * which return the list of RecordTypes of object 
    * and set it to the lstOfRecordType attribute to display record Type values
    * on ui:inputSelect component. */
 
   fetchListOfRecordTypes: function(component, event, helper) {
       helper.fetchListOfRecordTypes(component, event, helper);
   },
 
   /* In this "createRecord" function, first we have call apex class method 
    * and pass the selected RecordType values[label] and this "getRecTypeId"
    * apex method return the selected recordType ID.
    * When RecordType ID comes, we have call  "e.force:createRecord" as per record type selected
    * event and pass object API Name and 
    * set the record type ID in recordTypeId parameter. and fire this event
    * if response state is not equal = "SUCCESS" then display message.
    */
   createRecord: function(component, event, helper) {
       helper.createRecord(component, event, helper);
   },
 
	/* In this "closeModal" function, record type selection
	 *  modal box is closed.
     */
   closeModal: function(component, event, helper) {
       helper.closeModal(component, event, helper);
   }
})
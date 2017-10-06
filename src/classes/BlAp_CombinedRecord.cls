/**********************************************************************************************
@author      	Accenture: Luke Emberton
@date      		09-Sep-2017
@description		xxx
**********************************************************************************************/
public class BlAp_CombinedRecord{
		
		@AuraEnabled
   	 	public boolean isSelected{get;set;}
   	 	
   	 	@AuraEnabled
   	 	public string uniqueId{get;set;}
   	 	
   	 	@AuraEnabled
   	 	public string checkboxId{
   	 		get{
   	 			return 'add-checkbox-' + uniqueId;
   	 		}
   	 		
		}
		
		@AuraEnabled
		public Map<string, sObject> objectMap{get;set;} 		 	
}
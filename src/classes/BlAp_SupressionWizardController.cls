public with sharing class BlAp_SupressionWizardController {
     
    private static List<string> supFields;
    private static List<string> conFields;
    
    private static boolean fieldsInitialised = false;
    
    static{
            //Get Fields from the Supression Object
            supFields = new List<string>();
            supFields.add('SuppressionReason__c');
            supFields.add('SuppressionStartDate__c');
            supFields.add('SuppressionEndDate__c');
            supFields.add('SuppressBillPrint__c');
            supFields.add('SuppressRecoveryNotice__c');
            
            
            //Get Fields from the Contact Object
            conFields = new List<string>();
            conFields.add('Name');
            conFields.add('Status__c');
            conFields.add('BillingFrequency__c');
    }
    
    
    /**********************************************************************************************
    @author         Accenture: Luke Emberton
    @date           04-Sep-2017
    @return         List<GLAp_FieldProps>
    @description        This method returns the field properties for each of the fields that are
                    to be displayed on the screen
    **********************************************************************************************/
     @AuraEnabled
    public static List<GLAp_FieldProps> retrieveSuppFieldPropDetails() {
        
        //Get the field properties for the supression object
        List<GLAp_FieldProps> suprProps = GlAp_LightningDataAccess.getObjectsFieldProperties(BlAp_Constants.SUPRESSIONAPINAME, supFields);
        
        //Get the field properties from the contract object
        List<GLAp_FieldProps> contractProps = GlAp_LightningDataAccess.getObjectsFieldProperties(BlAp_Constants.CONTRACTAPINAME, conFields);
        
        //Want to make all of the contract fields readonly
        for(GLAp_FieldProps conProp: contractProps){
            conProp.isEditable = false;
        }
        
        //Build a map list of all field properties
                    
        List<GLAp_FieldProps> fldPropList = new List<GLAp_FieldProps>();
        for(GLAp_FieldProps fldProp : suprProps){
            fldPropList.add(fldProp);                           
        }
            
        for(GLAp_FieldProps fldProp : contractProps){
            fldPropList.add(fldProp); 
        }
        
        return fldPropList;
        
    } 
    
    
    /**********************************************************************************************
    @author         Accenture: Luke Emberton
    @date           04-Sep-2017
    @param          string customerId
    @return         List<BlAp_SupressContracts>
    @description        This method takes the customerId to return all contracts and associated
                    supressions records in a combined list of wrapper objects
    **********************************************************************************************/
     
     @AuraEnabled
     public static List<BlAp_CombinedRecord> retrieveContractSupressions(string customerId) {
            
        List<BlAp_CombinedRecord>  contractSupressList = new List<BlAp_CombinedRecord>();
        
        string sOQLQuery ='';
        
        //Query for all contracts under the account
        sOQLQuery = String.format('SELECT {0} FROM {1}', new List<String>{'Id,' + String.join(conFields,','), BlAp_Constants.CONTRACTAPINAME +' WHERE CustomerName__c =\''+customerId +'\''});
        List<Contract__c> conList = Database.query(sOQLQuery);
                
        //Query for all supressions under the account, prob need to update to only get the active supression for a contract i.e. there should only be 1
        sOQLQuery = String.format('SELECT {0} FROM {1}', new List<String>{'Id, Contract__c,' + String.join(supFields,','), BlAp_Constants.SUPRESSIONAPINAME + ' WHERE Account__c =\''+customerId +'\''});
        List<Suppression__c> supList = Database.query(sOQLQuery); 
        
        //Check the security on the contact fields
        conList = GlUt_FieldSecurity.cleanseFields(conList, conFields, true);
        
        //Check the security on the supression fields
        supList = GlUt_FieldSecurity.cleanseFields(supList, supFields, true);
            
        Map<Id, Suppression__c> conSupMap = new Map<Id, Suppression__c>();
        
        //Loop through the list of supressions and add to a Map of Contract Id to Supression Id
        for(Suppression__c sup: supList){
            conSupMap.put(sup.Contract__c, sup);
        }
        
        //Loop throught the contract list and capture the appropriate suppresion information
        for(Contract__c con : conList){
            
            boolean isSupressed = false;
            Suppression__c sup = new Suppression__c();
            sup.SuppressionReason__c ='';
            
            if(conSupMap.containsKey(con.Id)){
                sup = conSupMap.get(con.Id);
                isSupressed = true;
            }
            
            BlAp_CombinedRecord supContract = new BlAp_CombinedRecord();            
            supContract.uniqueId=con.Id;
            supContract.isSelected = isSupressed;
            supContract.objectMap = new Map<string, sObject>();
            supContract.objectMap.put(BlAp_Constants.CONTRACTAPINAME, con);
            supContract.objectMap.put(BlAp_Constants.SUPRESSIONAPINAME, sup);                                   
            contractSupressList.add(supContract);
            
        }
        system.debug(JSON.serialize(contractSupressList))   ;
        return contractSupressList;
                
     }
     
    /**********************************************************************************************
    @author         Accenture: Luke Emberton
    @date           04-Sep-2017
    @param          string contractSupressString
    @param          string customerId
    @return         void
    @description        This method takes a string to work around lighnting component issue of not
                    being able to accept a list paramter. It processes the various contracts
                    which are marked for supression and then either creates or deletes the 
                    corresponding supression record
    **********************************************************************************************/
     
     @AuraEnabled
     public static string saveContractSupressions(string contractSupressString, string customerId) {    
        system.debug('testjsonstring'+contractSupressString);
        string retVal = 'SUCCESS';
        
        //Deserialise the JSON String into a list of contractSupressRecords
        List<BlAp_CombinedRecord> contractSupressList = (List<BlAp_CombinedRecord>)JSON.deserialize(contractSupressString, List<BlAp_CombinedRecord>.class);
        
        List<Suppression__c> supresionsToInsert= new List<Suppression__c>();
        List<Suppression__c> supresionsToUpdate = new List<Suppression__c>();
        List<Suppression__c> supresionsToDelete = new List<Suppression__c>();
        
        //Loop over the list of contract supressions
        for(BlAp_CombinedRecord conSupr : contractSupressList){
            boolean isSupressed = conSupr.isSelected;
            Suppression__c sup = (Suppression__c)conSupr.objectMap.get(BlAp_Constants.SUPRESSIONAPINAME);
            Contract__c con = (Contract__c)conSupr.objectMap.get(BlAp_Constants.CONTRACTAPINAME);
            
            //Work out if the supression should deleted, this i where the contract should not be supressed
            //and the supression has an id
            if(!isSupressed && sup.id != null){
                supresionsToDelete.add(sup);
            }
            else if(isSupressed){
                
                if(sup.Id == null){
                    sup.Contract__c = con.Id;
                    //sup.Account__c = customerId; //Commenting this line as contract level supresion will not be linked to Account
                    supresionsToInsert.add(sup);
                }
                else{
                    supresionsToUpdate.add(sup);
                }
                
            }
            
        } 
        
        try{
            //Check the field security on the records to be upserted
            supresionsToInsert = GlUt_FieldSecurity.cleanseFields(supresionsToInsert, supFields, false);
            supresionsToUpdate = GlUt_FieldSecurity.cleanseFields(supresionsToUpdate, supFields, false);
            
            delete supresionsToDelete;
            
            insert supresionsToInsert;
            update supresionsToUpdate;
        }
        catch (Exception ex){
            retVal = 'Error Saving Supression Updates';
        }
        
        return retVal;

     }
    
    
}
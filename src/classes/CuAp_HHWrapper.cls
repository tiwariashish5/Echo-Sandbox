/**********************************************************************************************
@author         Accenture : Manish Singh
@date           18-Sep-2017
@description:   This is wrapper Class used to map Account & Contact fields in Aura component.
@group          Customer 
**********************************************************************************************/
public class CuAp_HHWrapper{
    @AuraEnabled 
    public Account account{get;set;}   
    @AuraEnabled
    public Contact contact{get;set;}
    @AuraEnabled
    public  List<GlAp_FieldProps> conFieldList{get;set;}
    @AuraEnabled
    public  List<GlAp_FieldProps> accFieldList{get;set;}
    @AuraEnabled
    public BlAp_CombinedRecord contactAccountRec{get;set;}

    public CuAp_HHWrapper(){
        account = new account();
        contact = new contact();
        contactAccountRec = new BlAp_CombinedRecord (); 
        conFieldList = GlAp_LightningDataAccess.getObjectsFieldProperties(GlUt_Constants.OBJCONTACT, contactFields);
        accFieldList = GlAp_LightningDataAccess.getObjectsFieldProperties(GlUt_Constants.OBJACCOUNT, accountFields);
    }
    /*
    public string accountName{get;set;}
    @AuraEnabled
    public string contactFirstName{get;set;}
    @AuraEnabled
    public string contactLastName{get;set;}
    @AuraEnabled
    public string accountType{get;set;}
    @AuraEnabled
    public string accountRecordType{get;set;}
    @AuraEnabled
    public string contactRecordType{get;set;}
    @AuraEnabled
    public string contactType{get;set;}
    @AuraEnabled
    public integer mobilePhone{get;set;}
    @AuraEnabled
    public string Email{get;set;}
    */ 
    public static List<string> accountFields;   
    static{
            //Get Fields from the Supression Object
            accountFields = new List<string>();
            accountFields.add('Name');
            accountFields.add('Type');
            accountFields.add('RecordTypeId');
            accountFields.add('AccountNumber');
            //accountFields.add('Street__c');
            //accountFields.add('City__c');
            //accountFields.add('StateProvince__c');
            //accountFields.add('PostalZIPCode__c');
            //accountFields.add('ParentLocation__c');
            //accountFields.add('LocationType__c');
            //accountFields.add('LocationSubType__c');
            //accountFields.add('LocationReference__c');
                    
    }
    public static List<string> contactFields;   
    static{
            //Get Fields from the Supression Object
            contactFields = new List<string>();
            contactFields.add('FirstName');
            contactFields.add('LastName');
            contactFields.add('RecordTypeId');
            contactFields.add('AccountId');
            contactFields.add('MobilePhone');
            contactFields.add('Email');
            contactFields.add('ContactType__c');        
    }
}
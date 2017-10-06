/**********************************************************************************************
@author         Accenture : Manish Singh
@date           18-Sep-2017
@description:   This is controller Class used to Query & Edit House hold accounts.  
@group          Customer 
**********************************************************************************************/
public with sharing class CuAp_HHCustomerController {
    @AuraEnabled 
    public Account account{get;set;}   
    @AuraEnabled
    public Contact contact{get;set;}
    @AuraEnabled
    public Id recordId{get;set;}
    //@AuraEnabled
    //public  List<GlAp_FieldProps> conFieldList{get;set;}
    //@AuraEnabled
    //public  List<GlAp_FieldProps> accFieldList{get;set;}
    // Default constructor for Query account or contact
    public CuAp_HHCustomerController(){
    }
        
    @AuraEnabled
    public static CuAp_HHWrapper getHHAccount(Id recordId){
        CuAp_HHWrapper HHWrapper = new CuAp_HHWrapper();
        BlAp_CombinedRecord contactAccountRec = new BlAp_CombinedRecord();
        
        List<BlAp_CombinedRecord>  HHAccountList = new List<BlAp_CombinedRecord>();
        
        if(recordId ==null){
            emptyHHAccount();            
        }
        else{        
            String sObjName = recordId.getSObjectType().getDescribe().getName();
            list<Contact>  conList = new list<Contact>();
            list<Account>  accList = new list<Account>();             
            //CuAp_HHWrapper.accountFields;
            string sOQLQueryAccount ='';
            string sOQLQueryContact ='';
            if(sObjName ==GlUt_Constants.OBJACCOUNT){
                //Query  if invoked from account
                sOQLQueryAccount = String.format('SELECT {0} FROM {1}', new List<String>{'Id,' + String.join(CuAp_HHWrapper.accountFields ,','), 
                    GlUt_Constants.OBJACCOUNT +' WHERE Id =\''+recordId +'\' ' });        
                accList  = Database.query(sOQLQueryAccount);
                //sOQLQuery = null;  
                if(accList  != null){            
                    sOQLQueryContact = String.format('SELECT {0} FROM {1}', new List<String>{'Id,' + String.join(CuAp_HHWrapper.contactFields ,','), 
                    GlUt_Constants.OBJCONTACT  +' WHERE AccountId =\''+accList[0].Id +'\' limit 1 ' });
                   conList  = Database.query(sOQLQueryContact);
                }
            }
            else if(sObjName ==GlUt_Constants.OBJCONTACT){ 
                sOQLQueryContact = String.format('SELECT {0} FROM {1}', new List<String>{'Id,' + String.join(CuAp_HHWrapper.contactFields ,','), 
                    GlUt_Constants.OBJCONTACT +' WHERE Id =\''+recordId +'\' ' });
                conList = Database.query(sOQLQueryContact);
                if(conList  != null){
                    sOQLQueryAccount = String.format('SELECT {0} FROM {1}', new List<String>{'Id,' + String.join(CuAp_HHWrapper.accountFields ,','), 
                    GlUt_Constants.OBJACCOUNT +' WHERE Id =\''+conList[0].AccountId +'\' limit 1 ' });        
                    accList  = Database.query(sOQLQueryAccount);    
                }
            }
            
            //Check the security on the contact fields       
            conList = GlUt_FieldSecurity.cleanseFields(conList, CuAp_HHWrapper.contactFields, true);
            //Check the security on the contact fields       
            accList = GlUt_FieldSecurity.cleanseFields(accList, CuAp_HHWrapper.accountFields, true);           
            contactAccountRec.uniqueId=recordId;
            contactAccountRec.objectMap = new Map<string, sObject>();
            contactAccountRec.objectMap.put(GlUt_Constants.OBJACCOUNT, accList[GlUt_Constants.INDEX0]);
            contactAccountRec.objectMap.put(BlAp_Constants.SUPRESSIONAPINAME, conList[GlUt_Constants.INDEX0]);
            HHWrapper.contactAccountRec = contactAccountRec;
            
        }
        system.debug('@@@ :'+contactAccountRec);
        system.debug(JSON.serialize(contactAccountRec))   ;
        return HHWrapper;            
    }
    @AuraEnabled
    public static BlAp_CombinedRecord  emptyHHAccount(){
        BlAp_CombinedRecord  HHAccount = new BlAp_CombinedRecord();
        return new BlAp_CombinedRecord();        
    }
}
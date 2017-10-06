/******************************************************************************
@author:      Accenture: Shivangi Gaur
@date:        25 September 2017
@description: Test Class for GlUt_FieldSecurity
*******************************************************************************/

@isTest
Public Class GlUt_FieldSecurity_Test{
    
    //Variable declaration start
    
    public static String profileName = 'System Administrator';
    public static String profileNameCustom = 'Client Agent';
    public static String userName = 'TestUser';
    public static String userNameCustom = 'TestUser101';
    public static String accName = 'TestAccount';
    public static String nameField = 'Name';
    public static String typeField = 'Type';
    public static String birthDate = 'BirthDate__c';
    public static String firstName = 'FirstName';
    public static String lastName = 'LastName';
    public static String doNotCall = 'DoNotCall';
    public static String conFirstName = 'Test';
    public static String conLastName = 'Contact 101';
    
    //Variable declaration end

/******************************************************************************
@author:      Accenture: Shivangi Gaur
@date:        25 September 2017
@description: Test data setup method
*******************************************************************************/
    @TestSetup
    static void createTestData(){
        //Create user record
        User objUser = GlUt_TestFactoryData.createUser(profileName,userName,null);
        Database.insert(objUser); 

        //Create user record with custom profile
        User objUserCustom = GlUt_TestFactoryData.createUser(profileNameCustom,userNameCustom,null);
        Database.insert(objUserCustom);

        //Create account record
        Account objAccount = GlUt_TestFactoryData.CreateAccount(accName);
        Database.insert(objAccount);
        
        //Create contact record
        Contact objCon = GlUt_TestFactoryData.CreateContact(conFirstName,conLastName);
        Database.insert(objCon);
    }
    
/******************************************************************************
@author:      Shivangi Gaur
@date:        25 September 2017
@description: Test method for getFieldPropertiesObject() method
*******************************************************************************/
    static testmethod void fieldPropertiesObject_Positive(){
        
        //Query user record created in test setup data method
        User objUser =[Select id,name from user where isActive=true limit 1];
        List<String> fieldList = new List<String>{nameField,typeField, birthDate};
        
        //Run test class in user context
        system.runas(objUser){
            List<GlAp_FieldProps> lstFieldProp = GlUt_FieldSecurity.getFieldPropertiesObject(GlUt_Constants.OBJACCOUNT,fieldList);
            System.assert(lstFieldProp.size()>0);
        }
    }
/******************************************************************************
@author:      Shivangi Gaur
@date:        26 September 2017
@description: Test method for cleanseFields() and checkFields() methods
*******************************************************************************/
    static testmethod void cleanseFields_Positive(){
        
        //Query user record created in test setup data method
        User objUser =[Select id,name from user where isActive=true limit 1];
        List<String> fieldList = new List<String>{nameField,typeField, birthDate};
        List<Account> objList = [Select id from Account limit 1];
        
        //Run test class in user context
        system.runas(objUser){
            List<Account> accListFields = GlUt_FieldSecurity.cleanseFields(objList,fieldList,false);
            System.assert(accListFields.size()>0);
            List<Account> accListFieldsNew = GlUt_FieldSecurity.cleanseFields(objList,true);
            System.assert(accListFieldsNew.size()>0);
        }
    }
/******************************************************************************
@author:      Shivangi Gaur
@date:        26 September 2017
@description: Test method for cleanseFields() and checkFields() methods with custom profileName
              to check for read only fields accessibility
*******************************************************************************/
    static testmethod void cleanseFieldsCustomProfile_Positive(){
        
        //Query user record created in test setup data method
        User objUser =[Select id,name from user where isActive=true and Profile.Name =: profileNameCustom limit 1];
                
        List<String> fieldList = new List<String>{firstName,lastName,doNotCall};
        List<Contact> objListContact = [Select id,DoNotCall from Contact limit 1];
        
        //Run test class in user context
        system.runas(objUser){
            List<Account> accListFields = GlUt_FieldSecurity.cleanseFields(objListContact,fieldList,true);
            System.assert(accListFields.size()>0);
            List<Account> accListFieldsNew = GlUt_FieldSecurity.cleanseFields(objListContact,true);
            System.assert(accListFieldsNew.size()>0);
        }
    }
/******************************************************************************
@author:      Shivangi Gaur
@date:        26 September 2017
@description: Test method for cleanseFields() and checkFields() methods with custom profile
              for negative scenario when isRead is false.
*******************************************************************************/
    static testmethod void cleanseFieldsCustomProfile_Negative(){
        
        //Query user record created in test setup data method
        User objUser =[Select id,name from user where isActive=true and Profile.Name =: profileNameCustom limit 1];
        
        List<String> fieldList = new List<String>{firstName,lastName,doNotCall};
        List<Contact> objListContact = [Select id,DoNotCall from Contact limit 1];
        
        //Run test class in user context
        system.runas(objUser){
            List<Account> accListFields = GlUt_FieldSecurity.cleanseFields(objListContact,fieldList,false);
            System.assert(accListFields.size()>0);
            List<Account> accListFieldsNew = GlUt_FieldSecurity.cleanseFields(objListContact,false);
            System.assert(accListFieldsNew.size()>0);
        }
    }   
}
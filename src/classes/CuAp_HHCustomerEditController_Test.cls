/******************************************************************************
@author:      Accenture: Satish Nair
@date:        26th September 2017
@description: Test Class for CuAp_HHCustomerController
*******************************************************************************/

@isTest
Public Class CuAp_HHCustomerEditController_Test{

public static String HOUNSEHOLDACCOUNT ='Household Account';
public static String HOUNSEHOLDCONTACT ='Household Contact';
public static String NONHOUNSEHOLDACCOUNT ='Non-Household Account';
public static String SYSADMIN ='System Administrator';
public static String TESTUSER ='TestUser';
public static String TESTACC ='TestAccount';
public static String TESTFNAME ='TestFirstName';
public static String TESTLNAME ='TestLastName';
    
/******************************************************************************
@author:      Accenture: Satish Nair
@date:        26th September 2017
@description: Test data setup method
*******************************************************************************/
    @TestSetup
    Static void createTestData(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(HOUNSEHOLDACCOUNT).getRecordTypeId();
        Id contRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(HOUNSEHOLDCONTACT).getRecordTypeId();

        User objUser = GlUt_TestFactoryData.createUser(SYSADMIN,TESTUSER,null);
        Database.insert(objUser); 
        
        Account objAccount = GlUt_TestFactoryData.CreateAccount(TESTACC);
        objAccount.recordTypeId = accRecordTypeId;
        Database.insert(objAccount);
        
        Contact con = GlUt_TestFactoryData.CreateContact(TESTFNAME,TESTLNAME); 
        con.recordTypeId = contRecordTypeId;
        Database.insert(con);
         
    }

    /******************************************************************************
@author:      Accenture: Satish Nair
@date:        26th September 2017
@description: Test method for fetching the HH Accounts
*******************************************************************************/
    static testmethod void getHHAccountRecordTypeName(){
        User objUser =[select id,name from user where isActive=true limit 1];
        List<Account> acc = [Select id,name,Recordtype.Name from Account where name=:TESTACC Limit 1];
        system.assertEquals(acc.size()>0,true);
        system.assertEquals(acc[0].Recordtype.Name,HOUNSEHOLDACCOUNT);
        system.runas(objUser){
            CuAp_HHCustomerEditController custacc = new CuAp_HHCustomerEditController();
            custacc.account = acc[0];
            CuAp_HHCustomerEditController.getHHAccountRecordTypeName(acc[0].Id);
        }
    }

        /******************************************************************************
@author:      Accenture: Satish Nair
@date:        26th September 2017
@description: Test method for fetching the HH ContactAccounts
*******************************************************************************/
    static testmethod void getHHContactAccountRecordTypeName(){
        User objUser =[select id,name from user where isActive=true limit 1];
        List<Contact> cont = [Select id,FirstName,RecordType.Name from Contact where FirstName=:TESTFNAME Limit 1];
        system.assertEquals(cont.size()>0,true);
        system.assertEquals(cont[0].Recordtype.Name,HOUNSEHOLDCONTACT);
        system.runas(objUser){
            CuAp_HHCustomerEditController custcon = new CuAp_HHCustomerEditController();
            custcon.contact =cont[0];
            CuAp_HHCustomerEditController.getHHAccountRecordTypeName(cont[0].Id);
        }
    }
}
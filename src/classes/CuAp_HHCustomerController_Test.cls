/******************************************************************************
@author:      Accenture: Satish Nair
@date:        25th September 2017
@description: Test Class for CuAp_HHCustomerController
*******************************************************************************/

@isTest
Public Class CuAp_HHCustomerController_Test{

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
@date:        25th September 2017
@description: Test data setup method
*******************************************************************************/
    @TestSetup
    Static void createTestData(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(HOUNSEHOLDACCOUNT).getRecordTypeId();

        User objUser = GlUt_TestFactoryData.createUser(SYSADMIN,TESTUSER,null);
        Database.insert(objUser); 
        
        Account objAccount = GlUt_TestFactoryData.CreateAccount(TESTACC);
        objAccount.recordTypeId = accRecordTypeId;
        Database.insert(objAccount);
        
        Contact con = GlUt_TestFactoryData.CreateContact(TESTFNAME,TESTLNAME); 
        con.AccountId = objAccount.Id;
        Database.insert(con);
         
    }
    
/******************************************************************************
@author:      Accenture: Satish Nair
@date:        25th September 2017
@description: Test method for fetching the HH Accounts
*******************************************************************************/
    static testmethod void getHHAccount(){
        User objUser =[select id,name from user where isActive=true limit 1];
        List<Account> accList = [Select id,name,Recordtype.Name from Account where name=:TESTACC];
        List<Contact> conList = [Select id,accountId,FirstName from Contact where FirstName=:TESTFNAME and accountId =:accList[0].Id];   
        system.assertEquals(accList.size()>0,true);
        system.assertEquals(accList[0].Recordtype.Name,HOUNSEHOLDACCOUNT);
        system.assertEquals(conList.size()>0,true);
        system.assertNotEquals(conList[0].accountId,null);
        system.runas(objUser){
        Test.startTest();
        CuAp_HHWrapper accWrap = new CuAp_HHWrapper();
        CuAp_HHCustomerController hhcust = new CuAp_HHCustomerController();
        BlAp_CombinedRecord contactAccountRec = new BlAp_CombinedRecord();
        contactAccountRec.uniqueId = accList[0].Id;
        hhcust.account = accList[0];
        hhcust.recordId = accList[0].Id;
        accWrap = CuAp_HHCustomerController.getHHAccount(accList[0].Id);
        
        //acc = GlUt_FieldSecurity.cleanseFields(acc,CuAp_HHWrapper.accountFields,true);
        Test.stopTest();
        }
    } 

    /******************************************************************************
@author:      Accenture: Satish Nair
@date:        25th September 2017
@description: Test method for fetching the HH Contact
*******************************************************************************/
    static testmethod void getHHContactAccount(){
        User objUser =[select id,name from user where isActive=true limit 1];
        List<Contact> con = [Select id,FirstName from Contact where FirstName=:TESTFNAME];
        system.assertEquals(con.size()>0,true);
        system.runas(objUser){
        Test.startTest();
        CuAp_HHCustomerController hhcont = new CuAp_HHCustomerController();
        CuAp_HHWrapper cuWrap = new CuAp_HHWrapper();
        hhcont.contact = con[0];
        CuAp_HHCustomerController.getHHAccount(con[0].Id);
        Test.stopTest();
        }
    }
      /******************************************************************************
@author:      Accenture: Satish Nair
@date:        25th September 2017
@description: Test method for EmptyAccounts
*******************************************************************************/
    static testmethod void getemptyAccount(){
        User objUser =[select id,name from user where isActive=true limit 1];
        system.runas(objUser){
        Test.startTest();
        CuAp_HHCustomerController.getHHAccount(null);
        Test.stopTest();
        }
    }  
}
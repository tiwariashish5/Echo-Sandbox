/******************************************************************************
@author:      Accenture: Sucharu Gupta
@date:        08 September 2017
@description: Test Class for BlIn_PDFExecuteGeneration  
*******************************************************************************/
@isTest
//test data creation for BlIn_PDFExecuteGeneration class
public with sharing class BlIn_PDFExecuteGeneration_Test{
    public static String PDFTEMPLATENAME = 'PDFFormBillTemplate001';
    private static final string HEROKUSECURITY = 'ABCSRESSGSTSEESDGS';
    private static final string SYSADMIN = 'System Administrator';
    private static final string TESTUSER = 'TestUser';
    private static final string TESTBILl = 'testBill';
    private static final string TESTCONTRACT='TestContract';
    private static final string TESTACCOUNT ='TestAccount';
    private static final string ENDPOINT ='http://real-time-billing-app-dev.herokuapp.com/realtime/pdf/generate';
    private static final string EXPECTED = '{"pdf":"generate"}';
  
    
/*******************************************************************
Purpose: method to create test data used by all test methods
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    @TestSetup
    static void createTestData(){
        User objUser = GlUt_TestFactoryData.createUser(SYSADMIN,TESTUSER,null);
        Database.insert(objUser);
        
        Account objAccount = GlUt_TestFactoryData.CreateAccount(TESTACCOUNT);
        Database.insert(objAccount);
        
        Contract__c con = GlUt_TestFactoryData.CreateContract(TESTCONTRACT,objAccount); 
        Database.insert(con);
         
        Bill__c objBill = GlUt_TestFactoryData.CreateBill(TESTBILL,con);
         objBill.CustomerNumber__c = objAccount.id; 
        Database.insert(objBill);
        HerokuSecurity__c hSecurity = GlUt_TestFactoryData.createHerokuSecurity(HEROKUSECURITY);
        DataBase.insert(hSecurity);
    }
    
/*******************************************************************
Purpose: Method to test HEROKU callout to generate a PDF {Positive scenario}
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    Static testMethod void executePDF_Positive(){
        User objUser =[select id,name from user where isActive=true limit 1];
        Set<String> idFields = new Set<String>();
        idFields.add(objUser.Id);
        Set<String> XMLFields = new Set<String>();
        XMLFields.add(objUser.Id);
        Bill__c objBill =[Select id from Bill__c limit 1];
        String PdfId;

        system.runas(objUser){
            Test.startTest();
            // Set mock callout class 
            HttpRequest req = new HttpRequest();
            req.setEndpoint(GlUt_Constants.ENDPOINT);
            req.setMethod(GlUt_Constants.HTTPGET);
            Http h = new Http();
            Test.setMock(HttpCalloutMock.class, new GlUt_MockHttpResponseGenerator_Test(200));
            HttpResponse res = h.send(req);
            // Verify response received contains fake values
            String contentType = res.getHeader(GlUt_Constants.HEADER);
            System.assert(contentType == GlUt_Constants.CONTENTTYPE);
            String actualValue = res.getBody();
            String expectedValue = EXPECTED;
            System.assertEquals(actualValue, expectedValue);
            System.assertEquals(200, res.getStatusCode());
            BlIn_PDFExecuteGeneration.executePDF(objBill.Id);
            BlIn_PDFPrepareBillData objPDFData = new BlIn_PDFPrepareBillData(objBill.id, PDFTEMPLATENAME);
            BlIn_PDFCreateBillDataXML createXML = new BlIn_PDFCreateBillDataXML(objPDFData.billData);
            Test.StopTest();
        }
        
    }

    /*******************************************************************
Purpose: Method to test HEROKU callout to generate a PDF {Negative scenario}
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    Static testMethod void executePDF_Negative(){
        User objUser =[select id,name from user where isActive=true limit 1];
        Bill__c objBill =[Select id from Bill__c limit 1];
        String PdfId;
        system.runas(objUser){
            Test.startTest();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(GlUt_Constants.ENDPOINT);
            req.setMethod(GlUt_Constants.HTTPGET);
            Http h = new Http();
            Test.setMock(HttpCalloutMock.class, new GlUt_MockHttpResponseGenerator_Test(201));
            HttpResponse res = new HttpResponse();
            res= h.send(req);
            String actualValue = res.getBody();
            String expectedValue = EXPECTED;
            System.assertEquals(actualValue, expectedValue);
            System.assertEquals(201, res.getStatusCode());
            BlIn_PDFExecuteGeneration.executePDF(objBill.Id);
            PdfId = GlUt_ContentDocument.saveLinkedDocument(objBill.Id,'Bill pdf', 'bill PDF '+ objBill.Id + '.pdf', res.getBodyAsBlob());
            Test.StopTest();
            
        }
    }

}
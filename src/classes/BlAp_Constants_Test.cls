/******************************************************************************
@author:      Accenture: Vivek Chauhan
@date:        25 September 2017
@description: Test Class for BlAp_Constants
*******************************************************************************/

@isTest
//test data creation for BlAp_Constants class
Public Class BlAp_Constants_Test{
    private static final string SYSADMIN = 'System Administrator';
    private static final string TESTUSER = 'TestUser';
    
    
    @TestSetup
    Static void createTestData(){
        
        User objUser = GlUt_TestFactoryData.createUser(SYSADMIN ,TESTUSER ,null);
        Database.insert(objUser); 
    }
    
/*******************************************************************
Purpose: Method to test BlAp_Constants class 
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    
    static testmethod void BlAp_Constants_Positive(){
        User objuser = [select id from  user limit 1];
        system.runas(objuser){
        String preFix = BlAp_Constants.PREFIX;
        String contractName = BlAp_Constants.CONTRACTAPINAME;
        String suppressionApiName =BlAp_Constants.SUPRESSIONAPINAME;                   
        system.assert(preFix!=null);
        system.assert(contractName!=null);
        }
        
    }
    
}
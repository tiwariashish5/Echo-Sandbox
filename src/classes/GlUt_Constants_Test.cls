/******************************************************************************
@author:      Accenture: Vandana Anshu
@date:        25 September 2017
@description: Test Class for GlUt_Constants
*******************************************************************************/

@isTest
//test data creation for GlUt_Constants class
Public Class GlUt_Constants_Test{
    private static string userProfileName = 'System Administrator';
    private static string userName= 'TestUser';
    private static string managerId= Null;


 @TestSetup
    Static void createTestData(){
        
        User objUser = GlUt_TestFactoryData.createUser(userProfileName, userName, managerId);
        Database.insert(objUser); 
        }
        
/*******************************************************************
Purpose: Method to test GlUt_Constants class 
Parameters: N/A 
Returns: void
Throws [Exceptions]: N/A
********************************************************************/
    
    static testmethod void GlUt_Constants_Positive(){
    
    String preFix = GlUt_Constants.PREFIX;
    String handlerSuffix = GlUt_Constants.HANDLERSUFFIX;
    String custSetFieldSuffix =GlUt_Constants.CUSTSETFIELDSUFFIX;
    String reading =GlUt_Constants.OBJREADING;
    String contact =GlUt_Constants.OBJCONTACT;
    String account =GlUt_Constants.OBJACCOUNT;
    String bill =GlUt_Constants.OBJ_BILL;
                       
    system.assert(preFix!=null);
    system.assert(handlerSuffix!=null);
    system.assert(custSetFieldSuffix!=null);

    
    }

}
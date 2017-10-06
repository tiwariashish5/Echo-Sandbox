/************************************************************************************************************
@author         Accenture : Luke Emberton
@date           24-Aug-2017
@description:   This is the constants class for all static strings used in this namespace
Revisions(s)    05-09-2017 - Shivangi Gaur - Added constant for Contact object name to be used in Contact trigger. 
**************************************************************************************************************/
public class GlUt_Constants {
    
    // The prefix for this namespace
    public static string PREFIX = 'GlUt_';
    
    // Appended to the end of all trigger handler classes
    public static string  HANDLERSUFFIX = 'Handler';
    
    // Suffix for trigger automation custom setting fields
    public static string  CUSTSETFIELDSUFFIX = 'Triggers__c';   
    
    // Trigger object names and the prefix for trigger class and field names
    public static string  OBJREADING = 'Reading';       // Manish Added on 04-Sep-2017
    public static string  OBJCONTACT = 'Contact';       // Shivangi - Added on 05-Sep-2017
    public static string  OBJACCOUNT = 'Account';       // Manish- Added on 22-Sep-2017
    public static string  OBJ_BILL = 'Bill';        // 21 Sep 2017, P Dixon
    
    // List Indexes(Integer) and System variables???
    public static integer LIMITBILLINGCAL                  = 2; // Manish Added on 05-Sep-2017
    public static integer INDEX0                           = 0; // Manish Added on 06-Sep-2017
    public static integer INDEX1                           = 1; // Manish Added on 06-Sep-2017
    public static integer INDEX2                           = 2; // Manish Added on 06-Sep-2017
    public static string  SYSTEMGEN                        = 'System Generated'; // Manish Added on 06-Sep-2017
    
    // HTTP callout related variables Manish Added on 3rd Oct 2017
    public static string ENDPOINT         = 'http://real-time-billing-app-dev.herokuapp.com/realtime/pdf/generate';
    public static string HTTPGET          = 'GET';
    public static string HEADER           = 'Content-Type';
    public static string CONTENTTYPE      = 'application/json';
    public static string PDF              = 'Pdf';
    public static string GENERATE        ='generate';
    
}
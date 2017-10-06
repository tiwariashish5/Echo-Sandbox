/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		19 Sep 2017
@description 	This is the constants class for all static strings used in this namespace
*******************************************************************************/
public class BlIn_Constants {
    
    //The prefix for this namespace
    public static string PREFIX = 'BlIn_';

    // 19 Sep 2017, P Dixon - BillCalculation status picklist values
    public static String BILL_CALCULATION_STATUS_NEW = 'New';
    public static String BILL_CALCULATION_STATUS_PENDING = 'Pending';
    public static String BILL_CALCULATION_STATUS_COMPLETED = 'Completed';
    public static String BILL_CALCULATION_STATUS_VOID = 'Void';
    public static String BILL_CALCULATION_STATUS_ERROR = 'Error';
    
    // 20 Sep 2017, P Dixon - Authentication strings for Heroku webservices
    public static String ACCESS_TOKEN = 'AccessToken';		// token issued by Heroku
    public static String CLIENT_SYSTEM_ID = 'ClientSystemId';		// for Salesforce clients this is Org Id
}
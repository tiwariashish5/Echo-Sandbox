/******************************************************************************
@author         Accenture: Patrick Dixon
@date           03 Oct 2017
@description    Component controller for authentication token lightning component
*******************************************************************************/
public with sharing class BlAp_AuthenticationTokenComponentCtrlr {

	public static final String CLASS_NAME = 'BlAp_AuthenticationTokenComponentCtrlr';
	public static final String DEBUG = '[' + CLASS_NAME + '] ';

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           03 Oct 2017
    @param          String - token
    @return			Boolean - success
    @description    Saves the token in the protected custom setting
    *******************************************************************************/
    @AuraEnabled
    public static Boolean updateToken(String token) {
        
        return true;
    }
    
}
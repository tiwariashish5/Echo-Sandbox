/*********************************************************************************************
@author      Accenture: Sucharu Gupta  
@date        08/09/2017    
@description: This class will be use in unit testing the integration API calls  
@group MockAPIProvider 
**********************************************************************************************/

global with sharing class GlUt_TestMockAPIProvider implements HttpCalloutMock  {
    public class ResponseJson  {
        public Integer responseCode ; 
        public Map<String, Object> headers ; 
        public Map<String, Object> body ; 
        public String blobBody ; 
    }
    
    private ResponseJson response ;
    global GlUt_TestMockAPIProvider(String resourceName) {   
        buildResponseFromResource(resourceName) ;
    }
     /*
    * @description Builds the response based on the static resource.
    */
    private void buildResponseFromResource(String resourceName) {
        System.debug('resourceName'+resourceName);
        StaticResource res = [SELECT Id, Body FROM StaticResource WHERE Name = :resourceName] ; 
        Map<String , Object>  o = (Map<String , Object>) JSON.deserializeUntyped(res.body.toString()) ;
        response = new ResponseJson() ; 
        if (o.get('responseCode') != null)
            response.responseCode = (Integer) o.get('responseCode') ; 
        if (o.get('headers') != null)
            response.headers =  (Map<String, Object>) o.get('headers') ; 
        if (o.get('body') != null)
            response.body = (Map<String , Object> )o.get('body') ; 
         

    }
    /*
    * @return Populate the HttpResponse object and return it base on the content of the static resource. 
    */ 
    private HttpResponse populateResponse() {
        HttpResponse r = new HttpResponse() ;   
        r.setStatusCode(response.responseCode) ; 
        if (response.headers != null) {
            for (String s : response.headers.keySet() ){
                r.setHeader(s, (String) response.headers.get(s)) ; 
            }
        }
        if(response.body != null) {
            r.setBody(JSON.serializePretty(response.body)) ; 
        }
        return r ; 

    }
    global HTTPResponse respond(HTTPRequest req){
        return populateResponse(); 
    }
}
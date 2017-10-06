/*********************************************************************************************
* @author         Accenture: Sucharu Gupta
* @date           7th September,2017 
* @description:   This class will provide mock responses from static resource. You need to pass 
                  the static resource name to this provider class. The static resource 
                  is in following format: 
 
 {
    "responseCode": 200,
    "headers" : {
        "content-type":"application/json",
        "giud" : "some-guid"
    },
    "body": {
        "key1" : "value1" ,
        "key2" : "value2"
    },
    "blobBody" : "wdef3455fsfst5=="
                
 }
 
The response code is the response code that will be returned. 
The headers is optional element that sets the response header 
body is the response that will be the body of the mock response 

*********************************************************************************************/

public with sharing class GlUt_MockAPIProvider {
    public class ResponseJson  {
        public Integer responseCode ; 
        public Map<String, Object> headers ; 
        public Map<String, Object> body ; 
        public String blobBody ; 
    }
    
    private ResponseJson response ;
    /*
    *  @param resourceName : Is the name of the static resource to be loaded. 
    */
    public GlUt_MockAPIProvider(String resourceName) {
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
        if (o.get('blobBody') != null)
            response.blobBody = (String) o.get('blobBody') ; 

    }
    
    /*
    * @return Populate the HttpResponse object and return it base on the content of the static resource. 
    */ 
    public HttpResponse populateResponse() {
        HttpResponse r = new HttpResponse() ;   
        r.setStatusCode(response.responseCode) ; 
        if (response.headers != null) {
            for (String s : response.headers.keySet() ){
                r.setHeader(s, (String) response.headers.get(s)) ; 
            }
        }
        if (response.blobBody != null) {
            r.setBodyAsBlob(EncodingUtil.base64Decode(response.blobBody)) ;
        } else if(response.body != null) {
            r.setBody(JSON.serializePretty(response.body)) ; 
        }
        return r ; 

    }   
    
}
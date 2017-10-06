/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		26 Sep 2017
@description 	Component controller for file upload lightning component
*******************************************************************************/
public with sharing class GlAp_UploadFileComponentCtrlr {
	
	public static final String CLASS_NAME = 'GlAp_UploadFileComponentCtrlr';
	public static final String DEBUG = '[' + CLASS_NAME + '] ';
    
    public static Blob fileContent {get; set;}
    
	@AuraEnabled
    public static Id saveTheChunk(String fileContent, Id parentId, String fileName, String path) { 
    	
	    System.debug('BLOB: ' + fileContent);
		return GlUt_ContentDocument.saveLinkedDocument(parentId, fileName, path, EncodingUtil.base64Decode(fileContent));
/*
    	if (fileContent == null) {
    		fileContent = EncodingUtil.base64Decode(base64Data);
	
    	} else {
    		System.debug('fileContent' + fileContent.size());
    		fileContent = EncodingUtil.base64Decode(base64Data + EncodingUtil.base64Encode(fileContent));
    	}
*/
    }
    
    @AuraEnabled
    public static Id saveDocument(Id parentId, String fileName, String path) {

	    System.debug('HEAP: ' + Limits.getHeapSize());
		return GlUt_ContentDocument.saveLinkedDocument(parentId, fileName, path, fileContent);
    }


/*			
			// create a new content document and link it to the parent
			String title = fileName;
			document = new ContentVersion(
											Title = title, 
	        								VersionData = EncodingUtil.base64Decode(base64Data),
											PathOnClient = fileName 
											);
			insert document;
			
			document = [select Id, ContentDocumentId from ContentVersion where Id = :document.Id];
			ContentDocumentLink link = new ContentDocumentLink(
																ContentDocumentId = document.ContentDocumentId, 
																LinkedEntityId = parentId, 
																ShareType = 'V' 
																);
			insert link;
		
		} else {
	     	
	     	// add the chunk to the body
	     	System.debug('HEAP: ' + Limits.getHeapSize());
	     	document.VersionData = document.VersionData != null
	        		? EncodingUtil.base64Decode(base64Data + EncodingUtil.base64Encode(document.VersionData))
					: EncodingUtil.base64Decode(base64Data);
					
	     	System.debug('HEAP: ' + Limits.getHeapSize());
	        upsert document;
	     	System.debug('HEAP: ' + Limits.getHeapSize());
		}
        return document.Id;
    }
    
    private static ContentVersion getAttachment(String fileId, Id linkedId, String title, String contentType) {

        for (ContentVersion document : [select Id, 
			        							VersionData 
							            from ContentVersion
							            where Id != null
							            	and Id = :fileId]) {
			return document;
		}
		return null;
    }
*/
}
/******************************************************************************
@author    		Accenture: Patrick Dixon
@date      		20 Sep 2017
@description 	Class for manipulating Content Documents
*******************************************************************************/
public with sharing class GlUt_ContentDocument {
    
	public static final String CLASS_NAME = 'GlUt_ContentDocument';
	public static final String DEBUG = '[' + CLASS_NAME + '] ';

	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		20 Sep 2017
	@param			Id - linked record Id
	@param			String - document title
	@param			String - document path
	@param			String - share type (optional - defaults to View)
	@param			Blob - file content
	@return			Id - document Id
	@description 	Saves a file as a content document, links it to a record, 
					and optionally puts it in a specified folder
	*******************************************************************************/
	public static Id saveLinkedDocument(Id linkedId, String title, String path, Blob file) {
		return saveLinkedDocument(linkedId, null, title, path, 'V', file);
	}
	public static Id saveLinkedDocument(Id linkedId, String folderFullPath, String title, String path, Blob file) {
		return saveLinkedDocument(linkedId, folderFullPath, title, path, 'V', file);
	}
	public static Id saveLinkedDocument(Id linkedId, String folderFullPath, String title, String path, String shareType, Blob file) {

		// save the file as a content version
		ContentVersion document = new ContentVersion(
													Title = title, 
													VersionData = file, 
													PathOnClient = path 
													);
		insert document;
		
		// inserting a content version creates a content document ...
		document = [select Id, ContentDocumentId from ContentVersion where Id = :document.Id];
		
		// ... which is then used to create the link to the salesforce record
		ContentDocumentLink recordLink = new ContentDocumentLink(
																ContentDocumentId = document.ContentDocumentId, 
																LinkedEntityId = linkedId, 
																ShareType = shareType 
																);
		insert recordLink;
		
		// move the document to the specified folder
		if (!String.isBlank(folderFullPath)) {

			folderFullPath = 'Billing' + '/Bill Data XMLs';		// TO-DO - sort out a better default
			moveToFolder(document.ContentDocumentId, folderFullPath);
		}

		return document.ContentDocumentId;
	}
	
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		29 Sep 2017
	@param			Id - document Id
	@param			String - folder name
	@description 	Moves a content document to the specified folder
					If the folder isn't found, it will do nothing
	*******************************************************************************/
	public static void moveToFolder(Id documentId, String folderFullPath) {
		
		// find the folder
		Id folderId = getFolderId(folderFullPath);
		
		// and create a link record between the folder and document
		ContentWorkspaceDoc folderLink = new ContentWorkspaceDoc(
																ContentWorkspaceId = folderId,
																ContentDocumentId = documentId
																);
		insert folderLink;
	}
	
	/******************************************************************************
	@author    		Accenture: Patrick Dixon
	@date      		03 Oct 2017
	@param			String - the full folder path
	@param			Id - folder Id
	@description 	Gets the Id of a content workspace from the full folder path
					Returns null if the folder isn't found
	*******************************************************************************/
	// get the folder path
	public static Id getFolderId(String folderFullPath) {

		Id folderId;
		
		folderFullPath = folderFullPath.replace('\\', '/');
		List<String> foldersInPath = folderFullPath.split('/');
		String rootFolderName;
		
		System.debug(DEBUG + 'foldersInPath: ' + foldersInPath);
	
		// build a map of workspace/folder Ids to names
		Map<Id, ContentFolder> folderNameMap = new Map<Id, ContentFolder>();
		for (ContentWorkspace contentWorkspace : [select Id, 
												Name 
										from ContentWorkspace 
										where Name = :foldersInPath[0]]) {

			// salesforce uses the Id as the workspace name
			rootFolderName = contentWorkspace.Id;
		}
		
		for (ContentFolder contentFolder : [select Id, 
												Name, 
												ParentContentFolderId 											 
										from ContentFolder 
										where Name in :foldersInPath
											or Name = :rootFolderName]) {

			if (contentFolder.Name == rootFolderName) {
				
				// use the real folder name for the workspace folder (salesforce uses the Id)
				contentFolder.Name = foldersInPath[0];
			}
			folderNameMap.put(contentFolder.Id, contentFolder);
		}
		System.debug(DEBUG + 'folderNameMap: ' + folderNameMap);
		
		for (ContentFolder folder : folderNameMap.values()) {
			System.debug(DEBUG + 'folder: ' + folder);
			
			// look for a folder name match with the destination folder
			Integer i = foldersInPath.size() - 1;
			System.debug(DEBUG + 'foldersInPath[i]: ' + foldersInPath[i]);

			if (folder.Name == foldersInPath[i]) {
				ContentFolder inPathFolder = folder;		// initialise in path folder
				folderId = folder.Id;
				System.debug(DEBUG + 'folder: ' + folder);

				// check the path is OK
				while (i > 0) {
					System.debug(DEBUG + 'i: ' + i);
								
					// find the parent
					if (!folderNameMap.keySet().contains(inPathFolder.ParentContentFolderId)) {
						
						// parent not found - bad exit
						System.debug(DEBUG + 'Parent not found');
						folderId = null;
						break;

					// check the parent name
					} else {
						inPathFolder = folderNameMap.get(inPathFolder.ParentContentFolderId);
						System.debug(DEBUG + 'inPathFolder ' + inPathFolder);
						if (foldersInPath[--i] != inPathFolder.Name) {
							System.debug(DEBUG + 'foldersInPath[--i] ' + foldersInPath[i]);
							System.debug(DEBUG + 'folder.Name ' + inPathFolder.Name);
							
							// parent name doesn't match - bad exit
							System.debug(DEBUG + 'Parent name doesn\'t match');
							folderId = null;
							break;
						}
					}
				}
				
				// path all checks out - good exit
				break;
			}
		}
		System.debug(DEBUG + 'folderId ' + folderId);
		return folderId;


			

		// build the folder relationships
		// root dir name: 07H0Y0000009RfOUAU

//	select Id, ParentContentFolderId, ChildRecordId from ContentFolderMember where ParentContentFolder.Name = '0580Y0000001ZuYQAU'

	}



	/*
	ContentWorkspace --< ContentWorkspaceDoc >-- ContentDocument
	
	
	Select Name, Id, Description From ContentWorkspace
	
	PDF Bill Templates: 0580Y0000001ZuYQAU
	
	Select Id, ContentWorkspaceId, ContentDocumentId, ContentDocument.Title From ContentWorkspaceDoc where ContentWorkspace.Name = 'PDF Bill Templates'
	
	*/
}
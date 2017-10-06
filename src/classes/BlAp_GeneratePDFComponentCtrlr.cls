/******************************************************************************
@author         Accenture: Patrick Dixon
@date           11 Sep 2017
@description    Component controller for generate PDF lightning component
*******************************************************************************/
public with sharing class BlAp_GeneratePDFComponentCtrlr {

	public static final String CLASS_NAME = 'BlAp_GeneratePDFComponentCtrlr';
	public static final String DEBUG = '[' + CLASS_NAME + '] ';
	
    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           11 Sep 2017
    @param          Id - bill Id
    @return         Bill__c - bill record
    @description    Method called to return the bill record (with attachments)
    *******************************************************************************/
    public static Bill__c getBill(Id billId) {
        
        for (Bill__c bill : [select Id, 
                                    (select Id, 
                                            LinkedEntityId, 
                                            ContentDocumentId, 
                                            Title, 
                                            FileType, 
                                            ContentSize, 
                                            FileExtension 
                                    from AttachedContentDocuments where FileType = 'PDF'
                                    )
                            from Bill__c 
                            where id= :billId]) {
            system.debug(DEBUG + 'testbillinfor1'+ bill.id);
            system.debug(DEBUG + 'testbillinfor' + bill.AttachedContentDocuments);
            return bill;
        }
        return null;
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           11 Sep 2017
    @param          Id - bill Id
    @return         Id - attachment Id
    @description    Method called to return the attachment Id
    *******************************************************************************/
    @AuraEnabled
    public static Id getAttachmentId(Id billId) {
        
        // get the bill
        Bill__c bill = getBill(billId);
        system.debug(DEBUG + 'testvivekbillobj1' + bill.id);
        system.debug(DEBUG + 'testvivekbillobj' + bill.AttachedContentDocuments);
        if (!bill.AttachedContentDocuments.isEmpty()) {
            for (AttachedContentDocument attachment : bill.AttachedContentDocuments) {
                return attachment.ContentDocumentId;
                break;
            }
        }
        return null;
    }

    /******************************************************************************
    @author         Accenture: Patrick Dixon
    @date           07 Sep 2017
    @param          Id - bill Id
    @return         Id - PDF bill attachment Id
    @description    Method called to generate a bill PDF
    *******************************************************************************/
    @AuraEnabled
    public static String getGeneratedPDF(Id billId) {
        
        String attachmentId;
//      try {
            
            // generate the PDF and save as an attachment on the bill
            attachmentId = BlIn_PDFExecuteGeneration.executePDF(billId);

//      } catch (exception e) {
//          throw new AuraHandledException(e.getMessage());
//      }
        return attachmentId;
    }
}
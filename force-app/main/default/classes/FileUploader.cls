public with sharing class FileUploader {
    public static void uploadFile(
        Blob fileContent,
        String fileExtension,
        String uploadId,
        Id linkedEntityId
    ) {
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = Constants.INVOICE_FILE_NAME_PREFIX + uploadId;
        contentVersion.PathOnClient = Constants.INVOICE_FILE_NAME_PREFIX + uploadId + fileExtension;
        contentVersion.VersionData = fileContent;
        insert contentVersion;
        
        Id contentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id = :contentVersion.Id 
            LIMIT 1
        ].ContentDocumentId;

        ContentDocumentLink link = new ContentDocumentLink();
        link.ContentDocumentId = contentDocumentId;
        link.LinkedEntityId = linkedEntityId;
        link.ShareType = Constants.SHARE_TYPE_VIEW;
        link.Visibility = Constants.VISIBILITY_ALL_USERS;
        insert link;
    }
}
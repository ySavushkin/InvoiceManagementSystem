public class InvoicePdfQueueable implements Queueable, Database.AllowsCallouts { 
    private Id recordId;
    private Id invoiceId;

    public InvoicePdfQueueable(Id recordId, Id invoiceId) {
        this.recordId = recordId;
        this.invoiceId = invoiceId;
    }

    public void execute(QueueableContext context) {
        PageReference pdfPage = Page.Invoice_PDF;
        pdfPage.getParameters().put('id', invoiceId);
        Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pdfPage.getContent();

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = Constants.INVOICE_FILE_NAME_PREFIX + invoiceId;
        contentVersion.PathOnClient = Constants.INVOICE_FILE_NAME_PREFIX + invoiceId + Constants.FILE_EXTENSION_PDF;
        contentVersion.VersionData = pdfBlob;
        insert contentVersion;

        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1].ContentDocumentId;

        ContentDocumentLink link = new ContentDocumentLink();
        link.ContentDocumentId = contentDocumentId;
        link.LinkedEntityId = recordId;
        link.ShareType = Constants.SHARE_TYPE_VIEW;
        link.Visibility = Constants.VISIBILITY_ALL_USERS;
        insert link;
    }
}
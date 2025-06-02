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

        FileUploader.uploadFile(pdfBlob, Constants.FILE_EXTENSION_PDF, invoiceId, recordId);
    }
}
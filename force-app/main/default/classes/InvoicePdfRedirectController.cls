public class InvoicePdfRedirectController {
    public Id invoiceId { get; set; }

    public InvoicePdfRedirectController() {
        invoiceId = ApexPages.currentPage().getParameters().get('id');
    }

    public PageReference redirectToPdf() {
        if (invoiceId == null) {
            System.debug('INVOICE ID = NULL');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invoice ID is missing.'));
            return null;
        }

        try {
            InvoicePdfService.sendPdfToAwsS3(invoiceId);
        } catch (Exception ex) {
            System.debug('AWS S3 ERROR');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;
        }

        PageReference pdf = Page.Invoice_PDF;
        pdf.getParameters().put('id', invoiceId);
        pdf.setRedirect(true);
        return pdf;
    }
}
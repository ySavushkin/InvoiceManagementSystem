public class InvoicePdfRedirectController {
    public Id invoiceId { get; set; }

    public InvoicePdfRedirectController() {
        invoiceId = ApexPages.currentPage().getParameters().get('id');
    }

    public PageReference redirectToPdf() {
        if (invoiceId != null) {
            try {
                InvoicePdfService.sendPdfToAwsS3(invoiceId);
            } catch (Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
                return null;
            }
        }

        PageReference pdf = Page.Invoice_PDF;
        pdf.getParameters().put('id', invoiceId);
        pdf.setRedirect(true);
        return pdf;
    }
}
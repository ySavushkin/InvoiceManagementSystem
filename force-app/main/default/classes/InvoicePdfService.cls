public class InvoicePdfService {
	public class IntegrationException extends Exception {}

	public static void sendPdfToAwsS3(Id invoiceId) {
        String fileNameToCreate = Constants.INVOICE_FILE_NAME_PREFIX + invoiceId + Constants.FILE_EXTENSION_PDF;

        PageReference pdfPage = Page.Invoice_PDF;
        pdfPage.getParameters().put('id', invoiceId);

        Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('UNIT.TEST') : pdfPage.getContent();

		Http http = new Http();
		HttpResponse res = HttpUtils.request(
			Constants.S3_ENDPOINT + fileNameToCreate,
			'PUT',
			pdfBlob,
			new Map<String, String>{
    			'Content-Type' => Constants.CONTENT_TYPE_PDF
			}
		);
        
        if (res.getStatusCode() != 200 && res.getStatusCode() != 201) {
			throw new IntegrationException(Constants.S3_ERROR_MESSAGE);
        } else {
			Invoice__c invoice = [
				SELECT Id
				, Status__c 
				FROM Invoice__c 
				WHERE Id = :invoiceId 
				LIMIT 1
			];

			invoice.Status__c = Constants.STATUS_SENT;
			update invoice;
        }
    }
}
public class InvoicePdfService {
	public static void sendPdfToAwsS3(Id invoiceId) {
        String fileNameToCreate = 'Invoice_'+ invoiceId +'.pdf';

        PageReference pdfPage = Page.Invoice_PDF;
        pdfPage.getParameters().put('id', invoiceId);

        Blob pdfBlob = pdfPage.getContent();
        
		HttpRequest request = new HttpRequest();
		request.setMethod('PUT');
		request.setBodyAsBlob(pdfBlob);
        request.setHeader('Content-Type', 'application/pdf');
		request.setEndpoint('callout:AWS_S3/' + fileNameToCreate);

		Http http = new Http();
		HttpResponse res = http.send(request);
        
        if (res.getStatusCode() != 200 && res.getStatusCode() != 201) {
            System.debug('Failed to upload: ' + res.getStatus() + ' - ' + res.getBody());
        } else {
            System.debug('Upload successful');
            
            ContentVersion cv = new ContentVersion();
        	cv.Title = 'Invoice_' + invoiceId;
        	cv.PathOnClient = 'Invoice_'+ invoiceId +'.pdf';
        	cv.VersionData = pdfBlob;
        	insert cv;

        	Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;

        	ContentDocumentLink link = new ContentDocumentLink();
        	link.ContentDocumentId = contentDocumentId;
        	link.LinkedEntityId = [SELECT Account__c FROM Invoice__c WHERE Id = :invoiceId].Account__c;
        	link.ShareType = 'V';
        	link.Visibility = 'AllUsers';
        	insert link;
        }
    }
}
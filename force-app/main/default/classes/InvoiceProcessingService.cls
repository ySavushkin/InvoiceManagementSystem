public class InvoiceProcessingService {
    public class InvoiceProcessingServiceException extends Exception {}

    public static void process(String jsonRequest) {
        if (String.isBlank(jsonRequest)) {
            throw new InvoiceProcessingServiceException(Constants.EMPTY_JSON_ERROR);
        }
        
        InvoiceRequestModel.InvoiceUploadRequest invoiceRequest = (InvoiceRequestModel.InvoiceUploadRequest) InvoiceRequestModel.parseUploadRequest(jsonRequest, InvoiceRequestModel.InvoiceUploadRequest.class);

        if(isUploadIdExists(invoiceRequest.uploadId)) {
            throw new InvoiceProcessingServiceException(Constants.UPLOAD_ID_EXISTS_ERROR);
        }

        Invoice_Inbound_Upload__c invoiceInboundUpload = InvoiceIntegrationMappingService.mapToInvoiceUploadRequest(invoiceRequest);
        insert invoiceInboundUpload;
        
        FileUploader.uploadFile(Blob.valueOf(jsonRequest), Constants.FILE_EXTENSION_JSON, invoiceRequest.uploadId, invoiceInboundUpload.Id);

        if (invoiceRequest.invoices == null || invoiceRequest.invoices.isEmpty()) {
            invoiceInboundUpload.Status__c = Constants.STATUS_FAILED;
            invoiceInboundUpload.Error_Message__c = Constants.NO_INVOICES_ERROR;

            update invoiceInboundUpload;
            throw new InvoiceProcessingServiceException(Constants.NO_INVOICES_ERROR);
        }

        buildInvoices(invoiceRequest);

        invoiceInboundUpload.Status__c = Constants.STATUS_COMPLETED;
        update invoiceInboundUpload;
    }

    private static void buildInvoices(InvoiceRequestModel.InvoiceUploadRequest invoiceRequest) {
        List<Invoice__c> invoicesToInsertList = new List<Invoice__c>();
        for (InvoiceRequestModel.InvoiceModel invoiceModel : invoiceRequest.invoices) {
            invoicesToInsertList.add(InvoiceIntegrationMappingService.mapToInvoice(invoiceModel));
        }

        insert invoicesToInsertList;

        List<Invoice_Line_Item__c> lineItemsToInsertList = new List<Invoice_Line_Item__c>();

        for (Integer i = 0; i < invoiceRequest.invoices.size(); i++) {
            InvoiceRequestModel.InvoiceModel invoiceModel = invoiceRequest.invoices[i];
            Id invoiceId = invoicesToInsertList[i].Id;

            for (InvoiceRequestModel.InvoiceLineItemModel invoiceLineItemModel : invoiceModel.invoiceLineItems) {
                Invoice_Line_Item__c invoiceLineItem = InvoiceIntegrationMappingService.mapToInvoiceLineItem(invoiceLineItemModel);
                invoiceLineItem.Invoice__c = invoiceId;
                lineItemsToInsertList.add(invoiceLineItem);
            }
        }

        insert lineItemsToInsertList;
    }

    private static Boolean isUploadIdExists(String uploadId) {
        if (String.isBlank(uploadId)) return false;

        return [
            SELECT Id
            FROM Invoice_Inbound_Upload__c
            WHERE Upload_Id__c = :uploadId
            LIMIT 1
        ].size() == 1;
    }
}

public class InvoiceProcessingService {
    public class InvoiceProcessingServiceException extends Exception {}

    public static void process(String jsonRequest) {
        if (String.isBlank(jsonRequest)) {
            throw new InvoiceProcessingServiceException('Empty request body');
        }

        InvoiceRequestModel invoiceRequest;

        try {
            invoiceRequest = (InvoiceRequestModel) JSON.deserialize(jsonRequest, InvoiceRequestModel.class);
        } catch (Exception ex) {
            throw new InvoiceProcessingServiceException('Failed to parse JSON');
        }

        Invoice_Inbound_Upload__c invoiceInboundUpload = new Invoice_Inbound_Upload__c(
            Sent_By__c = UserInfo.getUserId(),
            Upload_Id__c = invoiceRequest.uploadId,
            Status__c = 'Received'
        );

        insert invoiceInboundUpload;

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = Constants.INVOICE_FILE_NAME_PREFIX + invoiceRequest.uploadId;
        contentVersion.PathOnClient = Constants.INVOICE_FILE_NAME_PREFIX + invoiceRequest.uploadId + '.json';
        contentVersion.VersionData = Blob.valueOf(jsonRequest);
        insert contentVersion;

        Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1].ContentDocumentId;

        ContentDocumentLink link = new ContentDocumentLink();
        link.ContentDocumentId = contentDocumentId;
        link.LinkedEntityId = invoiceInboundUpload.Id;
        link.ShareType = Constants.SHARE_TYPE_VIEW;
        link.Visibility = Constants.VISIBILITY_ALL_USERS;
        insert link;

        if (invoiceRequest.invoices == null || invoiceRequest.invoices.isEmpty()) {
            invoiceInboundUpload.Status__c = 'Failed';
            invoiceInboundUpload.Error_Message__c = 'No invoices provided';

            update invoiceInboundUpload;
            throw new InvoiceProcessingServiceException('No invoices provided');
        }

        List<Invoice__c> invoicesToInsert = new List<Invoice__c>();
        List<Invoice_Line_Item__c> invoiceItemsToInsert = new List<Invoice_Line_Item__c>();

        Map<Integer, List<InvoiceRequestModel.InvoiceLineItemModel>> indexToInvoiceItemsMap = new Map<Integer, List<InvoiceRequestModel.InvoiceLineItemModel>>();

        Integer index = 0;
        for (InvoiceRequestModel.InvoiceModel invoice_i : invoiceRequest.invoices) {
            invoicesToInsert.add(new Invoice__c(
                Name = invoice_i.name,
                Account__c = invoice_i.account,
                Due_Date__c = invoice_i.dueDate,
                Invoice_Date__c = invoice_i.invoiceDate
            ));
            indexToInvoiceItemsMap.put(index, invoice_i.invoiceLineItems);
            index++;
        }

        insert invoicesToInsert;

        for (Integer i = 0; i < invoicesToInsert.size(); i++) {
            Id invoiceId = invoicesToInsert[i].Id;
            List<InvoiceRequestModel.InvoiceLineItemModel> dedicatedInvoiceItems = indexToInvoiceItemsMap.get(i);
            for (InvoiceRequestModel.InvoiceLineItemModel item : dedicatedInvoiceItems) {
                invoiceItemsToInsert.add(new Invoice_Line_Item__c(
                    Invoice__c = invoiceId,
                    Product_Name__c = item.productName,
                    Quantity__c = item.quantity,
                    Unit_Price__c = item.unitPrice
                ));
            }
        }

        insert invoiceItemsToInsert;

        invoiceInboundUpload.Status__c = 'Completed';
        update invoiceInboundUpload;
    }
}

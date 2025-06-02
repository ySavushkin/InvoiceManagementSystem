public with sharing class InvoiceIntegrationMappingUtils {
    public static List<Invoice__c> buildInvoices(InvoiceRequestModel.InvoiceUploadRequest invoiceRequest) {
        List<Invoice__c> invoices = new List<Invoice__c>();
        for (InvoiceRequestModel.InvoiceModel invoice_i : invoiceRequest.invoices) {
            invoices.add(new Invoice__c(
                Name = invoice_i.name,
                Account__c = invoice_i.account,
                Due_Date__c = invoice_i.dueDate,
                Invoice_Date__c = invoice_i.invoiceDate
            ));
        }
        return invoices;
    }

    public static List<Invoice_Line_Item__c> buildInvoiceItems(InvoiceRequestModel.InvoiceUploadRequest invoiceRequest, List<Invoice__c> insertedInvoices) {
        List<Invoice_Line_Item__c> invoiceItems = new List<Invoice_Line_Item__c>();

        for (Integer i = 0; i < insertedInvoices.size(); i++) {
            Id invoiceId = insertedInvoices[i].Id;
            List<InvoiceRequestModel.InvoiceLineItemModel> lineItems = invoiceRequest.invoices[i].invoiceLineItems;

            if (lineItems != null) {
                for (InvoiceRequestModel.InvoiceLineItemModel item : lineItems) {
                    invoiceItems.add(new Invoice_Line_Item__c(
                        Invoice__c = invoiceId,
                        Product_Name__c = item.productName,
                        Quantity__c = item.quantity,
                        Unit_Price__c = item.unitPrice
                    ));
                }
            }
        }
        return invoiceItems;
    }

    public static Invoice_Inbound_Upload__c buildInvoiceInboundUpload(InvoiceRequestModel.InvoiceUploadRequest invoiceRequest) {
        Invoice_Inbound_Upload__c invoiceToReturn = new Invoice_Inbound_Upload__c(
            Sent_By__c = UserInfo.getUserId(),
            Upload_Id__c = invoiceRequest.uploadId,
            Status__c = 'Received'
        );

        return invoiceToReturn;
    }
}
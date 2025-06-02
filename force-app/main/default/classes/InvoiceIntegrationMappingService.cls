public with sharing class InvoiceIntegrationMappingService {
    public static Invoice_Inbound_Upload__c mapToInvoiceUploadRequest(InvoiceRequestModel.InvoiceUploadRequest invoiceRequest) {
        Invoice_Inbound_Upload__c invoiceToReturn = new Invoice_Inbound_Upload__c(
            Sent_By__c = UserInfo.getUserId(),
            Upload_Id__c = invoiceRequest.uploadId,
            Status__c = 'Received'
        );

        return invoiceToReturn;
    }

    public static Invoice__c mapToInvoice(InvoiceRequestModel.InvoiceModel invoiceModel) {
        Invoice__c invoice = new Invoice__c(
            Name = invoiceModel.name,
            Account__c = invoiceModel.account,
            Due_Date__c = invoiceModel.dueDate,
            Invoice_Date__c = invoiceModel.invoiceDate
        );

        return invoice;
    }

    public static Invoice_Line_Item__c mapToInvoiceLineItem(InvoiceRequestModel.InvoiceLineItemModel invoiceLineItemModel) {
        Invoice_Line_Item__c invoiceLineItem = new Invoice_Line_Item__c(
            Product_Name__c = invoiceLineItemModel.productName,
            Quantity__c = invoiceLineItemModel.quantity,
            Unit_Price__c = invoiceLineItemModel.unitPrice
        );

        return invoiceLineItem;
    }
}
 @isTest
private class InvoiceIntegrationMappingServiceTest {
    @testSetup
    static void makeData() {
        TestDataFactory.createAccount(true);
    }

    @isTest
    static void testMapToInvoiceInboundUpload() {
        InvoiceRequestModel.InvoiceUploadRequest request = new InvoiceRequestModel.InvoiceUploadRequest();
        request.uploadId = 'testUpload';

        Invoice_Inbound_Upload__c result = InvoiceIntegrationMappingService.mapToInvoiceUploadRequest(request);

        Assert.areEqual('testUpload', result.Upload_Id__c);
        Assert.areEqual('Received', result.Status__c);
    }

    @isTest
    static void testMapToInvoice() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        InvoiceRequestModel.InvoiceModel invoiceModel = new InvoiceRequestModel.InvoiceModel();

        invoiceModel.name = 'testInvoice';
        invoiceModel.account = testAccount.Id;
        invoiceModel.dueDate = Date.today();
        invoiceModel.invoiceDate = Date.today();


        Invoice__c invoice = InvoiceIntegrationMappingService.mapToInvoice(invoiceModel);

        Assert.areEqual('testInvoice', invoice.Name);
        Assert.areEqual(testAccount.Id, invoice.Account__c);
        Assert.areEqual(Date.today(), invoice.Invoice_Date__c);
    }
}
@isTest
public with sharing class InvoiceRestServiceTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.createAccount(true);
    }
    @isTest
    static void testDoPost() {
        testInvoiceRestService((String) JSON.serialize(TestDataFactory.createInvoice()), 200);
    }

    @isTest
    static void testInvalidAccountId() {
        InvoiceRequestModel.InvoiceUploadRequest request = new InvoiceRequestModel.InvoiceUploadRequest();
        request.uploadId = 'testID1';

        InvoiceRequestModel.InvoiceModel invoice = new InvoiceRequestModel.InvoiceModel();
        invoice.name = 'testInvoice';
        invoice.account = 'invalidId';
        invoice.dueDate = Date.newInstance(2025, 6, 22);
        invoice.invoiceDate = Date.newInstance(2025, 6, 22);

        request.invoices = new List<InvoiceRequestModel.InvoiceModel>{invoice};

        testInvoiceRestService((String) JSON.serialize(request), 500);
    }

    @isTest
    static void testDoPostBlankJson() {
        testInvoiceRestService('', 400);
    }

    @isTest
    static void testDoPostInvalidJson() {
        testInvoiceRestService('invalidJson', 400);
    }

    private static void testInvoiceRestService(String testJson, Integer expected) {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestUri = '/services/apexrest/Invoice';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(testJson);

        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        InvoiceRestService.doPost();
        Test.stopTest();

        Assert.areEqual(expected, InvoiceRestService.lastStatusCode);
    }
}
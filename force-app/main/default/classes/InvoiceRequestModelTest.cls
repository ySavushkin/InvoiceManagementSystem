@isTest
private class InvoiceRequestModelTest {
    @TestSetup
    static void makeData(){
        TestDataFactory.createAccount(true);
    }

    @isTest
    static void testParseUploadRequest_ValidJson() {
        Test.startTest();
        InvoiceRequestModel.InvoiceUploadRequest result = (InvoiceRequestModel.InvoiceUploadRequest) InvoiceRequestModel.parseUploadRequest((String) JSON.serialize(TestDataFactory.createInvoice()), InvoiceRequestModel.InvoiceUploadRequest.class);
        Test.stopTest();

        Assert.areNotEqual(null, result, 'Deserialized result should not be null');
        Assert.areEqual('testID1', result.uploadId, 'Invoice upload Id should be testID1');
        Assert.areEqual(1, result.invoices.size(), 'One invoice should be parsed');
        Assert.areEqual('testProduct', result.invoices[0].invoiceLineItems[0].productName);
    }

    @isTest
    static void testParseUploadRequest_InvalidJson() {
        String invalidJson = '{"uploadId": "invalidTest", "invoices": [}';

        Test.startTest();
        try {
            InvoiceRequestModel.parseUploadRequest(invalidJson, InvoiceRequestModel.InvoiceUploadRequest.class);
        } catch (Exception ex) {
            Assert.isTrue(ex.getMessage().contains(Constants.JSON_PARSE_ERROR), 'Should contain JSON error message');
        }
        Test.stopTest();
    }
}
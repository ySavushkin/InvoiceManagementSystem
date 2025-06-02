@isTest
public with sharing class InvoiceProcessingServiceTest {
    @testSetup
    static void setup() {
        TestDataFactory.createAccount(true);
    }

    @isTest
    static void testProcess_validJson() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        //where to store test json
        String validJson = '{"uploadId": "testID1","invoices": [{"name": "JSON Invoice NEW","account": "' + testAccount.Id + '","dueDate": "2025-06-22","invoiceDate": "2025-06-22","invoiceLineItems": [{"productName": "JSON Test product NEW","quantity": 5,"unitPrice": 222},{"productName": "JSON Test product NEW 2","quantity": 1,"unitPrice": 25.99}]}]}';

        Test.startTest();
        InvoiceProcessingService.process(validJson);
        Test.stopTest();

        List<Invoice_Inbound_Upload__c> invoiceInboundUploadList = [SELECT Id, Status__c FROM Invoice_Inbound_Upload__c WHERE Upload_Id__c = 'testID1'];
        Assert.areEqual(1, invoiceInboundUploadList.size(), 'Invoice inbound upload should have been created');
        Assert.areEqual(Constants.STATUS_COMPLETED, invoiceInboundUploadList[0].Status__c, 'Invoice inbound upload status should be completed');
    }

    @isTest
    static void testProcess_emptyJson() {
        Test.startTest();
        try {
            InvoiceProcessingService.process('');
        } catch (Exception e) {
            Assert.areEqual(Constants.EMPTY_JSON_ERROR, e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    static void testProcess_noInvoices() {
        String jsonWithoutInvoices = '{"uploadId": "testID1","invoices": []}';

        Test.startTest();
        try {
            InvoiceProcessingService.process(jsonWithoutInvoices);
        } catch (InvoiceProcessingService.InvoiceProcessingServiceException e) {
            Assert.areEqual(Constants.NO_INVOICES_ERROR, e.getMessage());
        }
        Test.stopTest();

        List<Invoice_Inbound_Upload__c> invoiceInboundUploadList = [SELECT Id, Status__c, Error_Message__c FROM Invoice_Inbound_Upload__c WHERE Upload_Id__c = 'testID1'];
        Assert.areEqual(1, invoiceInboundUploadList.size(), 'Upload record should have been inserted');
        Assert.areEqual(Constants.STATUS_FAILED, invoiceInboundUploadList[0].Status__c, 'Invoice inbound upload status should be failed');
        Assert.areEqual(Constants.NO_INVOICES_ERROR, invoiceInboundUploadList[0].Error_Message__c, 'Invoice inbound upload error message should have been created');
    }
}
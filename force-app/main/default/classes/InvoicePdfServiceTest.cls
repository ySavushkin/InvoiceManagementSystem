@isTest
public with sharing class InvoicePdfServiceTest {
    @testSetup
    static void setup(){
        TestDataFactory.createInvoiceLineItem(true);
    }

    @isTest
    static void testValidRequestToAmazonS3() {
        Invoice__c testInvoice = [SELECT Status__c FROM Invoice__c LIMIT 1];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InvoicePdfServiceTestMock(200));

        InvoicePdfService.sendPdfToAwsS3(testInvoice.Id);

        Test.stopTest();
        
        Invoice__c updated = [SELECT Status__c FROM Invoice__c WHERE Id = :testInvoice.Id];
        Assert.areEqual(Constants.STATUS_SENT, updated.Status__c, 'Status should be changed to Sent');
    }

    @isTest
    static void testInvalidRequestToAmazonS3() {
        Invoice__c testInvoice = [SELECT Status__c FROM Invoice__c LIMIT 1];

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new InvoicePdfServiceTestMock(500));

        try{
            InvoicePdfService.sendPdfToAwsS3(testInvoice.Id);
        } catch(Exception ex){
            Assert.areEqual(Constants.S3_ERROR_MESSAGE, ex.getMessage(), 'Error message should be thrown');
        }

        Test.stopTest();
    }
}
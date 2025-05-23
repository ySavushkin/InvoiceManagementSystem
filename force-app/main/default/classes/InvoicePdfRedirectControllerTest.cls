@isTest
public with sharing class InvoicePdfRedirectControllerTest {
    @testSetup
    static void setup() {
        TestDataFactory.createInvoiceLineItem(true);
    }

    @isTest
    static void testValidRedirection() {
        Invoice__c testInvoice = [SELECT Id FROM Invoice__c LIMIT 1];

        Test.setMock(HttpCalloutMock.class, new InvoicePdfServiceTestMock(200));

        Test.setCurrentPage(Page.InvoiceRedirect);
        ApexPages.currentPage().getParameters().put('id', testInvoice.Id);

        Test.startTest();

        InvoicePdfRedirectController controller = new InvoicePdfRedirectController();
        PageReference result = controller.redirectToPdf();

        Test.stopTest();

        Assert.areNotEqual(null, result, 'PageReference shouldn`t be null');
    }

    @isTest
    static void testInvalidRedirection() {
        Test.setMock(HttpCalloutMock.class, new InvoicePdfServiceTestMock(500));

        Test.setCurrentPage(Page.InvoiceRedirect);
        ApexPages.currentPage().getParameters().put('id', null);

        Test.startTest();

        InvoicePdfRedirectController controller = new InvoicePdfRedirectController();
        PageReference result = controller.redirectToPdf();

        Test.stopTest();

        Assert.areEqual(null, result, 'PageReference should be null');
    }

    @isTest
    static void testInvalidRedirectionAwsError() {
        Invoice__c testInvoice = [SELECT Id FROM Invoice__c LIMIT 1];

        Test.setMock(HttpCalloutMock.class, new InvoicePdfServiceTestMock(500));

        Test.setCurrentPage(Page.InvoiceRedirect);
        ApexPages.currentPage().getParameters().put('id', testInvoice.Id);

        Test.startTest();

        InvoicePdfRedirectController controller = new InvoicePdfRedirectController();
        PageReference result = controller.redirectToPdf();

        Test.stopTest();

        Assert.areEqual(null, result, 'PageReference should be null. AWS Error');
    }
}
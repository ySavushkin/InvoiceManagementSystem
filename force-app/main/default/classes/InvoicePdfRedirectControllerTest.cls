@isTest
public with sharing class InvoicePdfRedirectControllerTest {
    @testSetup
    static void setup() {
        InvoiceDataFactory.generateInvoiceTestData();
    }

    @isTest
    static void testValidRedirection() {
        Invoice__c testInvoice = [SELECT Status__c FROM Invoice__c LIMIT 1];

        Test.setMock(HttpCalloutMock.class, new InvoicePdfServiceTestMock(200));

        PageReference pageRef = Page.InvoiceRedirect;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', testInvoice.id);

        InvoicePdfRedirectController controller = new InvoicePdfRedirectController();
        PageReference result = controller.redirectToPdf();

        Assert.areEqual(Page.Invoice_PDF.getUrl(), result.getUrl());
    }
}
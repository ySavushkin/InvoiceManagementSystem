@isTest
private class InvoiceTriggerTest {
    @testSetup 
    static void setup() {
        TestDataFactory.createInvoiceLineItem(true);
    }

    @isTest 
    static void testHandleStatusChange() {
        Invoice__c testInvoice = [SELECT Status__c FROM Invoice__c LIMIT 1];
        Account testAccount = [SELECT Name FROM Account LIMIT 1];

        Test.startTest();
        testInvoice.Status__c = Constants.STATUS_SENT;
        update testInvoice;

        testInvoice.Status__c = Constants.STATUS_PAID;
        update testInvoice;
        Test.stopTest();

        List<ContentDocumentLink> invoiceAttachments = retrieveRecordAttachments(testInvoice.Id);
        List<ContentDocumentLink> accountAttachments = retrieveRecordAttachments(testAccount.Id);

        Assert.areEqual(1, invoiceAttachments.size(), 'Invoice should have one attachment');
        Assert.areEqual(1, accountAttachments.size(), 'Account should have one attachment');
    }

    static List<ContentDocumentLink> retrieveRecordAttachments(Id recordId) {
        return [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
        ];
    }
}

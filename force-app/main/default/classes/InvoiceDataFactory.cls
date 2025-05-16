public with sharing class InvoiceDataFactory {
    public static void generateInvoiceTestData() {
        Account testAccount = new Account(
            Name = 'TestAccount'
        );
        insert testAccount;

        Invoice__c testInvoice = new Invoice__c(
            Account__c = testAccount.Id,
            Status__c = 'Draft'
        );
        insert testInvoice;

        Invoice_Line_Item__c testInvoiceLineItem = new Invoice_Line_Item__c(
            Invoice__c = testInvoice.Id,
            Product_Name__c = 'TestProduct',
            Quantity__c = 2,
            Unit_Price__c = 33.4
        );
        insert testInvoiceLineItem;
    }
}
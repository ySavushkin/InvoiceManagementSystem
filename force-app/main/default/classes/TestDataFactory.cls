@isTest
public with sharing class TestDataFactory {
    public static Account createAccount(Boolean doInsert) {
		return createAccount('testAccount', doInsert);
	}
	
	public static Account createAccount(String name, Boolean doInsert) {
		Account account = new Account(Name = name);
		if(doInsert) {
			insert account;
		}
		return account;
	}

    public static Invoice__c createInvoice(Boolean doInsert) {
        Account account = createAccount(true);
        return createInvoice(account.Id, doInsert);
    }

    public static Invoice__c createInvoice(Id accountId, Boolean doInsert) {
        Invoice__c invoice = new Invoice__c(
            Status__c = 'Draft', 
            Account__c = accountId
        );
		if(doInsert) {
			insert invoice;
		}
		return invoice;
    }

    public static Invoice_Line_Item__c createInvoiceLineItem(Boolean doInsert) {
        Invoice__c invoice = createInvoice(true);
        return createInvoiceLineItem(invoice.Id, doInsert);
    }

    public static Invoice_Line_Item__c createInvoiceLineItem(Id invoiceId, Boolean doInsert) {
        Invoice_Line_Item__c invoiceLineItem = new Invoice_Line_Item__c(
            Invoice__c = invoiceId,
            Product_Name__c = 'TestProduct',
            Quantity__c = 2,
            Unit_Price__c = 33.4
        );
        if(doInsert) {
            insert invoiceLineItem;
        }
        return invoiceLineItem;
    }

    public static InvoiceRequestModel.InvoiceUploadRequest createInvoice () {
        InvoiceRequestModel.InvoiceUploadRequest request = new InvoiceRequestModel.InvoiceUploadRequest();
        request.uploadId = 'testID1';

        InvoiceRequestModel.InvoiceModel invoice = new InvoiceRequestModel.InvoiceModel();
        invoice.name = 'testInvoice';
        invoice.account = [SELECT Id FROM Account LIMIT 1].Id;
        invoice.dueDate = Date.newInstance(2025, 6, 22);
        invoice.invoiceDate = Date.newInstance(2025, 6, 22);

        InvoiceRequestModel.InvoiceLineItemModel item1 = new InvoiceRequestModel.InvoiceLineItemModel();
        item1.productName = 'testProduct';
        item1.quantity = 5;
        item1.unitPrice = 222;

        invoice.invoiceLineItems = new List<InvoiceRequestModel.InvoiceLineItemModel>{item1};
        request.invoices = new List<InvoiceRequestModel.InvoiceModel>{invoice};

        return request;
    }
}
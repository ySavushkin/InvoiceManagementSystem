public class InvoiceRequestModel {
    public List<InvoiceModel> invoices;
    public String uploadId;

    public class InvoiceModel {
        public String name;
        public String account;
        public Date dueDate;
        public Date invoiceDate;
        public List<InvoiceLineItemModel> invoiceLineItems;
    }

    public class InvoiceLineItemModel {
        public String productName;
        public Integer quantity;
        public Decimal unitPrice;
    }
}

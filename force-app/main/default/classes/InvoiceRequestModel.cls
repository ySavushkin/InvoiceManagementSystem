public class InvoiceRequestModel {
    public static IParsable parseUploadRequest(String jsonString, Type t) {
        try {
            return (IParsable) JSON.deserialize(jsonString, t);
        } catch (JSONException je) {
            throw new InvoiceModelsException(Constants.JSON_PARSE_ERROR + je.getMessage());
        }
    }
    
    public interface IParsable {}

    public class InvoiceUploadResponse {
        public Boolean isSuccess;
        public String errorMessage;
    }

    public class InvoiceUploadRequest implements IParsable{
        public List<InvoiceModel> invoices;
        public String uploadId;
    }    

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

    public class InvoiceModelsException extends Exception {}
}
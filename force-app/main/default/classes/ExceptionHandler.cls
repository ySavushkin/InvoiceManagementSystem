public class ExceptionHandler {
    public class ResponseWrapper {
        public Integer statusCode;
        public String responseBody;
    }

    public static ResponseWrapper handle(Exception e) {
        ResponseWrapper response = new ResponseWrapper();

        if (e instanceof InvoiceRequestModel.InvoiceModelsException ||
            e instanceof InvoiceProcessingService.InvoiceProcessingServiceException) {
            response.statusCode = 400;
            response.responseBody = e.getMessage();
        } else {
            response.statusCode = 500;
            response.responseBody = Constants.INTERNAL_SERVER_ERROR + e.getMessage();
        }

        return response;
    }
}
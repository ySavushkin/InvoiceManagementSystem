@RestResource(urlMapping='/Invoice')
global with sharing class InvoiceRestService {
    public static Integer lastStatusCode;

	@HttpPost 
	global static void doPost() {
        String jsonBody = RestContext.request.requestBody.toString();

		try {
            InvoiceProcessingService.process(jsonBody);
            RestContext.response.statusCode = 200;
            lastStatusCode = 200;
        } catch (Exception e) {
            ExceptionHandler.ResponseWrapper response = ExceptionHandler.handle(e);
            RestContext.response.statusCode = response.statusCode;
            lastStatusCode = response.statusCode;
            RestContext.response.responseBody = Blob.valueOf(response.responseBody);
        }
	}
}
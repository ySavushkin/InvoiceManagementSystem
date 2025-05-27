@RestResource(urlMapping='/Invoice')
global with sharing class InvoiceRestService {
	@HttpPost 
	global static void doPost() {
		String jsonBody = RestContext.request.requestBody.toString();

        try {
            InvoiceProcessingService.process(jsonBody);
        } catch (Exception e) {
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('Internal Server Error: ' + e.getMessage());
        }
	}
}
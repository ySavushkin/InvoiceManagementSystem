public with sharing class InvoicePdfServiceTestMock implements HttpCalloutMock{
    Integer statusCode;
    
    public InvoicePdfServiceTestMock(Integer statusCode) {
        this.statusCode = statusCode;
    }
    
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(statusCode);
        return response;
    }
}
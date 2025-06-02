@isTest
public class HttpUtilsTestMock implements HttpCalloutMock {
    Boolean isNullResponse;
    public HttpUtilsTestMock() {
        this.isNullResponse = false;
    }
    
    public HttpUtilsTestMock (Boolean isNullResponse) {
        this.isNullResponse = isNullResponse;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        if(!isNullResponse) {
            response.setStatusCode(200);
        }
        return response;
    }
}
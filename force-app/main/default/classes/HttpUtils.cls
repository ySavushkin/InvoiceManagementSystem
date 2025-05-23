public with sharing class HttpUtils {
    
    public static HttpResponse request(String endpoint, String requestType) {
        return request(endpoint, requestType, null, null);
    }
    public static HttpResponse request(String endpoint, String requestType, Map<String, String> headers) {
        return request(endpoint, requestType, null, headers);
    }
    public static HttpResponse request(String endpoint, String requestType, String body) {
        return request(endpoint, requestType, body, null);
    }

    public static HttpResponse request(String endpoint, String requestType, Object body, Map<String, String> headers) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod(requestType);
        req.setTimeout(120000);
        if (headers != null && !headers.isEmpty()) {
            for (String header_i : headers.keySet()) {
                req.setHeader(header_i, headers.get(header_i));
            }
        }
        if (body != null) {
            if (body instanceof String) {
                req.setBody((String) body);
            } else if (body instanceof Blob) {
                Blob blobBody = (Blob) body;
                req.setBodyAsBlob(blobBody);
            } else {
                throw new RequestUtilsException('Unsupported body type.');
            }
        }
        
        System.debug(req);
        Http http = new Http(); 
        HttpResponse res;
        res = http.send(req);
        if (res == null) {
            throw new RequestUtilsException('Something went wrong, cannot receive a response');
        }
        
        System.debug('response code:'+res.getStatusCode()+', res '+res);
        return res;
    }

    public class RequestUtilsException extends Exception{}
}
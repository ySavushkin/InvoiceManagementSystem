public with sharing class Utils {
    public static HttpRequest request(String endpoint, String requestType, Blob body, Map<String, String> headers) {
        HttpRequest request = new HttpRequest();
		request.setMethod(requestType);
		request.setBodyAsBlob(body);
        if (headers != null && !headers.isEmpty()) {
            for (String header_i : headers.keySet()) {
                request.setHeader(header_i, headers.get(header_i));
            }
        }
		request.setEndpoint(endpoint);
        return request;
    }

    public class RequestUtilsException extends Exception{}
}
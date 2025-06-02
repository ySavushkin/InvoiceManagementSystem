@isTest
private class HttpUtilsTest {
    
    @isTest
    static void requestWithBodyTest() {
        Test.setMock(HttpCalloutMock.class, new HttpUtilsTestMock());

        HttpResponse response = HttpUtils.request(
            'http://test.com/endpoint',
            'POST',
            'test body'
        );

        Assert.areEqual(200, response.getStatusCode());
    }

    @isTest
    static void requestWithHeadersTest() {
        Test.setMock(HttpCalloutMock.class, new HttpUtilsTestMock());

        Map<String, String> headers = new Map<String, String>{
            'Authorization' => 'Bearer test'
        };

        HttpResponse response = HttpUtils.request(
            'https://test.com/endpoint',
            'GET',
            headers
        );

        Assert.areEqual(200, response.getStatusCode());
    }

    @isTest
    static void requestWithBlobTest() {
        Test.setMock(HttpCalloutMock.class, new HttpUtilsTestMock());

        Blob testBlob = Blob.valueOf('test blob content');
        HttpResponse response = HttpUtils.request(
            'https://test.com/endpoint',
            'PUT',
            testBlob,
            null
        );

        Assert.areEqual(200, response.getStatusCode());
    }

    @isTest
    static void requestWithInvalidBodyTypeTest() {
        Object invalidBody = Date.newInstance(1, 2, 3);

        try {
            HttpUtils.request(
                'https://test.com/endpoint',
                'POST',
                invalidBody,
                null
            );
        } catch (HttpUtils.RequestUtilsException ex) {
            Assert.areEqual('Unsupported body type.', ex.getMessage());
        }
    }


    @isTest
    static void requestWithMinimalOverloadTest() {
        Test.setMock(HttpCalloutMock.class, new HttpUtilsTestMock());

        HttpResponse response = HttpUtils.request(
            'https://test.com/endpoint',
            'GET'
        );

        Assert.areEqual(200, response.getStatusCode());
    }
}
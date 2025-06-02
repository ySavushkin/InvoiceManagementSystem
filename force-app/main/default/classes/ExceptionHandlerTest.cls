@isTest
private class ExceptionHandlerTest {
    
    @isTest
    static void testHandleInvoiceModelsException() {
        ExceptionHandler.ResponseWrapper result;
        try {
            throw new InvoiceRequestModel.InvoiceModelsException('Test InvoiceModelsException');
        } catch (Exception e) {
            result = ExceptionHandler.handle(e);
        }

        Assert.areEqual(400, result.statusCode, 'Should return 400 for InvoiceModelsException');
        Assert.areEqual('Test InvoiceModelsException', result.responseBody);
    }

    @isTest
    static void testHandleInvoiceProcessingServiceException() {
        ExceptionHandler.ResponseWrapper result;
        try {
            throw new InvoiceProcessingService.InvoiceProcessingServiceException('Test ServiceException');
        } catch (Exception e) {
            result = ExceptionHandler.handle(e);
        }

        Assert.areEqual(400, result.statusCode, 'Should return 400 for ServiceException');
        Assert.areEqual('Test ServiceException', result.responseBody);
    }

    @isTest
    static void testHandleUnknownException() {
        ExceptionHandler.ResponseWrapper result;
        try {
            throw new NullPointerException();
        } catch (Exception e) {
            result = ExceptionHandler.handle(e);
        }

        Assert.areEqual(500, result.statusCode, 'Should return 500 for unknown exceptions');
        Assert.isTrue(result.responseBody.contains('Internal Server Error'), 'Response should include internal error message');
    }
}
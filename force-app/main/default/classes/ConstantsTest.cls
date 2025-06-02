@isTest
public with sharing class ConstantsTest {
    @isTest
    static void constantsTest() {
        Constants constantsTest = new Constants();
        
        List<String> constants = new List<String>{
            Constants.CONTENT_TYPE_PDF,
            Constants.S3_ENDPOINT,
            Constants.STATUS_SENT,
            Constants.STATUS_PAID,
            Constants.INVOICE_FILE_NAME_PREFIX,
            Constants.FILE_EXTENSION_PDF,
            Constants.SHARE_TYPE_VIEW,
            Constants.VISIBILITY_ALL_USERS,
            Constants.S3_ERROR_MESSAGE,
            Constants.NO_INVOICES_ERROR,
            Constants.JSON_PARSE_ERROR,
            Constants.STATUS_FAILED,
            Constants.STATUS_COMPLETED,
            Constants.FILE_EXTENSION_JSON,
            Constants.EMPTY_JSON_ERROR,
            Constants.INTERNAL_SERVER_ERROR,
            Constants.UPLOAD_ID_EXISTS_ERROR
        };
    }
}
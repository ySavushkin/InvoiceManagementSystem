public with sharing class Constants {
    public static final String CONTENT_TYPE_PDF = System.Label.ContentTypePdf;
    public static final String S3_ENDPOINT = System.Label.S3Endpoint;
    public static final String STATUS_SENT = System.Label.SentStatus;
    public static final String STATUS_PAID = System.Label.PaidStatus;
    public static final String INVOICE_FILE_NAME_PREFIX = System.Label.InvoiceFileNamePrefix;
    public static final String FILE_EXTENSION_PDF = System.Label.PdfFileExtension;
    public static final String SHARE_TYPE_VIEW = 'V';
    public static final String VISIBILITY_ALL_USERS = 'AllUsers';
    public static final String S3_ERROR_MESSAGE = System.Label.S3ErrorMessage;
    public static final String NO_INVOICES_ERROR = 'No invoices provided';
    public static final String JSON_PARSE_ERROR = 'JSON Parse Error: ';
    public static final String STATUS_FAILED = 'Failed';
    public static final String STATUS_COMPLETED = 'Completed';
    public static final String FILE_EXTENSION_JSON = '.json';
    public static final String EMPTY_JSON_ERROR = 'Empty request body';
    public static final String INTERNAL_SERVER_ERROR = 'Internal Server Error: ';
    public static final String UPLOAD_ID_EXISTS_ERROR = 'Upload Id already exists';

    public Constants() {}
}
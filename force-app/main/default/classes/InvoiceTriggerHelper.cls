public with sharing class InvoiceTriggerHelper {
    public static void onAfterUpdate(Map<Id, Invoice__c> newMap, Map<Id, Invoice__c> oldMap) { 
        handleStatusChange(newMap, oldMap);
    }

    private static void handleStatusChange(Map<Id, Invoice__c> newMap, Map<Id, Invoice__c> oldMap) {
        for(Invoice__c invoice_i : newMap.values()) {
            String newStatus = invoice_i.Status__c;
            if(newStatus != oldMap.get(invoice_i.Id).Status__c) {
                if(newStatus == Constants.STATUS_SENT) {
                    System.enqueueJob(new InvoicePdfQueueable(invoice_i.Id, invoice_i.Id));
                } else if(newStatus == Constants.STATUS_PAID) {
                    System.enqueueJob(new InvoicePdfQueueable(invoice_i.Account__c, invoice_i.Id));
                }
            }
        }
    }
}
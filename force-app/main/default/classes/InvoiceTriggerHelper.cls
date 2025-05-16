public with sharing class InvoiceTriggerHelper {
    public static void handleStatusChange(Map<Id, Invoice__c> newMap, Map<Id, Invoice__c> oldMap) {
        for(Id invoiceId : newMap.keySet()) {
            String newStatus = newMap.get(invoiceId).Status__c;
            if(newStatus != oldMap.get(invoiceId).Status__c) {
                if(newStatus == Constants.STATUS_SENT) {
                    System.enqueueJob(new InvoicePdfQueueable(invoiceId, invoiceId));
                } else if(newStatus == Constants.STATUS_PAID) {
                    System.enqueueJob(new InvoicePdfQueueable(newMap.get(invoiceId).Account__c, invoiceId));
                }
            }
        }
    }
}
trigger InvoiceTrigger on Invoice__c (after update) {
    InvoiceTriggerHelper.handleStatusChange(Trigger.newMap, Trigger.oldMap);
}
trigger InvoiceTrigger on Invoice__c (after update) {
    if(Trigger.isUpdate && Trigger.isAfter) { 
        InvoiceTriggerHelper.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }
}
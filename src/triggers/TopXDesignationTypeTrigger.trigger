trigger TopXDesignationTypeTrigger on Top_X_Designation__c (after insert, after update, before delete, after undelete) {
	TopXDesignationTriggerHandler.topXDesignation(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
}
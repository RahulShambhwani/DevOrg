trigger StudentTrigger on Student__c (after insert, after update, after delete, after undelete ) {
	    StudentTriggerHandler.countRecords(Trigger.new, Trigger.oldMap, Trigger.newMap, Trigger.old);
}
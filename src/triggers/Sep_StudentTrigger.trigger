trigger Sep_StudentTrigger on Sep_Student__c (after insert, after update) {
	Sep_StudentTriggerHandler.findTopperOfCollege(Trigger.new, Trigger.oldMap);
}
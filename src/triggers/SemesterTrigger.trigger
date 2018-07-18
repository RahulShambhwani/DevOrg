trigger SemesterTrigger on Semester__c (after insert, after update) {
	SemesterTriggerHandler.findTopperOfEachSem(Trigger.new, Trigger.oldMap);
}
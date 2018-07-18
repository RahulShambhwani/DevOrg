trigger TransactionTrigger on Transaction__c (after insert, after delete) {
	TransactionTriggerHandler.updateStatus(Trigger.new, Trigger.old);
}
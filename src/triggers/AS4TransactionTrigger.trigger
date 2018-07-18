trigger AS4TransactionTrigger on AS4_Transaction__c (after insert, after update, after delete) {
	AS4TransactionTriggerHandler.getHighValOfEachHolder(Trigger.new, Trigger.oldMap);
}
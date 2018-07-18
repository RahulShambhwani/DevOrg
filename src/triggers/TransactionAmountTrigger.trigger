trigger TransactionAmountTrigger on Transaction__c (after insert, after update) {
	TransactionTriggerHandler.amountShouldNotNegative(Trigger.new);
}
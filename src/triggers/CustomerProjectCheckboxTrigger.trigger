trigger CustomerProjectCheckboxTrigger on Customer_Project__c (after insert, after update, before delete) {
	CustomerProjectTriggerHandler.checkActiveOpportunity(Trigger.new, Trigger.oldMap);
}
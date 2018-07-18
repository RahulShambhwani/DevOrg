trigger Assesment3Trigger on Assessment3_Sales__c (after insert, after update) {
	Assesment3TriggerHandler.createCompanyReport(Trigger.new, Trigger.oldMap);
}
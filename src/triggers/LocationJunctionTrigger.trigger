trigger LocationJunctionTrigger on LOCATION_JUNCTION__c (before insert) {
	LocationJunctionTriggerHandler.uniqueLocationForEachOpportunity(Trigger.new, Trigger.oldMap);
}
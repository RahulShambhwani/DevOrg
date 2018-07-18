trigger ContactTrackingTrigger on Contact (before delete) {
	ContactTriggerHandler.trackContactDeletion(Trigger.oldMap);    
}
trigger AccountTrackingTrigger on Account (before delete) {
	AccountTriggerHandler.trackAccountDeletion(Trigger.oldMap);
}
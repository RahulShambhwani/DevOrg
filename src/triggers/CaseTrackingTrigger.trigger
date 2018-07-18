trigger CaseTrackingTrigger on Case (before delete) {
	CaseTriggerHandler.trackCaseDeletion(Trigger.oldMap);
}
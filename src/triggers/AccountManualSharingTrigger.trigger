trigger AccountManualSharingTrigger on Account (after insert) {
    AccountTriggerHandler.getParentAccountFromAccount(Trigger.newMap);
}
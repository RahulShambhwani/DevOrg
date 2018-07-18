trigger AccountRecursiveTrigger on Account (after update, after insert) {
    if(Constants.updateSLADate)
        AccountTriggerHandler.updateSLA(Trigger.new);
}
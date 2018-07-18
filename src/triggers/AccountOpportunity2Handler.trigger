trigger AccountOpportunity2Handler on Opportunity (before update, before delete) {
    AccountOpportunity2Handler.checkOpportunity(Trigger.newMap, Trigger.oldMap, Trigger.old);
}
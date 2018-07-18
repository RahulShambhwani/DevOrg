trigger UniqueContactTrigger on Contact (before insert, before update) {
    UniqueContactTriggerHandler.UniqueContact(Trigger.new, Trigger.oldMap);
}
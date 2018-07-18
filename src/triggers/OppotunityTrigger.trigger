trigger OppotunityTrigger on Opportunity (after insert, after update) {
	if(Trigger.isUpdate){
    	OpportunityTriggerHandler.populateManager(Trigger.new);
        OpportunityTriggerHandler.populateCloseDate(Trigger.new);
    }
//  if(Constants.updateOppurtunityStage)  
        if(Trigger.isInsert || Trigger.isUpdate)
            OpportunityTriggerHandler.closeOpportunityRelatedToSystemAdmin(Trigger.new, Trigger.oldMap);
}
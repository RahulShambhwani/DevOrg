trigger AccountOpportunityTrigger on Account (after insert) {
		 AccountOpportunityHandler.newOpportunity(Trigger.new);
}
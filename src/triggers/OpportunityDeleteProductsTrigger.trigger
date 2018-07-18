trigger OpportunityDeleteProductsTrigger on Opportunity (after insert, before update) {
	OpportunityTriggerHandler.deleteProductsOnReset(Trigger.new);
}
trigger BankAccountTrigger on Bank_Account__c (before insert, before update) {
//	BankAccountHandler.updatePhone(Trigger.old, Trigger.oldMap);
	Set<Id> conIdSet=new Set<Id>();
    Map<Id,List<Bank_Account__c>> bankAccMap=new Map<Id,List<Bank_Account__c>>();

	
}
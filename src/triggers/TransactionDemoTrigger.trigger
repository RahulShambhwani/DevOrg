trigger TransactionDemoTrigger on Transaction__c (before insert,before update	) {
	List<Transaction__c> transList=new List<Transaction__c>();
    for(Transaction__c trans: Trigger.old){
        trans.Transaction_Type__c='Debit';
    }
}
trigger AccountTrigger on Account (after insert, after update, before delete, after delete) {
	if(Trigger.isInsert){
        List<Account> accList=new List<Account>();
        for(Account acc:Trigger.new){
            Account a=new Account();
            a.Id=acc.Id;
            a.SLAExpirationDate__c=Date.today().addDays(90);
            accList.add(a);
    /*        if(Trigger.isAfter && Trigger.isUpdate){
                acc.SLAExpirationDate__c=acc.SLAExpirationDate__c.addDays(11);
            }
    */    }
        If(accList.size()>0)
            Update accList;
    }
    
    
    
    if(Trigger.isDelete){
        AccountTriggerHandler.restrictDeletionOnSingleContact(Trigger.new, Trigger.old);
    }

	if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
		AccountTriggerHandler.updateCheckboxOnAccountCheckbox(Trigger.new, Trigger.oldMap);    
}
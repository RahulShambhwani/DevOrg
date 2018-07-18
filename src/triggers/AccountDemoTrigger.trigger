trigger AccountDemoTrigger on Account (before insert, before update) {
	List<Account> accList=new List<Account>();
    for(Account acc:Trigger.new){
//        Account a=new Account();
//        a.Id=acc.Id;
        acc.SLA__c='Silver';
//        accList.add(a);
    }
//    if(accList.size()>0)
//        Update accList;
}
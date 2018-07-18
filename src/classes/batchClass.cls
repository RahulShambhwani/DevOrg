global class batchClass implements Database.Batchable<sObject>, Database.stateful, Schedulable {
    global Integer count=0;
    global Database.QueryLocator start(Database.BatchableContext startbatch){
        String str='SELECT Id, MailingStreet, MailingCity,  accountId, account.BillingCity, account.BillingStreet FROM Contact WHERE AccountId !=null';
        return Database.getQueryLocator(str);
    }
    
    global void finish(Database.BatchableContext finishBatch){
        System.debug(count);
    }
    global void execute(Database.BatchableContext exeBatch, List<sObject> sObjList){

		List<Contact> conList=(List<Contact>)sObjList;
        List<Contact> conUpdateList=new List<Contact>();
        for(Contact con: conList){
            con.MailingCity=con.Account.BillingCity;
            con.MailingStreet=con.Account.BillingStreet;
            conUpdateList.add(con);
            System.debug('Updating');
        }
        System.debug(conList.size());
        if(conUpdateList.size()>0)
            update conList;
        count++;
        
	    }

    public void execute(SchedulableContext sc){
        batchClass bat=new batchClass();
		Id job = Database.executeBatch(bat,10);
    }
    
}
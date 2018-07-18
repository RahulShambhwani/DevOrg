public class GetAccountFromContact {
    public void getRecords(){
        Set<Id> accountIdSet=new Set<Id>();
        List<Account> accList=new List<Account>();
        /*conList=[SELECT Id, Name 
                 FROM Contact
                 WHERE Department='Appirio' ];*/
        for(Contact con: [SELECT Id, Name, accountId 
                          FROM Contact 
                          WHERE Department='Appirio' ]){
			Account acc=new Account();
			acc.Id=con.AccountId;
            acc.Active__c='No';
            If(!accountIdSet.contains(acc.Id)){
	            accList.add(acc);
                accountIdSet.add(con.AccountId);
            }
        }
        
        if(accList.size()>0)
            UPDATE accList;
    }
}
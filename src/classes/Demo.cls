public class Demo {
    public void readRecord(){
        List<Account> accountList = new List<Account>();
        accountList = [SELECT Id, Name, Active__c 
                       FROM Account 
                       WHERE Active__c='Yes' AND
                       Phone!=null LIMIT 10 ];
        
        for(Account acc: accountList)
            System.debug(acc.Id+'\t'+acc.Name);
        
        for(Contact con: [SELECT Id, Name, Account.Name 
                       FROM Contact 
                       WHERE Phone!=null LIMIT 10 ])
            System.debug(con.Id+' '+con.Name);
    }
    public void createRecords(){
        List <Account> accList=new List<Account>();
        for(Integer i=0;i<10;i++){
            Account acc=new Account();
            acc.Name='Test'+i;
            accList.add(acc);
            //System.debug(acc.Id+'>>>'+acc.Name);
        }
        if(accList.size()>0)
            insert accList;
        List<Account> accDel=new List<Account>();

		accDel=[SELECT Id 
                FROM Account
                WHERE Name LIKE 'Test%'];	
        if(accDel.size()>0)
            DELETE accDel;	                                                        
    }
}
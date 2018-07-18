public class MapDemo {

    public void getRecords(){
        Map<Id,Account> accountMap=new Map<Id,Account>();
       // List<Account> accList=new List<Account>();
        /*conList=[SELECT Id, Name 
                 FROM Contact
                 WHERE Department='Appirio' ];*/
        for(Contact con: [SELECT Id, Name, accountId 
                          FROM Contact 
                          WHERE Department='Appirio' AND AccountId!=null ]){
                              If(!accountMap.containsKey(con.AccountId)){//Reduce CPU time
                                    Account acc=new Account();
                                    acc.Id=con.AccountId;
                                    acc.Active__c='Yes';
                                    accountMap.put(acc.Id,acc);
                              }
            
        }
        System.debug(accountMap);
        if(accountMap.size()>0)
            UPDATE accountMap.values();
    }

}
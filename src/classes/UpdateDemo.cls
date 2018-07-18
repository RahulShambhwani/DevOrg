public class UpdateDemo {
    public void updateRecords(){
        List<Account> accList=new List<Account>();
        for(Account acc: [SELECT Id
                         FROM Account 
                          WHERE Name LIKE 'Test%']){
                              acc.Active__c='Yes';
                              accList.add(acc);
                              System.debug(acc.Name);
                          }
        if(accList.size()>0)
            Update accList;
    }
}
public class AccountOpportunityHandler {
    public static void newOpportunity(List<Account> accNewList){
		List<Opportunity> oppList=new List<Opportunity>();
                                          
            System.debug('first');
            for(Account acc: [SELECT Id, Name
                              FROM Account
                              WHERE Id IN :accNewList]){
                                    Opportunity opp=new Opportunity();
                                    opp.AccountId=acc.Id;
                                    opp.Name=acc.Name+'Opportunity';
                                    opp.StageName='Closed Won';
                                    opp.CloseDate=Date.newInstance(2018, 6, 13);
                                    oppList.add(opp);
                                }
 
        if(oppList.size()>0)
            Insert oppList;

    }
}
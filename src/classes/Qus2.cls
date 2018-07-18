public class Qus2 {
    public static void getAccounts(){
        Map<Id,Set<Id>> oppMap=new Map<Id,Set<Id>>();
		Set<Id> accIdSet=new Set<Id>();
        
        for(Opportunity opp: [SELECT Id, AccountId
                              FROM Opportunity
                              WHERE AccountId != null]){
								accIdSet.add(opp.AccountId);
                              }

		for(Account acc: [SELECT Id, (SELECT Id FROM Opportunities)
                          FROM Account
                          WHERE Id IN :accIdSet]){
                              for(Opportunity opp: acc.Opportunities){
                                  if(!oppMap.containsKey(acc.Id))
										oppMap.put(acc.Id, new Set<Id>());
                                  oppMap.get(acc.Id).add(opp.Id);
                              }
                          }		

        for(Id accId: oppMap.keySet())
            
                System.debug('Account Id >>'+ accId+ 'Opportunity Ids >> '+oppMap.get(accId));
            /* 
              OR We can use this
              Set<Opportunity> opp= oppMap.get(oppId);
                System.debug(opp);
			*/
       // }
        System.debug(oppMap.size());
        
    }
}
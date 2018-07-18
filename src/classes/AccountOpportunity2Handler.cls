public class AccountOpportunity2Handler {
    public static void checkOpportunity(Map<Id,Opportunity> oppNewMap, Map<Id,Opportunity> oppOldMap, List<Opportunity> oppOldList){
                                            Set<Id> accIdSet=new Set<Id>();
											Map<Id,Integer> accMap=new Map<Id,Integer>();
                                                for(Id opp: oppNewMap.keySet()){
                                                                          if(oppNewMap==null || oppOldMap.get(Opp).AccountId != oppNewMap.get(opp).AccountId)
                                                                              accIdSet.add(oppOldMap.get(opp).AccountId);
                                                                      }

	                                            for(Account acc: [SELECT Id, (SELECT Id FROM Opportunities)
                                                              FROM Account
                                                              WHERE Id IN :accIdSet]){
																accMap.put(acc.Id,acc.Opportunities.size());
                                                              }
        for(Id oppId: oppOldMap.keySet()){
            Opportunity tempOpp=null;
            Opportunity oldRecord=oppOldMap.get(oppId);
			if(oppNewMap==null)
				tempOpp=oppOldMap.get(oppId);
            else
                tempOpp=oppNewMap.get(oppId);

            if(accMap.get(oldRecord.AccountId)==1)
                tempOpp.addError('Can not change account');
            else{
                
                Integer temp=accMap.get(oldRecord.AccountId);
                temp--;
                accMap.put(oldRecord.AccountId,temp);
            }
                
        }
        
                                            
    }
}
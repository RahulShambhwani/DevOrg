public class OpportunityTriggerHandler {
    public static void populateManager(List<Opportunity> oppList){
        for(Opportunity opp: oppList){
            if(opp.BillToContact__c!=null && opp.Manager__c==null)
                opp.Manager__c=opp.accountId;
        }
    }
    
    public static void populateCloseDate(List<Opportunity> oppNewList){
        
        for(Opportunity opp: [SELECT Id, StageName,CloseDate
                              FROM Opportunity
                              WHERE Id IN :oppNewList]){
            if(opp.StageName=='Closed Won' || opp.StageName=='Closed Lost'){
                opp.CloseDate=Date.today();
            }
        }
    }
    
    public static void closeOpportunityRelatedToSystemAdmin(List<Opportunity> oppNewList, Map<Id,Opportunity> oppOldMap){
       // if(UserInfo.getUserId()=='00e7F000002sA1z'){
            
            List<Profile> sysAdminList=[SELECT Id FROM Profile WHERE Name='System Administrator'];
			List<Opportunity> oppList=new List<Opportunity>();
            Set<Id> accIdSet=new Set<Id>();
            for(Opportunity opp: [SELECT Id, StageName, accountId
                                  FROM Opportunity
                                  WHERE Id IN :oppNewList ] ){
                                      if(oppOldMap==null || opp.StageName != oppOldMap.get(Opp.Id).StageName 
                                         && (opp.StageName=='Closed Won' || opp.StageName=='Closed Lost')){

                                             if(!accIdSet.contains(opp.AccountId) )
                                                 accIdSet.add(opp.AccountId);
                                         }
                                     // System.debug(opp.StageName +' '+ oppOldMap.get(Opp.Id).StageName);
                                  }


        for(Opportunity opp: [SELECT Id, StageName, accountId
                                                        FROM Opportunity
                                                        WHERE accountId IN :accIdSet
                                                        AND (StageName!='Closed Won' 
                                                        OR StageName!='Closed Lost')]){
                                                          
                                                            opp.StageName='Closed Won';
                                                            oppList.add(opp);

                                                        }
        
									
       // Constants.updateOppurtunityStage=false;
            if(oppList.size()>0)
                update oppList;
       // }
        
    }
    
    
    public static void deleteProductsOnReset(List<Opportunity> oppNewList){
		
        
        List<OpportunityLineItem> oppLineList=new List<OpportunityLineItem>();
        for(OpportunityLineItem oppLine: [SELECT Id, OpportunityId 
                                           FROM OpportunityLineItem
                                           WHERE OpportunityId IN :oppNewList]){
                                               oppLineList.add(oppLine);
                                           }
        if(oppLineList.size()>0)
            delete oppLineList;
    }
    
    
}
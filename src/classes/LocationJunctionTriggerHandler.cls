public class LocationJunctionTriggerHandler {
    public static void uniqueLocationForEachOpportunity(List<LOCATION_JUNCTION__c> locNewList, Map<Id, LOCATION_JUNCTION__c> locOldMap){

        List<LOCATION_JUNCTION__c> locList=new List<LOCATION_JUNCTION__c>();
        Set<String> uniqueLocationSet=new Set<String>();
        Map<Id,LOCATION_JUNCTION__c> oppMap=new Map<Id, LOCATION_JUNCTION__c>();
        Set<Id> accIdSet=new Set<Id>();
        if(locNewList != null){
            for(LOCATION_JUNCTION__c loc: locNewList){
                if(locOldMap == null || loc.Opportunity__c != locOldMap.get(loc.Id).Opportunity__c
                   || loc.Location__c != locOldMap.get(loc.Id).Opportunity__c){
                    if(!oppMap.containsKey(loc.Opportunity__c))
                        oppMap.put(loc.Opportunity__c,loc);
                }
            }
        }
        
        for(Opportunity opp: [SELECT Id, AccountId
                              FROM Opportunity
                              WHERE Id IN :oppMap.keySet()]){
                                  if(!accIdSet.contains(opp.AccountId))
                                      accIdSet.add(opp.AccountId);
                                  
                              }
        for(Opportunity opp: [SELECT Id, AccountId, (SELECT Id, Location__c FROM LOCATION_JUNCTIONS__r) 
                              FROM Opportunity 
                              WHERE AccountId IN :accIdSet]){
                                  for(LOCATION_JUNCTION__c loc: opp.LOCATION_JUNCTIONS__r){
                                      String uniqueLoc=opp.AccountId+''+loc.Location__c;
                                      uniqueLocationSet.add(uniqueLoc);
                                  }
                              }
		for(Opportunity opp: [SELECT Id, AccountId
                              FROM Opportunity
                              WHERE Id IN :oppMap.keySet()]){
                                  String uniqueLoc=opp.AccountId+''+oppMap.get(opp.Id).Location__c;
                                  if(uniqueLocationSet.contains(uniqueLoc))
                                      oppMap.get(opp.Id).Location__c.addError('please select different location');
                              }
        
/*
          for(LOCATION_JUNCTION__c loc: locList){

            String uniqueLoc=loc.Location__c+'';
            if(uniqueLocationSet.contains(uniqueLoc))
                loc.Location__c.addError('Location can not be same ');
        }
*/
    }
}
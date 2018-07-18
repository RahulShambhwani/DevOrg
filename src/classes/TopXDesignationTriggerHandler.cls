public class TopXDesignationTriggerHandler {
    public static void topXDesignation(List<Top_X_Designation__c> newList,Map<Id,Top_X_Designation__c> newMap,
                                       List<Top_X_Designation__c> oldList, Map<Id,Top_X_Designation__c> oldMap){
                                           
                                           Set<Id> oppIdSet=new Set<Id>();
                                           Map<Id,Top_X_Designation__c> topXTrueMap=new Map<Id,Top_X_Designation__c>();
                                           Map<Id,Top_X_Designation__c> topXFalseMap=new Map<Id,Top_X_Designation__c>();
                                           Set<Id> topXDeleteSet=new Set<Id>();
                                           List<Opportunity> oppList=new List<Opportunity>();
                                           if(newMap!=null){
                                               for(Top_X_Designation__c topX: [SELECT Id, opportunity__c, Type__c, Document_Attached__c
                                                                               FROM Top_X_Designation__c
                                                                               WHERE Id IN :newList]){
                                                                                   if(oldMap==null || (newMap!=null && 
                                                                                                       oldMap.get(topX.Id).opportunity__c != topX.opportunity__c)){
                                                                                                           oppIdSet.add(topX.Opportunity__c);
                                                                                                           if(topX.Type__c=='Contract Flow Down/Handoff' && 
                                                                                                              topX.Document_Attached__c==true )
                                                                                                               topXtrueMap.put(topX.Opportunity__c, topX);
                                                                                                           else
                                                                                                               topXFalseMap.put(topX.Opportunity__c, topX);
                                                                                                           System.debug('New');
                                                                                                           if(oldMap!=null){
                                                                                                               oppIdSet.add(oldMap.get(topX.Id).Opportunity__c);
                                                                                                               System.debug('Old');
                                                                                                           }
                                                                                                       }
                                                                                   System.debug('Insert/Update');
                                                                               }
                                           }
                                           else{
                                               for(Id topXId: oldMap.keySet()){
                                                   oppIdSet.add(oldMap.get(topXId).Opportunity__c);
                                                   topXDeleteSet.add(oldMap.get(topXId).Opportunity__c);
                                                   System.debug('Delete');
                                               }
                                           }
                                           
                                           
                                           for(Opportunity opp: [SELECT Id, Handoff_Attached__c
                                                                 FROM Opportunity  
                                                                 WHERE Id IN :oppIdSet]){
                                                                     if(topXtrueMap.containsKey(opp.Id)){
                                                                         opp.Handoff_Attached__c='Yes';
                                                                         oppList.add(opp);
                                                                     }
                                                                     if(topXFalseMap.containsKey(opp.Id)){
                                                                         opp.Handoff_Attached__c='No';
                                                                         oppList.add(opp);
                                                                     }
                                                                     if(topXDeleteSet.contains(opp.Id)){
                                                                     	 opp.Handoff_Attached__c='';
                                                                         oppList.add(opp);
                                                                     }
                                                                     System.debug(oppList.size());
                                                                 }
                                           
                                           /*                                           for(Top_X_Designation__c topX: [SELECT Id, Type__c, Opportunity__c, Document_Attached__c 
FROM Top_X_Designation__c 
WHERE Opportunity__c IN :oppIdSet]){
System.debug('<<<>>>');
// System.debug(topX.Opportunity__c);
if(){
Opportunity opp=new Opportunity();
opp.Id=topX.Opportunity__c;
opp.Handoff_Attached__c='Yes';
oppList.add(opp);
System.debug('Insert/Update condition true Opportunity');
}
else{
Opportunity opp=new Opportunity();
opp.Id=topX.Opportunity__c;
opp.Handoff_Attached__c='No';
System.debug('Insert/Update condition false Opportunity');
oppList.add(opp);
}
}
*/                                           if(oppList.size()>0)
    											update oppList;
                                       }
    
    
}
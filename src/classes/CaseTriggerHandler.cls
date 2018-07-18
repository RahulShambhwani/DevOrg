public class CaseTriggerHandler {

    public static void trackCaseDeletion(Map<Id,Case> caseOldMap){
        if(caseOldMap!=null){
            List<Tracking__c> trackList=new List<Tracking__c>();
            for(Case cs: [SELECT Id, CaseNumber
                              FROM Case
                              WHERE ID IN :caseOLdMap.keySet()]){
                                  Tracking__c track=new Tracking__c();
                                  track.Name=cs.CaseNumber;
                                  track.Object__c='Case';
                                  track.Deleted_By__c=UserInfo.getFirstName()+' '+UserInfo.getLastName();
                                  trackList.add(track);
                              }
            if(trackList.size()>0)
	            Insert trackList;
        }
    }
    
    
}
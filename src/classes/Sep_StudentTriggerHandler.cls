public class Sep_StudentTriggerHandler {
    public static void findTopperOfCollege(List<Sep_Student__c> stNewList, Map<Id, Sep_Student__c> stOldMap){

		Map<Id,List<Sep_Student__c>> clgMap=new Map<Id,List<Sep_Student__c>>();
        Set<Id> clgIdSet=new Set<Id>();
        List<Sep_Student__c> stUpdateList=new List<Sep_Student__c>();
        System.debug('+++++');
        if(stNewList!=null){
            for(Sep_Student__c st: [SELECT Id, Has_Backlog__c, Is_Topper__c, Sep_college__c, Total_Marks_out_of_500__c
                                    FROM Sep_Student__c 
                                    WHERE Id IN :stNewList]){
                                        System.debug('Going');
                                        if(stOldMap==null
                                           || st.Total_Marks_out_of_500__c != stOldMap.get(st.Id).Total_Marks_out_of_500__c
                                           || st.Has_Backlog__c != stOldMap.get(st.Id).Has_Backlog__c
                                           || st.Sep_college__c != stOldMap.get(st.Id).Sep_College__c){
                                               
                                                if(!clgMap.containsKey(st.Sep_college__c))
                                                    clgMap.put(st.Sep_college__c, new List<Sep_Student__c>());
                                                clgMap.get(st.Sep_college__c).add(st);
                                                
                                               
                                                if(stOldMap!=null && st.Sep_college__c != stOldMap.get(st.Id).Sep_College__c){
                                                    if(!clgMap.containsKey(stOldMap.get(st.Id).Sep_College__c))
	                                                    clgMap.put(stOldMap.get(st.Id).Sep_College__c, new List<Sep_Student__c>());
                                                    clgMap.get(stOldMap.get(st.Id).Sep_College__c).add(st);
                                                }
                                               System.debug('Insert/Update');
                                                   System.debug('<<<>>>');
                                               }
                                        }
                                    
        }
        
        Map<Id,Integer> maxMarksMap=new Map<Id,Integer>();
        for(Sep_College__c clg: [SELECT Id, (SELECT Id, Total_Marks_out_of_500__c FROM Sep_Students__r) 
                                 FROM Sep_College__c 
                                 WHERE Id IN :clgMap.keySet()]){
                                     Integer max=0;
                                     for(Sep_Student__c st:clg.Sep_Students__r){
                                         if(st.Total_Marks_out_of_500__c>max)
                                             max=(Integer)st.Total_Marks_out_of_500__c;
                                     }
                                     maxMarksMap.put(clg.Id, max);
                                 }
        
        for(Sep_Student__c st: [SELECT Id, Total_Marks_out_of_500__c, Is_Topper__c, Has_Backlog__c, Sep_College__c
                                FROM Sep_Student__c 
                                WHERE Sep_College__c IN :clgMap.keySet()]){
                                    
                                    if(st.Has_Backlog__c == false && maxMarksMap.get(st.Sep_college__c) == Integer.valueOf(st.Total_Marks_out_of_500__c)){                                       
	                                        st.Is_Topper__c=true;
                                        System.debug(st.Is_Topper__c);
                                    }
                                    else
                                        st.Is_Topper__c=false;
                                    stUpdateList.add(st);
                                }
        if(stUpdateList.size()>0)
            update stUpdateList;
    }
}
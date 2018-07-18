public class StudentTriggerHandler {
    public static void countRecords(List<Student__c> stNewList, Map<Id, Student__c> stOldMap, Map<Id, Student__c> stNewMap, 
                                    List<Student__c> stOldList){
//	Map<Id,Student__c> stMap=new Map<Id,Student__c>();
	Set<Id> clgIdSet=new Set<Id>();
        List<College__c> clgList=new List<College__c>();
        List<Student__c> stList2=new List<Student__c>();
        
        if(stNewList!=null){
            for(Student__c st: stNewList){
                if(stOldMap == null  || (stNewMap!=null && stOldMap.get(st.Id).College__c != stNewMap.get(st.Id).College__c)){//Insert & Update
                    clgIdSet.add(st.College__c);	//Update for newer record	
                if(stOldMap!=null)					//Only Update For older record
                     clgIdSet.add(stOldMap.get(st.Id).College__c);
                }
        	}
		}
        else                				// New List Null & New Map Null                
            for(Student__c st: stOldList)
                if(stOldMap!=null && stnewMap==null)
                    clgIdSet.add(st.College__c);
            
        for(College__c clg: [SELECT Id, count__c, (SELECT Id FROM Students__r)
                                         FROM College__c
                                         WHERE Id IN :clgIdSet]){
                                             clg.Count__c = clg.Students__r.size(); 
                                             clgList.add(clg);
                                         }
        if(clgList.size()>0)
            update clgList;
    }
}
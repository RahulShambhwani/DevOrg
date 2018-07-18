public class SemesterTriggerHandler {
    public static void findTopperOfEachSem(List<Semester__c> semNewList, Map<Id, Semester__c> semOldMap){

		Set<Id> studentIdSet=new Set<Id>();
        Set<Id> collegeIdSet=new Set<Id>();
        Map<Id,Integer> batchYearMap=new Map<Id,Integer>();
        Map<String, CollegeReport__c> uniqueReportMap=new Map<String, CollegeReport__c>();
        Set<String> semesterSet=new Set<String>();
        List<CollegeReport__c> reportInsertList=new List<CollegeReport__c>();
        List<CollegeReport__c> reportUpdateList=new List<CollegeReport__c>();
        Map<String,Student2__c> studentMaxMarksMap=new Map<String, Student2__c>();
        
        if(semNewList!=null){
            for(Semester__c sem: semNewList){
                if(semOldMap==null || sem.Marks__c != semOldMap.get(sem.Id).Marks__c){
                    if(!studentIdSet.contains(sem.Student2__c))
                        studentIdSet.add(sem.Student2__c);
                    
                    System.debug('Insert');
                }
            }
        }
        System.debug('Start >> '+studentIdSet);
        for(Student2__c st: [SELECT Id, College2__c, AdmissionDate__c 
                             FROM Student2__c
                             WHERE Id IN :studentIdSet]){
                                 if(!collegeIdSet.contains(st.College2__c))
                                     collegeIdSet.add(st.College2__c);
								 if(!batchYearMap.containsKey(st.Id))
                                    batchYearMap.put(st.Id, Integer.valueOf(st.AdmissionDate__c.year()));
                                 System.debug('Fatching College >> '+st.College2__c);
                             }
        Integer maxSem1,maxSem2,maxSem3,maxSem4;
        maxSem1=0;maxSem2=0;maxSem3=0;maxSem4=0;
        for(Student2__c st: [SELECT Id, Name, College2__c, AdmissionDate__c,  (SELECT Id, Sem__c, Marks__c FROM Semester__r)  
                             FROM Student2__c
                             WHERE College2__c IN :collegeIdSet
                             AND CALENDAR_YEAR(AdmissionDate__c) IN :batchYearMap.values()]){
                                 
                                 for(Semester__c sem: st.Semester__r){
                                     System.debug('Semester >> '+sem.Sem__c);
                                     if(sem.Sem__c=='Sem1'){
                                         if(sem.Marks__c > maxSem1){
                                             maxSem1=(Integer)sem.Marks__c;
                                             studentMaxMarksMap.put(sem.Sem__c,st);
                                         }
                                     }
                                     else if(sem.Sem__c=='Sem2'){
                                         if(sem.Marks__c > maxSem2){
                                             maxSem2=(Integer)sem.Marks__c;
                                             studentMaxMarksMap.put(sem.Sem__c,st);
                                         }
                                     }
                                     else if(sem.Sem__c=='Sem3'){
                                         if(sem.Marks__c > maxSem3){
                                             maxSem3=(Integer)sem.Marks__c;
                                             studentMaxMarksMap.put(sem.Sem__c,st);
                                         }
                                     }
                                     else if(sem.Sem__c=='Sem4'){
                                         if(sem.Marks__c > maxSem4){
                                             maxSem4=(Integer)sem.Marks__c;
                                             studentMaxMarksMap.put(sem.Sem__c,st);
                                         }
                                     }
                                     
                                     if(!semesterSet.contains(sem.Sem__c))
                                         semesterSet.add(sem.Sem__c);
                                 }
                             }
        for(CollegeReport__c report: [SELECT Id, College2__c, Semester__c, Topper__c, Batch__c
                                      FROM CollegeReport__c 
                                      WHERE College2__c IN :collegeIdSet]){
                                          String uniqueReport=report.College2__c+report.Semester__c+report.Batch__c;
                                          if(!uniqueReportMap.containsKey(uniqueReport))
                                              uniqueReportMap.put(uniqueReport, report);
                                      }
        
        System.debug('End Phase');
        for(String sem: semesterSet){
        	CollegeReport__c clgReport=new CollegeReport__c();
            clgReport.College2__c='a0P7F000003OSKP';
			clgReport.Semester__c=sem;				
			clgReport.Topper__c = studentMaxMarksMap.get(sem).Name;
            clgReport.Batch__c = batchYearMap.get( studentMaxMarksMap.get(sem).Id )+'';		// String From Integer
            
            String uniqueReport=clgReport.College2__c + clgReport.Semester__c+clgReport.Batch__c;
            if(uniqueReportMap.containsKey(uniqueReport)){
                clgReport.Id=uniqueReportMap.get(uniqueReport).Id;
                reportUpdateList.add(clgReport);
            }
            else
	            reportInsertList.add(clgReport);
            System.debug('Report >> '+clgReport);
            
        }
        
        System.debug('Size: >> '+reportInsertList.size());
        if(reportInsertList.size()>0)
            Insert reportInsertList;
        if(reportUpdateList.size()>0)
            Update reportUpdateList;
    }
}
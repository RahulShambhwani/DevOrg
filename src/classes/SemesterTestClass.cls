@isTest
public class SemesterTestClass {
    @isTest static void testCollegeReport(){
        College2__c clg=new College2__c(Name='Skit');
        Database.Insert(clg);

        System.debug(clg.Id);
		List<Student2__c> stList=new List<Student2__c>();
        for(Integer i=0;i<3;i++){
            Student2__c st=new Student2__c(Name='st'+i, College2__c=clg.Id, AdmissionDate__c=Date.newInstance(2017, 2, 1));
            stList.add(st);
        }
        Database.Insert(stList);
        
        List<Semester__c> semList=new List<Semester__c>();
        Integer i=0;
        for(Student2__c st: stList){
            Semester__c sem=new Semester__c(Name='sm'+i, Student2__c=st.Id);
            if(i/2==0){
                System.debug(st.Name);
                sem.Marks__c=100;
                sem.Sem__c='Sem1';
            }
            else{
                //System.debug(st.Name);
                sem.Marks__c=50;
                sem.Sem__c='Sem3';
            }
            i++;
            semList.add(sem);
        }
        Database.insert(semList);
        
        i=0;
        for(CollegeReport__c report: [SELECT Id, College2__c, Batch__c, Semester__c, Topper__c
                                      FROM CollegeReport__c ]){
                                          if(i/2==0){           
                                          	System.assertEquals('st'+i, report.Topper__c);
                                          }
                                          //System.debug(report+'><><');
                                          i++;
        }
        
    }
}
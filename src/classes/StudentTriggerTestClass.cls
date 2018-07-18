@isTest
public class StudentTriggerTestClass {
    @isTest static void testRecordInsertCountInCollege(){

        List<College__c> clgList=new List<College__c>();
		for(Integer i=0;i<5;i++){
            College__c clg=new College__c(Name='testCollege'+i);
            clgList.add(clg);
        }
        insert clgList;

        List<Student__c> stList=new List<Student__c>();
        for(Integer i=0;i<5;i++){
            for(Integer j=0;j<2;j++){
	            Student__c st=new Student__c(Name='testSt1',Student_Email__c='a@b.com', college__c=clgList[i].Id);
				stList.add(st);
            }
        }
        insert stList;
        
        List<College__c> clList=[SELECT count__c FROM College__c WHERE Id =:clgList];
        for(Integer i=0;i<clgList.size();i++){
            //System.debug('<<<'+clList[i].Count__c+'++++++');            
			System.assertEquals(2, clList[i].Count__c, 'Count');
        }

        // Update

		
		List<Student__c> stList2=new List<Student__c>();
        
        for(Student__c st: [SELECT Id, College__c
                            FROM Student__c 
                            WHERE Id IN :stList]){
            st.College__c=clList[0].Id;
            stList2.add(st);
           // System.debug('<<<'+st.College__c+'>>>');
        }
        update stList2;
        List<College__c> cList=[SELECT Id, Count__c
                                FROM College__c
                                WHERE Id IN :clList];
        
			System.assertEquals(10, cList[0].Count__c, 'Count');
    }

        
}
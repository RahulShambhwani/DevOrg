public class MyCollegeResultController {
    public String userId{get;set;}
    public String year{get;set;}
    public String selectedCollegeId{get;set;}
    public AS5_College__c selectedCollege{get;set;}
    public String selectedYear{get;set;}
    public String topper{get;set;}    
    public Integer averageMarks{get;set;}
    public String selectedStudentId{get;set;}
    public AS_Student__c selectedStudent{get;set;}
    public Boolean isEdit{get;set;}
    
    public List<SelectOption> collegeList{get;set;}
    public List<SelectOption> yearList{get;set;}
    public List<AS_Student__c> studentList{get;set;}
    
    
    public MyCollegeResultController(){
        studentList=new List<AS_Student__c>();
        
        userId= ApexPages.currentPage().getParameters().get('id');
        year= ApexPages.currentPage().getParameters().get('year');
        
        if(userId==null)
            userId=UserInfo.getUserId();
        if(year==null){
            Date dat = System.today();
            year = String.valueOf(dat.year());  
            selectedYear=year;
        }
        else
            selectedYear=year;
        
        //System.debug(userId);        
        collegeList=new List<SelectOption>();
        yearList=new List<SelectOption>();
        
        collegeList.add(new SelectOption('', '--None--'));
        for(AS5_College__c clg: [Select Id, Name
                                 FROM AS5_College__c
                                 WHERE Name !=NULL]){
                                     collegeList.add(new SelectOption(clg.Id, clg.Name));
                                 }
        
        for(Integer i=0;i<10;i++){
            yearList.add(new SelectOption('201'+i,'201'+i));
        }
        
        
    }
    
    
    public void getCollegeTopper(){
        Decimal maxMarks=0;
        averageMarks=0;
        Decimal sum=0;
        topper=null;
        studentList.clear();
        
        for(AS_Student__c st: [SELECT Id, Name, College__c, Admission_Date__c, Marks__c
                               FROM AS_Student__c
                               WHERE College__c =:selectedCollegeId
                               AND CALENDAR_YEAR(Admission_Date__c) =:Integer.valueOf(selectedYear)]){
                                   studentList.add(st);
                                   if(st.Marks__c > maxMarks){
                                       topper=st.Name;
                                       maxMarks=st.Marks__c;
                                   }
                                   sum+=st.Marks__c;
                               }
        if(selectedCollegeId !=null)
            selectedCollege=[SELECT Name,College_Owner__c FROM AS5_College__c WHERE Id =:selectedCollegeId];
        if(studentList.size()>0)
            averageMarks=Integer.valueOf(sum/(studentList.size()));
    }
    
    public void editMarksOfStudent(){
        isEdit=false;
        selectedStudent=[SELECT Id, Name, Marks__c, Admission_Date__c FROM AS_Student__c WHERE Id =:selectedStudentId];
    } 
    
    public void save(){
        
        if(selectedStudent.Marks__c<=0 || selectedStudent.Marks__c==null){
            isEdit=false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Marks can not be null & must be grater than \'0\''));
        }
        
        else{
            isEdit=true;
            update selectedStudent;
            getCollegeTopper();
        }
        
    }
}
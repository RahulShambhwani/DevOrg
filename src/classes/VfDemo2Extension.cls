public class VfDemo2Extension {
    public Id contactId{get;set;}
    public String message{get;set;} 
    public Contact con;
    public VfDemo2Extension(ApexPages.StandardController sc){
    	contactId=ApexPages.currentPage().getParameters().get('id');
        con=new Contact();
        con=(Contact)sc.getRecord();
        
    }
    
    public void greet(){
        if(con.Id!=null)
            message='Welcome '+ con.LastName;
        else{
            Contact con=new Contact();
            con.LastName='TestCon';
            insert con;
        }
    }
    
    public PageReference cancel(){
        PageReference pg=new PageReference('/apex/recruitment');
        return pg;
    }
}
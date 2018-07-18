public class NewPageExtension {
    public String message{get;set;}
    public Account acc;
    public NewPageExtension(ApexPages.StandardController sc){
/*        Account acc=new Account();
        acc.Name='Test';
        insert acc;					//DML Not Allowed in Costructor;
*/
        acc=new Account();
        acc=(Account)sc.getRecord();	// Get record of passed Id in URL
    }
    
    public void greeting(){
        if(acc.Id!=null)
            message='Welcome '+ acc.Name;
        else{
            Account acc=new Account();
            acc.Name='Test';
            insert acc;
        }        

    }
    
    
    public PageReference cancelMe(){
        PageReference pg=new PageReference('/apex/Login_form'); 
        return Pg;
    }
}
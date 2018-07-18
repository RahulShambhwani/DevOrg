public class DemoVF8Controller {
    public String message1{get;set;}
    public String message2{get;set;}
    public Boolean displayPanel{get;set;}
    public Boolean isEdit{get;set;}
    public Boolean editCon{get;set;}
    public Account acc{get;set;}
    public List<Contact> conList{get;set;}
    public DemoVF8Controller(){
        acc=new Account();
        conList=new List<Contact>();
        Id AccountId=ApexPages.currentPage().getParameters().get('id');

        for(Account acct: [SELECT Name, Rating
                          FROM Account 
                          WHERE Id =:AccountId]){
                              acc=acct;
                          }

        for(Contact con: [SELECT Id, AccountId, FirstName, LastName 
                          FROM Contact 
                          WHERE AccountId =:AccountId 
                          AND AccountId !=NULL]){
                              conList.add(con);
            }

        message1='message1';
        message2='message2';

    }
    public void showPanel(){
        displayPanel=true;
    }

    public void save(){
		upsert acc;
        isEdit=false;
    }
    public void isEdit(){
        isEdit=true;
    }
    public void saveContact(){
        update conList;
        editCon=false;        
    }
    public void editContact(){
        editCon=true;
    }
}
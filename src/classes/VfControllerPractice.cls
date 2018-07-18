public class VfControllerPractice {
    public List<SelectOption> accList{get;set;}
    public List<Contact> conList{get;set;}
    public Map<Id,Account> accMap=new Map<Id,Account>();
    public Map<Id,Contact> conMap=new Map<Id,Contact>();
    public Id selectedAccId{get;set;}
    public String selectedConId{get;set;}
    public Account selectedAccount{get;set;}
    public Contact selectedContact{get;set;}
    public Boolean isEdit{get;set;}
    public VfControllerPractice(){
        accList=new List<SelectOption>();
        conList=new List<Contact>();
        selectedAccount=new Account();
        selectedContact=new Contact();
        isEdit=false;
        accList.add(new SelectOption('', '--None--'));
        for(Account acc: [SELECT Id, Name, SLAExpirationDate__c 
                          FROM Account 
                          LIMIT 10]){
                              accList.add(new SelectOption(acc.Id, acc.Name));
                              accMap.put(acc.Id, acc);
                          }
        
    }
    
    public void getAccountRecord(){
        selectedAccount=accMap.get(selectedAccId);
        conList=[SELECT Id, FirstName, LastName, Name, Email, AccountId 
                 FROM Contact 
                 WHERE AccountId =:selectedAccId];
        for(Contact con: conList){
            conMap.put(con.Id, con);
        }
        selectedConId=null;
    }
    public void getContactRecord(){
        
        selectedContact=conMap.get(selectedConId);
        
        isEdit=true;	
    }
    
    public void save(){
        update selectedContact;
        conList.clear();
        conList=[SELECT Id, FirstName, LastName, Name, Email, AccountId 
                 FROM Contact 
                 WHERE AccountId =:selectedAccId];
        isEdit=false;
    }
}
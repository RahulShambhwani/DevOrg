public class DemoVf9Controller {
    public List<SelectOption> accList{get;set;}
    public List<Contact> conList{get;set;}
    public Map<Id,Account> accountIdToRecordMap=new Map<Id,Account>();
    public Map<Id,Contact> contactIdToRecordMap=new Map<Id,Contact>();
    public Account selectedAccount{get;set;}
    public Id selectedId{get;set;}
    public Contact selectedContact{get;set;}
    public String selectedContactId{get;set;}
    public String editContactId{get;set;}
    public List<ContactWrapper> conWrapperList{get;set;}
    
    public DemoVf9Controller(){

        accList=new List<SelectOption>();
        conList=new List<Contact>();
        selectedAccount=new Account();
        selectedContact= new Contact();
        conWrapperList=new List<ContactWrapper>();
        accList.add(new SelectOption('', '--None--'));			// accList.add(value, label)
        for(Account acc: [SELECT Id, Name,  Owner.Id, Owner.Name, AccountNumber 
                          FROM Account 
                          LIMIT 10]){
                              accList.add(new SelectOption(acc.Id,acc.Name));
                              accountIdToRecordMap.put(acc.Id, acc);
                          }
							         
    }
    
    public void displayAccountData(){
       
        selectedAccount=accountIdToRecordMap.get(selectedId);
        
        conList=[SELECT Id, FirstName, LastName, Name, Email, Account.Name, AccountId
                 FROM Contact 
                 WHERE accountId =:selectedId];			// Account.Id = AccountId
        for(Contact con: conList){
            contactIdToRecordMap.put(con.Id, con);
        }
        ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Account Data Displayed');
        ApexPages.addMessage(msg);
        populateWrapperData();
    }
    
    public void getCon(){
        selectedContact=contactIdToRecordMap.get(selectedContactId);
    }
    public void save(){
        Update selectedContact;
        conList.clear();
        conList=[SELECT Id, FirstName, LastName, Name, Email, Account.Name, AccountId
                 FROM Contact 
                 WHERE accountId =:selectedId];
        selectedContactId=null;
    }
    
    public void populateWrapperData(){
        List<Contact> tempContactList=new List<Contact>();
        Map<String, CustomObj__c>  customObjMap=new Map<String, CustomObj__c>();
        Set<String> emailSet=new Set<String>();
        conWrapperList= new List<ContactWrapper>();
        for(Contact con: [SELECT Id, FirstName, LastName, Name, Email, Account.Name, AccountId
                          FROM Contact 
                          WHERE accountId =:selectedId]){
                              tempContactList.add(con);
                              emailSet.add(con.Email);
                          }
        for(CustomObj__c obj: [SELECT Email__c, Admission_Date__c
                               FROM CustomObj__c
                               WHERE Email__c IN :emailSet]){
                                   customObjMap.put(obj.Email__c , obj);
                               }
        for(Contact con: tempContactList){
            if(customObjMap.containsKey(con.Email))
	            conWrapperList.add(new ContactWrapper(false, con, customObjMap.get(con.Email)));
            else
                conWrapperList.add(new ContactWrapper(false, con, new CustomObj__c()));
        }
    }
    
    public void updateRecord(){
        
        
        
    }
    public class ContactWrapper{
        public boolean isEdit{get;set;}
        public Contact conRecord{get;set;}
        public CustomObj__c customObj{get;set;}
        
        public ContactWrapper(boolean edit, Contact con, CustomObj__c custObj){
            isEdit=false;
            conRecord=new Contact();
            customObj=new CustomObj__c();
            conRecord = con;
            customObj = custObj;
            isEdit = edit;
        }
    }
}
public class VfController2Practice {
    public List<SelectOption> accList{get;set;}
    public List<Contact> conList{get;set;}
    public List<ConWrapper> conWrapperList{get;set;}
    public Map<String, CustomObj__c> customObjMap{get;set;}
    public Set<String> emailSet=new Set<String>();
    public Map<Id,Account> accMap=new Map<Id,Account>();
    public Map<Id,Contact> conMap=new Map<Id,Contact>();
    public Id selectedAccId{get;set;}
    public String selectedConId{get;set;}
    public Account selectedAccount{get;set;}
    public Contact selectedContact{get;set;}
    public VfController2Practice(){
        accList=new List<SelectOption>();
        customObjMap=new Map<String, CustomObj__c>();
        conList=new List<Contact>();
        selectedAccount=new Account();
        selectedContact=new Contact();
        conWrapperList=new List<ConWrapper>();
        accList.add(new SelectOption('', '--None--'));
        for(Account acc: [SELECT Id, Name, SLAExpirationDate__c 
                          FROM Account 
                          LIMIT 10]){
                              accList.add(new SelectOption(acc.Id, acc.Name));
                              accMap.put(acc.Id, acc);
                          }
        
    }
    
    public void getAccountRecord(){
        conWrapperList.clear();
        selectedAccount=accMap.get(selectedAccId);
        conList=[SELECT Id, FirstName, LastName, Name, Email, AccountId 
                 FROM Contact 
                 WHERE AccountId =:selectedAccId];
        for(Contact con: conList){
            conMap.put(con.Id, con);
            emailSet.add(con.Email);
        }
        
        for(CustomObj__c obj: [SELECT Id, Email__c, Admission_Date__c 
                               FROM CustomObj__C 
                               WHERE Email__c IN :emailSet]){
                                   if(!customObjMap.containsKey(obj.Email__c))
                                       customObjMap.put(obj.Email__c, obj);
                               }
        
        selectedConId=null;
    }
    
    public void getDataFromWrapper(){
        selectedContact=conMap.get(selectedConId);
        for(Contact con: [SELECT Id, FirstName, LastName, Name, Email
                          FROM Contact 
                          WHERE Id =:selectedConId]){
        
                              if(con.Email==selectedContact.Email)
                                  conWrapperList.add(new ConWrapper(true,selectedContact, customObjMap.get(selectedContact.Email)));
                          }
    }
    
    public void save(){
        update selectedContact;
        conList.clear();
        conList=[SELECT Id, FirstName, LastName, Name, Email, AccountId 
                 FROM Contact 
                 WHERE AccountId =:selectedAccId];
        
        conWrapperList.add(new ConWrapper(false, selectedContact,customObjMap.get(selectedContact.Email)));        
    }
    
    
    public class ConWrapper{
        public Boolean isEdit{get;set;}
        public Contact conRecord{get;set;}
        public CustomObj__c custObj{get;set;}
        
        public ConWrapper(Boolean edit, Contact con, CustomObj__c obj){
            conRecord=new Contact();
            custObj= new CustomObj__c();
            isEdit=edit;
            conRecord=con;
            custObj=obj;
            
        }
    }

}
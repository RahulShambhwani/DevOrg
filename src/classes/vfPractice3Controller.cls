public class vfPractice3Controller {
    public String selectedAccId{get;set;}
    public String selectedConId{get;set;}
    public Contact selectedContact{get;set;}
    public Set<String> emailSet{get;set;}
    public Map<Id,ConWrapper> conWrapMap{get;set;}
    public List<Contact> conList{get;set;}
    public Map<String, Sep_Student__c> studentMap{get;set;}
    
    public List<SelectOption> accList{get;set;}
    public vfPractice3Controller(){
        emailSet=new Set<String>();
        accList=new List<SelectOption>();
        conWrapMap=new Map<Id,ConWrapper>();
        conList=new List<Contact>();
        studentMap=new Map<String,Sep_Student__c>();
        accList.add(new SelectOption('', '--None--'));

        for(Account acc: [SELECT Id, Name
                          FROM Account 
                          LIMIT 10]){
                              accList.add(new SelectOption(acc.Id, acc.Name));
                          }
    }
    
    public void getContactData(){
        conWrapMap.clear();
        conList.clear();
        for(Contact con: [SELECT Id, AccountId, FirstName, LastName, Name, Email
                          FROM Contact 
                          WHERE AccountId =:selectedAccId]){
                              conList.add(con);
                              emailSet.add(con.Email);
                              //conWrapMap.add(con.Email, new ConWrapper(con, false, null));
                          }
        for(Sep_Student__c st: [SELECT Id,Email__c 
                                FROM Sep_Student__c
                                WHERE Email__c IN :emailSet]){
                                    studentMap.put(st.Email__c, st);
                                    //conWrapMap.put(st.Email__c, )
                                }
        for(Contact con: conList){
                              conWrapMap.put(con.Id, new ConWrapper(con, false, studentMap.get(con.Email)));
                          }
    }
    
    public void editContact(){
        //
    }
    
    public void save(){
        selectedContact=conWrapMap.get(selectedConId).cont;
        update selectedContact;
        //conWrapMap.put(selectedContact.Email, new ConWrapper(selectedContact, false, studentMap.get(selectedContact.Email)));
    }
    
    public class conWrapper{
        public Boolean isEdit{get;set;}
        public Contact cont{get;set;}
        public Sep_Student__c student{get;set;}
        public conWrapper(Contact con, Boolean edit, Sep_Student__c st){
            cont=con;
            isEdit=edit;
            student=st;
        }
    }
}
public class VfPractice4Controller {
    public List<SelectOption> conList{get;set;}
    public List<conWrapper> conWrapList{get;set;} 
    public Map<String, CustomObj__c> customObjMap{get;set;}
    public Set<String> emailSet{get;set;}

    public List<Transaction__c> transactionList{get;set;}
    public Contact selectedContact{get;set;}
    public Boolean isEdit{get;set;}
    public Boolean newTrans{get;set;}
    
    public Transaction__c trans{get;set;}
    public String selectedTransactionId{get;set;}
    public Transaction__c selectedTransaction{get;set;}
    public String contactName{get;set;}
    public String selectedConId{get;set;}
    public List<SelectOption> transPickList{get;set;}
    public String selectedtrans{get;set;}
    public Decimal transAmount{get;set;}
    public VfPractice4Controller(){
        transAmount=0.00;
        conList=new List<SelectOption>();
        emailSet=new Set<String>();
        conWrapList=new List<conWrapper>();
        transactionList=new List<Transaction__c>();	
        customObjMap=new Map<String, CustomObj__c>();
        transPickList=new List<SelectOption>();
    }
    public void getContactRecords(){
        conList.clear();
        emailSet.clear();
        conWrapList.clear();
        customObjMap.clear();
        transactionList.clear();
        for(Contact con: [SELECT Id, FirstName, LastName, Name, Email 
                          FROM Contact 
                          WHERE FirstName LIKE :(contactName+'%')
                          OR LastName LIKE :(contactName+'%')]){
                              emailSet.add(con.Email);
                              conList.add(new SelectOption(con.Id,con.Name));
                          }
    }
    
    public void getContactDetails(){
        conWrapList.clear();
        transactionList.clear();  
        selectedTransactionId=null;
        selectedContact= [SELECT Id, Name, FirstName, LastName, Email, Phone
                          FROM Contact
                          WHERE Id =:selectedConId];
        for(CustomObj__c custObj: [SELECT Id, Name, Email__c, Admission_Date__c
                                   FROM CustomObj__c
                                   WHERE Email__c IN :emailSet]){
                                       customObjMap.put(custObj.Email__c, custObj);
                                   }
        conWrapList.add(new conWrapper(selectedContact, customObjMap.get(selectedContact.Email)));
        
		for(Bank_Account__c acc: [SELECT Id, Account_Holder__c, (SELECT Id,Transaction_Type__c, Amount__c, Bank_Account__c FROM Transactions__r)
                                  FROM Bank_Account__c
                                  WHERE Account_Holder__c =:selectedConId]){
                                      transactionList.addAll(acc.Transactions__r);
                                  }        

    }
    
    public void editContact(){
        
    }
    
    public void saveAfterEdit(){
        update transactionList;
		selectedTransactionId=null;
    }
    
    public void updateTransactions(){
        update transactionList;
        selectedTransactionId=null;
    }
    
    public void newTransaction(){
        for(Schema.PicklistEntry pe: Transaction__c.Transaction_Type__c.getDescribe().getPicklistValues()){	// Product Family display on page load
            transPickList.add(new SelectOption(pe.getValue() , pe.getLabel()));
        }        
        newTrans=true;
    }
    
    public void save(){
		Transaction__c tran=new Transaction__c();
            tran.Amount__c = transAmount;
        	tran.Transaction_Type__c = selectedtrans;
        	tran.Bank_Account__c=transactionList.get(0).Bank_Account__c;
        insert tran;
        
        getContactDetails();
        
        newTrans=false;
    }
        
    public class conWrapper{
        public Contact con{get;set;}
        public CustomObj__c custObj{get;set;}
        public conWrapper(Contact getCon, CustomObj__c obj){
            con=getCon;
            custObj=obj;
        }
    }
}
public with sharing class Demovf10Controller {
    public List<Account> accList{get;set;}
    
    public Demovf10Controller(){
        accList=[SELECT Id, Name, Active__c, Type
                 FROM Account
                 WHERE Name =:'VFTest'];
    }
}
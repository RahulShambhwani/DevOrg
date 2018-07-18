public class DemoVf6Controller {
    public Id accountId{get;set;}
    public Account acc{get;set;}
    public String active{get;set;}
    public DemoVf6Controller(){
    
        accountId=ApexPages.currentPage().getParameters().get('aId');
 		active=ApexPages.currentPage().getParameters().get('active');       
        if(accountId!=null){
            for(Account acc1: [SELECT Id, Name, Rating, Active__c 
                              FROM Account 
                              WHERE Id =:accountId AND Active__c =:active]){
                                  acc=acc1;
                              }
        }

        else
	        acc=new Account();
    }    
    
    public Boolean validateRecord(){
        String error='';
        Boolean isRecordInvalid=false;
        if(acc.Rating=='Hot'){
            error='Rating can not be hot';
            isRecordInvalid=true;
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR, error);
            ApexPages.addMessage(msg);
        }
        return isRecordInvalid;
    }
    
    public PageReference save(){
        if(validateRecord())
            return null;
        upsert acc;
		ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Updated succefully');
		ApexPages.addMessage(msg);
		ApexPages.Message msg1=new ApexPages.Message(ApexPages.Severity.FATAL, 'Updated Unsuccefully');
		ApexPages.addMessage(msg1);
        
        //PageReference pg=new PageReference('/apex/DemoVF7?Id='+acc.Id);
        return null;
    }
    public PageReference cancel(){
        return null;
    }
    
    
}
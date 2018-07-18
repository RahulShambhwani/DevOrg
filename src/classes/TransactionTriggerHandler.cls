public class TransactionTriggerHandler {

    public static void updateStatus(List<Transaction__c> transNewList, List<Transaction__c> transOldList){
        List<Bank_Account__c> bankAccList=new List<Bank_Account__c>();
    	Set<Id> bankAccIdSet=new Set<Id>();
        // DELETE done but getting old total transaction while deleting 
        
        if(transNewList!=null){
        for(Transaction__c trans: transNewList){
        	bankAccIdSet.add(trans.Bank_Account__c);   
            System.debug('Insert body');
        }
        }
        
        else{
            for(Transaction__c trans: transOldList){
                                           if(transOldList!=null)
	                                           bankAccIdSet.add(trans.Bank_Account__c);
                                           System.debug('delete body');
                                       }
        }
        
        
        
        for(Bank_Account__c bankAcc: [SELECT Id, Account__c, Total_Transaction__c
 	                                     FROM Bank_Account__c 
                                      WHERE Id IN :bankAccIdSet]){
                                                                                 
                                       if(bankAcc.Account__c=='Current account'){
                                           if(bankAcc.Total_Transaction__c >=0 && bankAcc.Total_Transaction__c<5)
                                               bankAcc.Status2__c='Red';
                                           else if(bankAcc.Total_Transaction__c >=5 && bankAcc.Total_Transaction__c <10)
                                               bankAcc.Status2__c='Yellow';
                                           else if(bankAcc.Total_Transaction__c >10)
                                               bankAcc.Status2__c='Green';
                                           System.debug('Current');
                                       }
                                       else{
                                           if(bankAcc.Total_Transaction__c >=0 && bankAcc.Total_Transaction__c<5)
                                               bankAcc.Status2__c='Green';
                                           else if(bankAcc.Total_Transaction__c >=5 && bankAcc.Total_Transaction__c<10)
                                               bankAcc.Status2__c='Yellow';
                                           else if(bankAcc.Total_Transaction__c >10)
                                               bankAcc.Status2__c='Red';
                                           else
                                               bankAcc.Status2__c=' ';
                                           System.debug('Saving');
                                       }
                                        System.debug(bankAcc.Total_transaction__c);
                                       bankAccList.add(bankAcc);   
                                          
                                      }
        
        
        if(bankAccList.size()>0)
            update bankAccList;
    }
    
    public static void amountShouldNotNegative(List<Transaction__c> transNewList){
        for(Transaction__c trans: transNewList){
            if( trans.Amount__c<=0 )
                trans.Amount__c.addError('Amount can not be Negative or Zero');
        }
    }
}
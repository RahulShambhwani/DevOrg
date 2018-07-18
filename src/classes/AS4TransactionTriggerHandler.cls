public class AS4TransactionTriggerHandler {
    public static void getHighValOfEachHolder(List<AS4_Transaction__c> transNewList, Map<Id, AS4_Transaction__c> transOldMap){
        
        Set<Id> accHolderIdSet=new Set<Id>();
        List<AS4_Transaction__c> transUpdateList=new List<AS4_Transaction__c>();
        Map<Id, List<AS4_BAnk_Account_Holder__c>> bankMap=new Map<Id,List<AS4_BAnk_Account_Holder__c>>();
        Map<String, Id> maxTransactionMap=new Map<String, Id>();
        Map<Id, List<AS4_Transaction__c>> accHolderWithTransactionMap= new Map<Id, List<AS4_Transaction__c>>();
        
        if(transNewList != null){
            for(AS4_Transaction__c trans: transNewList){
                if(transOldMap==null || trans.Amount__c != transOldMap.get(trans.Id).Amount__c
                   || trans.Transaction_Date__c != transOldMap.get(trans.Id).Transaction_Date__c){
                    if(!accHolderIdSet.contains(trans.Account_Holder__c))
	                    accHolderIdSet.add(trans.Account_Holder__c);
                }
            }
        }
        
        else{
            if(transOldMap != null){										
                for(Id transId: transOldMap.keySet()){
                    accHolderIdSet.add(transOldMap.get(transId).Account_Holder__c);
                }
            }
        }
        
        
        for(AS4_Transaction__c trans: [SELECT Id, Bank_Account__c, Account_Holder__c, Amount__c 
                                       FROM AS4_Transaction__c 
                                       WHERE Account_Holder__c IN :accHolderIdSet 
                                       AND Transaction_Date__c = LAST_N_DAYS:7]){
                                           
                                           if(!accHolderWithTransactionMap.containsKey(trans.Account_Holder__c))
                                               accHolderWithTransactionMap.put(trans.Account_Holder__c, new List<AS4_Transaction__c>());
                                           accHolderWithTransactionMap.get(trans.Account_Holder__c).add(trans);
                                          
                                       }
        

        
        for(AS4_BAnk_Account_Holder__c accHolder: [SELECT Id, Bank_Account__c
                                                   FROM AS4_BAnk_Account_Holder__c 
                                                   WHERE Id IN :accHolderWithTransactionMap.keySet()]){
                                                       Integer maxAmountInLast7Days=0;
                                                       for(AS4_Transaction__c trans: accHolderWithTransactionMap.get(accHolder.Id)){
                                                           if(trans.Amount__c > maxAmountInLast7Days){
                                                               maxAmountInLast7Days = Integer.valueOf(trans.Amount__c);
                                                               maxTransactionMap.put(String.valueOf(accHolder.Bank_Account__c)
                                                                                     +String.valueOf(accHolder.Id), 
                                                                                     trans.Id);
                                                           }
                                                       }
                                                   }
        
        for(AS4_Transaction__c trans: [SELECT Id, Account_Holder__c, Bank_Account__c
                                       FROM AS4_Transaction__c 
                                       WHERE Account_Holder__c IN :accHolderIdSet]){
                                           
                                           String maxTransCheck=String.valueOf(trans.Bank_Account__c)
                                               +String.valueOf(trans.Account_Holder__c );
                                           
                                           if(maxTransactionMap.get(maxTransCheck) == trans.Id)
                                               trans.High_Val_Tran_in_Last_7_Days__c = true;
                                           else
                                               trans.High_Val_Tran_in_Last_7_Days__c = false;
                                           
                                           transUpdateList.add(trans);
                                       }
        if(transUpdateList.size()>0)
            update transUpdateList;
    }
}
@isTest
public class TestAS4TransactionTrigger {
    @isTest static void testMaxTransactionForAccHolder(){
        
       List<Asessment4_BankAccount__c> bankAccList=new List<Asessment4_BankAccount__c>();
       List<AS4_BAnk_Account_Holder__c> accHolderList=new List<AS4_BAnk_Account_Holder__c>();
        List<AS4_BAnk_Account_Holder__c> accHolderUpdatedList=new List<AS4_BAnk_Account_Holder__c>();
       List<AS4_Transaction__c> transList=new List<AS4_Transaction__c>();
       List<AS4_Transaction__c> transUpdatedList=new List<AS4_Transaction__c>(); 
        for(Integer i=0;i<2;i++){
            Asessment4_BankAccount__c bankAcc=new Asessment4_BankAccount__c();
            bankAccList.add(bankAcc);
        }
        
       insert bankAccList;
       
        
       for(Integer i=0;i<5;i++){
            AS4_BAnk_Account_Holder__c accHolder = new AS4_BAnk_Account_Holder__c(Name='AccHolder'+i);
            
            if(i/2==1)
                accHolder.Bank_Account__c = bankAccList.get(0).Id;
            else
                accHolder.Bank_Account__c = bankAccList.get(1).Id; 
           
           System.debug(accHolder);
           accHolderList.add(accHolder);
        }
        
        insert accHolderList;
        
        accHolderUpdatedList=[SELECT Id
                              FROM AS4_BAnk_Account_Holder__c
                              WHERE Id IN :accHolderList];
        
        for(Integer i=0;i<5;i++){
            AS4_Transaction__c trans=new AS4_Transaction__c();
            
            if(i/2==1){
                trans.Account_Holder__c = accHolderUpdatedList.get(0).Id;
                trans.Bank_Account__c = bankAccList.get(0).Id;
                trans.Amount__c = 10*i;
                trans.Transaction_Date__c = Date.newInstance(2018, 07, i-1);
            }
            else{
                trans.Account_Holder__c = accHolderUpdatedList.get(1).Id;
                trans.Bank_Account__c = bankAccList.get(1).Id;
                trans.Amount__c = 10*i;
                trans.Transaction_Date__c = Date.newInstance(2018, 07, i+1);
            }
            
            transList.add(trans);
            
        }
        
        insert transList;
        
        transUpdatedList=[SELECT Id, High_Val_Tran_in_Last_7_Days__c
                          FROM AS4_Transaction__c
                          WHERE Id IN :transList];
        System.debug(transUpdatedList);
        
//        for(Integer i=0;i<5;i++)
//            System.debug(transUpdatedList.get(i).High_Val_Tran_in_Last_7_Days__c);
        System.assertEquals(true, transUpdatedList.get(3).High_Val_Tran_in_Last_7_Days__c);
        System.assertEquals(true, transUpdatedList.get(2).High_Val_Tran_in_Last_7_Days__c);
        
        
    }
}
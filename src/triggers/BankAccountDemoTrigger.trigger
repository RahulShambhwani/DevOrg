trigger BankAccountDemoTrigger on Bank_Account__c (before insert, before update) {
	List<Bank_Account__c> bankAccList=new List<Bank_Account__c>();
    if(Trigger.isUpdate){
        for(Bank_Account__c bankAcc: Trigger.new){
            if(bankAcc.status__c=='Red')
                bankAcc.Next_Date__c=Date.newInstance(2019, 1, 1);
        }
    }
}
public class CusotmObjectDemo2 {
    public void Demo(){
        List<Transaction__c> transList=new List<Transaction__c>();
		for(Transaction__c trans: [SELECT Name, Bank_Account__c
                                   FROM Transaction__c 
                                   WHERE Transaction_Type__c='Credit']){
                                       trans.Amount__c=200;
                                       transList.add(trans);
                                   }
        if(transList.size()>0)
            UPDATE transList;
    }
}
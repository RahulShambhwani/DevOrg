public class CustomObjectDemo {
    public void updateRecord(){
        List<Bank_Account__c> bnkAccList=new List<Bank_Account__c>();
        for(Bank_Account__c bnkAcc: [SELECT Id, Account_Holder__r.Name, Account_Holder__r.Phone, Name
                                    FROM Bank_Account__c
                                    WHERE DOB_changed__c =true 
                                    LIMIT 2]){
           	bnkAcc.Email__c='a@b.com';
			//bnkAcc.Account_Holder__r.Phone='2313';                                        
            bnkAccList.add(bnkAcc);
            System.debug(bnkAcc.Name+' '+bnkAcc.Account_Holder__r.Name+' '
                         +bnkAcc.Account_Holder__r.Phone);
        }
        //UPDATE bnkAccList;
    }
}
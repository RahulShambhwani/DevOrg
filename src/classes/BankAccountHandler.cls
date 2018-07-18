public class BankAccountHandler {
    public static void updatePhone(List<Bank_Account__c> bankAccList, Map<Id,Bank_Account__c> bankAccMap){
		List<Bank_Account__c> bankAccList2=new List<Bank_Account__c>();
        for(Bank_Account__c bankAcc: bankAccList){
//            If(bankAccMap==null || bankAcc.Phone2__c!=bankAccMap.get(bankAcc.Id).Phone2__c){
				
            	bankAcc.Phone2__c='424';
            	bankAccList2.add(bankAcc);
  //          }
            	
        }
        if(bankAccList2.size()>0)
            Update bankAccList2;
    
    
        
    }
}
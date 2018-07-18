public class Qus6 {
    public void populateContactIdsonAccount(){
        List<Account> accList=[SELECT Id, Contact_Ids__c, (SELECT Id FROM Contacts) FROM Account];
        List<Account> accList2=new List<Account>();

        for(Account acc: accList){
            acc.Contact_Ids__c+='';

            for(Contact con: acc.Contacts){
                If(!acc.Contact_Ids__c.contains(''+con.Id)){
	                If(acc.Contact_Ids__c!=null)	
		                acc.Contact_Ids__c+=', '+con.Id;
        	        else
    	                acc.Contact_Ids__c=con.Id;
                }
                acc.Contact_Ids__c=acc.Contact_Ids__c.remove('null,');
            }

            accList2.add(acc);
        }
        
        if(accList2.size()>0)
            UPDATE accList2;
    }
}
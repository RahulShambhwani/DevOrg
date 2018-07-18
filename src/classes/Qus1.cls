public class Qus1 {
    public static void getContacts(Id accId){
        //List<Account> accList=new List<Account>();
 		for(Contact con: [SELECT Id, Name, AccountId
                          FROM Contact
                          WHERE AccountId=:accId]){
            	System.debug(con.Name);
        }
    }
}
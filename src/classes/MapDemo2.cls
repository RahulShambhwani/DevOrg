public class MapDemo2 {
    public void getRecords(){
        Set<Id> accountIdSet=new Set<Id>();
        Map<Id,Account> accMap=new Map<Id,Account>();
        for(Contact con: [SELECT Id, Name, AccountId
                          FROM Contact
                          WHERE Department='Appirio' 
                          AND AccountId != null]){
						  accountIdSet.add(con.AccountId); 
                          }
        Map<Id,List<Contact>> accountIdToContactMap=new Map<Id,List<Contact>>();
        for(Contact con: [SELECT Id,Name,accountId
                          FROM Contact
                          WHERE accountId IN :accountIdSet]){
                              If(!accountIdToContactMap.containsKey(con.accountId)){
                                  accountIdToContactMap.put(con.AccountId , new List<Contact>());
                              }
                              accountIdToContactMap.get(con.AccountId).add(con);
                          }
        /*
      for(Account acc: [SELECT Id,(SELECT Id,Name FROM Contacts)
                        FROM Account
                        WHERE Id IN :accountIdSet]){
                              If(!accountIdToContactMap.containsKey(acc.Id)){
                                  accountIdToContactMap.put(acc.id , new List<Contact>());
                              }
                              accountIdToContactMap.get(acc.Id).addAll(acc.Contacts);
                          }
	*/
        for(Id x: accountIdToContactMap.keySet()){
            for(Contact con2: accountIdToContactMap.get(x)){
                System.debug(con2);
            }
        }
    }
}
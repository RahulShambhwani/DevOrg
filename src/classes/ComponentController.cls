public class ComponentController {
    @auraEnabled
    public static List<Account> getAccountList(){
        return [SELECT Id, Name
                FROM Account 
                LIMIT 10];
    }
    @auraEnabled
    public static List<Contact> returnContactList(Id recordId){
        return [SELECT Id, Name, AccountId 
                FROM Contact 
                WHERE AccountId =:recordId];
    }
}
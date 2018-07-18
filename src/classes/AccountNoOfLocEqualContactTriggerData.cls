public class AccountNoOfLocEqualContactTriggerData {
    public static List<Account> insertionTest(){
        List<Account> accInsertList=new List<Account>();
        for(Integer i=0;i<5;i++){
            Account acc=new Account();
            acc.Name='Account '+i;
            acc.NumberofLocations__c=3;
            accInsertList.add(acc);
        }
        return accInsertList; 
    }
    
    public static List<Account> updationTest(){
        List<Account> accList=[SELECT Name, NumberofLocations__c, (SELECT Id FROM Contacts)  
                               FROM Account];
        List<Account> accupdateList=new List<Account>();
        Integer i=0;
        for(Account acc: accList){
            if(i/2==0)						// Changing 2nd & 4th account in account list
                acc.NumberofLocations__c=6;
            i++;
            accUpdateList.add(acc);
        }
        return accUpdateList;
    }
}
@isTest
private class TestAccountDeletion {
    @isTest static void testAccountDeletion(){
        
        List<Account> accList=new List<Account>();
        for(Integer i=0;i<10;i++){
            Account acc=new Account(name='testClass Account'+i);
            accList.add(acc);
        }
        insert accList;
        
        List<Opportunity> oppList=new List<Opportunity>();
        Integer y=0;
        for(Account acc: accList){
        oppList.add(new Opportunity(name='testClass opp'+y,
                                       CloseDate=System.today().addMonths(1),
                                        StageName='Prespective',AccountId=acc.Id));
            y++;
        }
        insert oppList;
        System.Test.startTest();
        Database.DeleteResult[] resultList= Database.delete(accList, false);
        System.Test.stopTest();
        
        
        for(Integer arr=0;arr<10;arr++)
            System.assert(!resultList[arr].isSuccess(),'Test Class Failed');
    }
}
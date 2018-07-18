public class CustomDemo {
    public void createRecord(){
        List<Account> accList=new List<Account>();
        for(Account acc: [SELECT Id,Name 
                          FROM Account 
                          WHERE Phone=null]){
            acc.Phone='323124';
            accList.add(acc);
            System.debug(acc.Id+' '+ acc.Name);
        }
        UPDATE accList;/*
        Account acc=new Account();
        acc.Name='Demo1';
        System.debug(acc);
        Insert acc;
		*/
    }
}
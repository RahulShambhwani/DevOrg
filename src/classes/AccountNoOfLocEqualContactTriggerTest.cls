@isTest
public class AccountNoOfLocEqualContactTriggerTest {
    @isTest static void testContactEqualsNoOfLoc(){
		List<Account> accInsertList=AccountNoOfLocEqualContactTriggerData.insertionTest();
        if(accInsertList.size()>0)
            insert accInsertList;
        
        
        List<Account> insertedAccList=[SELECT Name, NumberofLocations__c, (SELECT Id FROM Contacts)
                                       FROM Account];
        
        //Insert Test
        for(Account acc: insertedAccList)
        	System.assertEquals(3, acc.Contacts.size(), ' Must be 3');

        
        List<Account> accUpdateList=AccountNoOfLocEqualContactTriggerData.updationTest();
        if(accUpdateList.size()>0){
            System.debug('Updating '+ accUpdateList.size());
            update accUpdateList;
        }
		            
        List<Account> updatedAccList=[SELECT Name, NumberofLocations__c, (SELECT Id FROM Contacts)
                                       FROM Account];

		//Update Test
        Integer i=0;
        for(Account acc: updatedAccList){
            if(i/2==0)
	        	System.assertEquals(6, acc.Contacts.size(), ' Must be 6');   
        	 //System.debug('Print '+ acc.Contacts.size());
        	i++;
        }
        
    } 
}
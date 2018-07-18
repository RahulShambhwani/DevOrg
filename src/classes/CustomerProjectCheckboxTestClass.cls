@isTest
private class CustomerProjectCheckboxTestClass {
    @isTest static void testActiveProjec(){
		List<Customer_Project__c> custList=new List<Customer_Project__c>();
		List<Opportunity> oppList=new List<Opportunity>();
        for(Integer i=0;i<5;i++){
			Opportunity opp=new Opportunity();
			opp.Name='Opportunity '+i;
            opp.CloseDate=Date.today();
            opp.StageName='Closed Won';
            oppList.add(opp);
        }
        insert oppList;
		Integer i=0;
        for(Opportunity opp: oppList){							// Opportunities with active project Insert
            Customer_Project__c cust=new Customer_Project__c();
            cust.Name='Project '+i;
            if(i/2==0)
	            cust.Status__c='Active';
            else
                cust.Status__c='Inactive';
            cust.Opportunity__c=opp.Id;
            custList.add(cust);
            i++;
            System.debug(opp.Active_Customer_project__c);
        }
        insert custList;
        
        i=0;
        for(Opportunity opp: [SELECT Active_Customer_project__c 
                              FROM Opportunity 
                              WHERE Id IN :oppList]){
                                  if(i/2==0)
	                                  System.assertEquals(true, opp.Active_Customer_project__c , 'Should be Active');
                                  else
                                      System.assertEquals(false, opp.Active_Customer_project__c , 'Should be Inactive');
                                  i++; 
                              }
            
	    }
}
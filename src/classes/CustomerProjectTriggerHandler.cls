public class CustomerProjectTriggerHandler {
    public static void checkActiveOpportunity(List<Customer_Project__c> custNewList, Map<Id,Customer_Project__c> custOldMap){
        
        Set<Id> oppIdSet=new Set<Id>();
		Set<Id> custDeleteIdSet=new Set<Id>();        
        Set<Id> custActiveIdSet=new Set<Id>();
        Set<Id> custInactiveIdSet=new Set<Id>();
        List<Opportunity> oppUpdateActiveInactiveList=new List<Opportunity>();
        List<Opportunity> oppCheckboxNoneList=new List<Opportunity>();
        if(custNewList!=null){
            for(Customer_Project__c cust: [SELECT Id, Status__c, Opportunity__c
                                           FROM Customer_Project__c
                                           WHERE Id IN :custNewList]){
                                               if(custOldMap==null || (custOldMap.get(cust.Id).Opportunity__c!=cust.Opportunity__c)){
                                                      oppIdSet.add(cust.Opportunity__c);		// New Opportunity active project= true
                                                      if(custOldMap!=null)						
                                                          oppIdSet.add(cust.Opportunity__c); // Old Opportunity because active pro will false
                                                      if(cust.Status__c=='Active')
                                                          custActiveIdSet.add(cust.Opportunity__c);				// Active Customer
                                                      else
                                                          custInactiveIdSet.add(cust.Opportunity__c);			// Inactive Customer
                                                      System.debug('Active/Inactive');
                                                  }
                                               
                                           }
        }
        
        else{
            for(Customer_Project__c cust: [SELECT Opportunity__c 
                                           FROM Customer_Project__c
                                           WHERE Id IN :custOldMap.keySet()]){
                                               oppIdSet.add(cust.Opportunity__c);
                                               custInactiveIdSet.add(cust.Opportunity__c);
                                               System.debug('Delete');
                                           }
        }
        
        
        for(Opportunity opp: [SELECT Id, Active_Customer_project__c
                              FROM Opportunity 
                              WHERE Id IN :oppIdSet]){
                                  System.debug('Inside');
                                  if(custActiveIdSet.contains(opp.Id)){
                                      Opp.Active_Customer_project__c=true;
                                      oppUpdateActiveInactiveList.add(opp);
                                      System.debug('Opp true');
                                  }
                                  if(custInactiveIdSet.contains(opp.Id)){
                                      opp.Active_Customer_project__c=false;
                                      oppUpdateActiveInactiveList.add(opp);
                                      System.debug('Opp false');
                                  }
                              }
        if(oppUpdateActiveInactiveList.size()>0)
			update oppUpdateActiveInactiveList;            
    }
}
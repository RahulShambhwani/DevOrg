public class AccountTriggerHandler {
    public static void populateShippingAddress(List <Account> newList, Map<Id,Account> oldMap){

     	    for(Account acc: newList){
                if(acc.Same_as_Shipping__c){
                    if( oldMap==null || (acc.Same_as_Shipping__c!=oldMap.get(acc.Id).Same_as_Shipping__c ||
                            acc.BillingPostalCode!=oldMap.get(acc.Id).ShippingPostalCode ||
                            acc.BillingStreet!=oldMap.get(acc.Id).ShippingStreet ||
                            acc.BillingCity!=oldMap.get(acc.Id).ShippingCity ||
                            acc.BillingState!=oldMap.get(acc.Id).shippingState||
                           	acc.BillingCountry!=oldMap.get(acc.Id).ShippingCountry)){
                                
                       		acc.BillingPostalCode=acc.ShippingPostalCode;    
                            acc.BillingStreet=acc.ShippingStreet;
                            acc.BillingCity=acc.ShippingCity;
                            acc.BillingState=acc.ShippingState;
                           	acc.BillingCountry=acc.ShippingCountry;
                     }
				}        

    		}

        
    }
    

    public static void populateFavoriteColor(List<Account> newList){
	    Set<Id> userIdSet=new Set<Id>();
        for(Account acc: newList){
            userIdSet.add(acc.OwnerId);
        }
        Map<Id,String> userIdtoColorMap=new Map<Id,String>();

        for(User usr: [SELECT Id, Color__c
                       FROM User
                       WHERE Id IN :userIdSet
                       AND Color__c!=NULL]){
                           userIdtoColorMap.put(usr.Id, usr.Color__c);
                       }
        for(Account acc: newList){
            if(userIdtoColorMap.containsKey(acc.OwnerId)){
                acc.Favorite_color__c=userIdtoColorMap.get(acc.OwnerId);
            }
        }
    }
    
    public static void updateSLA(List<Account> newList){
       	List<Account> accList=new List<Account>();
    	for(Account acc: newList){
            Account a=new Account();
            a.Id=acc.Id;
           // if(acc.SLAExpirationDate__c==null)
             //   acc.SLAExpirationDate__c=Date.today();
            a.SLAExpirationDate__c=acc.SLAExpirationDate__c.addDays(90);
            accList.add(a);
	    }
        Constants.updateSLADate=false;
	    update accList;	
    }
    
        public static void restrictDeletionOnSingleContact(List<Account> accNewList, List<Account> accOldList){
		//Map<Id,List<Contact>> accMap=new Map<Id,List<Contact>>();
        if(accNewList==null){
            for(Account acc: [SELECT Id, (SELECT Id FROM Contacts)
                              FROM Account 
                              WHERE Id IN :accOldList]){
                                  if(acc.Contacts.size()==1){
                                      //Account accTemp=new Account();
                                      //accTemp.Id=acc.Id;
                                      acc.addError('Account has only one contacts so it can not delete');
                                  }
            }
        }
    }
    
    
    public static void trackAccountDeletion(Map<Id,Account> accOldMap){
        if(accOldMap!=null){
            List<Tracking__c> trackList=new List<Tracking__c>();
            for(Account acc: [SELECT Id, Name
                              FROM Account
                              WHERE ID IN :accOLdMap.keySet()]){
                                  Tracking__c track=new Tracking__c();
                                  track.Name=acc.Name;
                                  track.Object__c='Account';
                                  track.Deleted_By__c=UserInfo.getFirstName()+' '+UserInfo.getLastName();
                                  trackList.add(track);
                              }
            if(trackList.size()>0)
	            Insert trackList;
        }
    }
    
    public static void getParentAccountFromAccount(Map<Id,Account> accNewMap){

		Set<Id> parentAccIdSet=new Set<Id>();
        Map<Id,List<Account>> parentAccMap=new Map<Id,List<Account>>();
        for(Account acc: [SELECT Id, ParentId
                          FROM Account
                          WHERE parentId IN :accNewMap.keySet()
                          AND ParentId !=null]){
                              if(!parentAccMap.containsKey(acc.Id))
	                              parentAccMap.put(acc.parentId, new List<Account>());
                          }
        
                for(Account acc: [SELECT Id 
                          FROM Account 
                          WHERE Id IN :parentAccMap.keySet()]){
                              parentAccMap.get(acc.Id).add(acc);
                          }
        
        
        List<AccountShare> accShareList=new List<AccountShare>();        
		for(Account acc: [SELECT Id, OwnerId 
                          FROM Account
                          WHERE parentId IN :parentAccMap.keySet()]){
                              for(Id insertedAccId: accNewMap.keySet()){
                                  AccountShare accShare=new AccountShare();
                                  accShare.AccountId=insertedAccId;
                                  accShare.AccountAccessLevel='Read';
                                  accShare.CaseAccessLevel='Read';
                                  accShare.OpportunityAccessLevel='Read';
                                  accShare.UserOrGroupId=acc.OwnerId;								
                                  accShareList.add(accShare);
                              }
        }
        System.debug(parentAccMap.values());
        if(accShareList.size()>0)
            Database.insert(accShareList,true);
    }
    
    public static void preventDuplicateAccounts(List<Account>accNewList, Map<Id,Account> accOldMap){
        Set<Id> accIdSet=new Set<Id>();
        Set<String> accNameSet=new Set<String>();
        List<Account> accList=new List<Account>();
        for(Account acc: [SELECT Name
                          FROM Account]){
                              accNameSet.add(acc.Name);
                              System.debug(acc.Name);
                          }

        
        for(Account acc: [SELECT Id, Name 
                          FROM Account 
                          WHERE Id IN :accNewList]){
                              if(accNameSet.contains(acc.Name))						
                                  acc.addError('Account with this name already exists');	// Exception Cannot add error to sobject
                              else
                                  accList.add(acc);
                              System.debug('<<<>>>');
                          }
        if(accList.size()>0)
            update accList;
    }
    
    public static void createContactsEqualToNoOfLocations(List<Account> accNewList, Map<Id,Account> accOldMap){
		Set<Id> accInsertIdSet=new Set<Id>();
        Set<Id> accUpdateIdSet=new Set<Id>();
        List<Contact> conDeleteList=new List<Contact>();
        List<Contact> conInsertList=new List<Contact>();
        List<Contact> conUpdateList=new List<Contact>();
        
        for(Account acc: [SELECT Id, NumberofLocations__c 
                          FROM Account 
                          WHERE Id IN :accNewList]){
								//System.debug('initial');
                              if(accOldMap==null)
                                  accInsertIdSet.add(acc.Id);
                              else if(acc.NumberofLocations__c!=accOldMap.get(acc.Id).NumberofLocations__c)
                                  accUpdateIdSet.add(acc.Id);
                                
                          }
        //Map<Id,Integer> accRelatedContactsCountMap=new Map<Id,Integer>();
        for(Account acc: [SELECT Id, NumberofLocations__c
                          FROM Account 
                          WHERE Id IN :accInsertIdSet]){
                              
                              
                              for(Integer i=0;i<acc.NumberofLocations__c;i++){
                                  Contact con=new Contact();
                                  con.LastName='Contact'+i;
                                  con.AccountId=acc.Id;	
                                  conInsertList.add(con);
                                  
                              }
                          }
        for(Account acc: [SELECT Id, NumberofLocations__c,  (SELECT Id FROM Contacts)
                          FROM Account 
                          WHERE Id IN :accUpdateIdSet]){
                              //System.debug('<<<<>>>>');
                             // accRelatedContactsCountMap.put(acc.Id,acc.Contacts.size());
                             
                              if(accOldMap.get(acc.Id).NumberofLocations__c==null){
                                  Integer contactsToBeCreated= Integer.valueOf(acc.NumberofLocations__c);
                                  for(Integer i=0; i<contactsToBeCreated; i++){
                                      //Integer contactNameCount=(Integer)accOldMap.get(acc.Id).NumberofLocations__c + i;
                                      Contact con=new Contact();
                                      con.LastName='Contact'+ i;
                                      con.AccountId=acc.Id;
                                      conInsertList.add(con);
                                      //System.debug('Creting contact >'+contactNameCount);
                                  }
                                  
                              }
                                  
                              else if(acc.NumberofLocations__c > accOldMap.get(acc.Id).NumberofLocations__c ){
                                  
                                  Integer contactsToBeCreated= Integer.valueOf(acc.NumberofLocations__c - accOldMap.get(acc.Id).NumberofLocations__c);
                                  //System.debug(contactsToBeCreated);
                                  for(Integer i=0; i<contactsToBeCreated; i++){
                                      Integer contactNameCount=(Integer)accOldMap.get(acc.Id).NumberofLocations__c + i;
                                      Contact con=new Contact();
                                      con.LastName='Contact'+ contactNameCount;
                                      con.AccountId=acc.Id;
                                      conInsertList.add(con);
                                      //System.debug('Creting contact >'+contactNameCount);
                                  }
                              }
                              else{
                                   Integer contactsToBeDeleted=0;
                                  if(accOldMap.get(acc.Id).NumberofLocations__c!=null)
	                                  contactsToBeDeleted=Integer.valueOf(Math.abs( accOldMap.get(acc.Id).NumberofLocations__c - acc.NumberofLocations__c));
                                  

                                  for(Integer i=0; i<contactsToBeDeleted; i++){
	                                      conDeleteList.add(acc.Contacts[i]);
                                      //System.debug('Delete Con');
                                  }
                              }
                          }
        if(conInsertList.size()>0)
            insert conInsertList;
        if(conDeleteList.size()>0)
            delete conDeleteList;
    }
    
    public static void updateCheckboxOnAccountCheckbox(List<Account> accNewList, Map<Id,Account> accOldMap){
        Set<Id> accIdSet=new Set<Id>();
        Map<Id,Account> accMap=new Map<Id,Account>();
        List<Contact> conUpdatedList=new List<Contact>();
        if(accNewList!=null){
            for(Account acc: accNewList){
                if(accOldMap==null || acc.ContactCheckbox__c != accOldMap.get(acc.Id).ContactCheckbox__c){
                    if(acc.ContactCheckbox__c)
	                    accMap.put(acc.Id, acc);
                    else if(acc.ContactCheckbox__c != accOldMap.get(acc.Id).ContactCheckbox__c)
                        accMap.put(acc.Id, acc);
                }
            }
        }
        else{
            if(accOldMap != null){
                for(Account acc: accOldMap.values()){
                    accMap.put(acc.Id,acc);
                }
            }
        }
        
        for(Contact con: [SELECT Id, AccountId, ContactCheckbox__c
                          FROM Contact
                          WHERE AccountId IN :accMap.keySet()]){
                              con.ContactCheckbox__c=accMap.get(con.AccountId).ContactCheckbox__c;
                              conUpdatedList.add(con);
                          }
        if(conUpdatedList.size() > 0)
            update conUpdatedList;
    }
    
    
}
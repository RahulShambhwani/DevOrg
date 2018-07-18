public class ContactTriggerHandler {
    public static void updatePhoneofBankAccount(List<Contact> newList, Map<Id,Contact> oldMap){
        Set<Id> conIdSet=new Set<Id>();
        //Map<Id,Bank_Account__c> bankAccMap=new Map<Id,Bank_Account__c>();
        List<Bank_Account__c> bankAccList=new List<Bank_Account__c>();
        for(Contact con: newList){
            if(con.Phone != oldMap.get(con.Id).Phone)
                conIdSet.add(con.Id);
        }
        for(Contact con: [SELECT Id, Phone, (SELECT Id, Phone2__c FROM Bank_Accounts__r)
                          FROM Contact
                          WHERE Id IN :conIdSet]){
                              for(Bank_Account__c bankAcc: con.Bank_Accounts__r){
                                  bankAcc.Phone2__c=con.Phone;
                                  bankAccList.add(bankAcc);
                              }
                          }
        if(bankAccList.size()>0)
            update bankAccList;
    }
    
    public static void trackContactDeletion(Map<Id,Contact> conOldMap){
        if(conOldMap!=null){
            List<Tracking__c> trackList=new List<Tracking__c>();
            for(Contact con: [SELECT Id, Name
                              FROM Contact
                              WHERE ID IN :conOLdMap.keySet()]){
                                  Tracking__c track=new Tracking__c();
                                  track.Name=con.Name;
                                  track.Object__c='Contact';
                                  track.Deleted_By__c=UserInfo.getFirstName()+' '+UserInfo.getLastName();
                                  trackList.add(track);
                              }
            if(trackList.size()>0)
                Insert trackList;
        }
    }
    
    
    public static void createUserOnContactInsertion(List<Contact> conNewList){
        
        List<User> usrList=new List<User>();
        List<Account> accList=new List<Account>();
        for(Contact con: conNewList){
            Account acc=new Account();
            //acc.Id=con.AccountId;
            acc.Name='Account1';
            acc.AnnualRevenue=100000;
            User us = new User(Alias = 'standt', Email='standarduser@testorg.com',
                               EmailEncodingKey='UTF-8', LastName='Testing User', LanguageLocaleKey='en_US',
                               LocaleSidKey='en_US', ProfileId = '00e7F000002sA20',
                               TimeZoneSidKey='America/Los_Angeles',
                               Username=con.Email, CommunityNickname='xyz');
            
            usrList.add(us);
            accList.add(acc);
        }
        if(usrList.size()>0)
            insert usrList;
        if(accList.size()>0)
            insert accList;
        
    }
    
    
    
    @future
    public static void createUserOnContactInsertionFuture(String lName, String email){
        
        List<User> usrList=new List<User>();
        for(Contact con: [SELECT LastName, Email
                          FROM Contact
                          WHERE Email =:email]){
                              User us = new User(Alias = 'standt2', Email='standarduser2@testorg.com',
                                                 EmailEncodingKey='UTF-8', LastName='Testing User2', LanguageLocaleKey='en_US',
                                                 LocaleSidKey='en_US', ProfileId = '00e7F000002sA20',
                                                 TimeZoneSidKey='America/Los_Angeles',
                                                 Username=con.Email, CommunityNickname='xyz2');
                              
                              usrList.add(us);
                          }
        if(usrList.size()>0)
            insert usrList;
        
    }
    
    public static void duplicateContactExtended(List<Contact> conNewList, Map<Id,Contact> conOldMap){
        Set<String> conUniqueSet=new Set<String>();
        Set<Id> accIdSet=new Set<Id>();
        List<Contact> conUpdateList=new List<Contact>();
        
        Map<String,Contact> uniqueContactMap=new Map<String, Contact>();
        Map<String,List<Contact>> conMap=new Map<String, List<Contact>>();
        if(conNewList!=null){
            for(Contact con: [SELECT Id, FirstName, LastName, Email, AccountId
                              FROM Contact
                              WHERE Id IN :conNewList]){
                                  String uniqueRecord=con.FirstName+con.LastName+con.Email+con.AccountId;
                                  if(conOldMap==null || con.AccountId!=conOldMap.get(con.Id).AccountId){
                                      if(!uniqueContactMap.containsKey(uniqueRecord)){
                                          uniqueContactMap.put(uniqueRecord, con);
                                          accIdSet.add(con.AccountId);
                                      }
                                      
                                  }
                                  
                              }
        }
        
        for(Contact con: [SELECT Id, FirstName, LastName, Email, AccountId
                          FROM Contact 
                          WHERE AccountId !=NULL]){
                              String uniqueContact=con.FirstName+con.LastName+con.Email+con.AccountId;
                              if(!conMap.containsKey(uniqueContact))
                                  conMap.put(uniqueContact, new List<Contact>());
                              conMap.get(uniqueContact).add(con);
                          }
        for(String uniqueStr: conMap.keySet()){
            List<Contact> conList=conMap.get(uniqueStr);
            if(conMap.get(uniqueStr).size()>1){
                for(Contact con: conList){
                    con.Duplicate_Record__c=true;
                    conUpdateList.add(con);
                    
                }
            }
            
        }
        if(conUpdateList.size()>0)
            update conUpdateList;
    }
    
    public static void rollupAmount(List<Contact> conNewList, Map<Id,Contact> conOldMap){
        Set<Id> accIdSet=new Set<Id>();
        List<Account> accUpdateList=new List<Account>();
        Map<Id, List<Contact>> accMap=new Map<Id,List<Contact>>();
        if(conNewList != null){
            for(Contact con:conNewList){
                if(conOldMap == null || con.AccountId != conOldMap.get(con.Id).AccountId
                   || con.Amount_X__c !=conOldMap.get(con.Id).Amount_X__c
                   || con.Amount_Y__c != conOldMap.get(con.Id).Amount_Y__c){
                       accIdSet.add(con.AccountId);
                       if(conOldMap != null && con.AccountId != conOldMap.get(con.Id).AccountId)
                           if(!accIdSet.contains(conOldMap.get(con.Id).AccountId))
                           accIdSet.add(conOldMap.get(con.Id).AccountId);
                   }
            }
        }
        else{
            //if(conOldMap != null){
            for(Contact con: [SELECT Id, AccountId 
                              FROM Contact
                              WHERE Id IN :conOldMap.keySet()]){
                                  if(!accIdSet.contains(con.AccountId))
                                      accIdSet.add(con.AccountId);
                                  System.debug('Delete');
                              }
            //}
        }
        
        for(Account acc: [SELECT Id, Rollup_Amount__c, Rollup_Amount_X__c, Rollup_Amount_Y__c, (SELECT Id, Amount_X__c, Amount_Y__c FROM Contacts)
                          FROM Account 
                          WHERE Id IN :accIdSet]){
                              Integer sumAmountX,sumAmountY;
                              sumAmountX=0;sumAmountY=0;
                              System.debug('Going>> ');
                              for(Contact con: acc.Contacts){
                                  if(con.Amount_X__c==null)
                                      con.Amount_X__c=0;
                                  if(con.Amount_Y__c==null)
                                      con.Amount_Y__c=0;
                                  sumAmountX+=(Integer)con.Amount_X__c;
                                  sumAmountY+=(Integer)con.Amount_Y__c;
                              }	
                              acc.Rollup_Amount_X__c=sumAmountX;
                              acc.Rollup_Amount_Y__c=sumAmountY;
                              acc.Rollup_Amount__c=acc.Rollup_Amount_X__c + acc.Rollup_Amount_Y__c;
                              accUpdateList.add(acc);
                          }
        if(accUpdateList.size()>0)
            update accUpdateList;
    }
    
    public static void updateAccountOnContactUpdate(List<Contact> conNewList, Map<Id,Contact> conOldMap){
        Set<Id> accIdSet=new Set<Id>();
        List<Contact> conList=new List<Contact>();
        Map<Id,String> accUpdateNameMap=new Map<Id,String>();
        Map<Id,Integer> accUpdateCountMap=new Map<Id,Integer>();
        List<Account> accUpdatedList=new List<Account>();
        List<Account> accUpdateCountList=new List<Account>();
        System.debug('<<>>');
        if(conNewList !=null){
            for(Contact con: conNewList){
                                  if(conOldMap == null || con.Name != conOldMap.get(con.Id).Name){
                                      System.debug('Name Updated');
                                      conList.add(con);
                                      String updateName='';
                                      accIdSet.add(con.AccountId);
                                      if(!accUpdateNameMap.containsKey(con.AccountId))
	                                      accUpdateNameMap.put(con.AccountId, '');
                                      updateName+=accUpdateNameMap.get(con.AccountId);
                                      accUpdateNameMap.put(con.AccountId,updateName);
                                  }
                              }
        }
        for(Account acc: [SELECT Id, Contact_Name__c, NumberOfConUpdated__c
                          FROM Account
                          WHERE Id IN :accUpdateNameMap.keySet()]){
                              acc.Contact_Name__c=accUpdateNameMap.get(acc.Id);
                              acc.NumberOfConUpdated__c=conList.size();
                              accUpdatedList.add(acc);
                          }
        if(accUpdatedList.size()>0)
            update accUpdatedList;
    }
/*        for(Contact con: [SELECT Id, Name, AccountId
                          FROM Contact
                          WHERE Id IN :conList]){
                              
                              Account acc=new Account();
                              acc.Id=con.AccountId;
                              acc.Contact_Name__c+=con.Name+', ';
                              if(acc.NumberOfConUpdated__c==null)
                                  acc.NumberOfConUpdated__c=0;
                              acc.NumberOfConUpdated__c+=1;
                              accUpdatedList.add(acc);
                          }
*/
/*        for(Account acc: [SELECT Id, Name, (SELECT Id, Name FROM Contacts)
                          FROM Account
                          WHERE Id IN :accIdSet]){
                              String updateName='';
                              Integer updateCount=0;
                              for(Contact con: acc.Contacts){
                                  updateName+=con.Name;
                                  updateCount+=1;
                              }
                              acc.Contact_Name__c=updateName;
                              acc.NumberOfConUpdated__c=updateCount;
                              accUpdatedList.add(acc);
                          }
*/
    
}
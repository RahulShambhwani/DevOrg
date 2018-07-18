public class DeleteStrykerContacts {
  
       
       public void deleteRecord()
   {
       List<Contact> accList =[SELECT id
                       			FROM Contact 
                       			WHERE Name LIKE '%United%'];
       
       if(accList.size()>0)
       {
           delete accList;
           //System.debug('');
       }
   }
}
public class UniqueContactTriggerHandler {
    public static void UniqueContact(List<Contact> conList, Map<Id,Contact> oldMap){
		Set<String> fNameSet=new Set<String>();
		Set<String> lNameSet=new Set<String>();
        Set<Date> dobSet=new Set<Date>();
        Set<String> emailSet=new Set<String>();
        Set<String> uniqueRecordSet=new Set<String>();
        
        for(Contact con1: conList){
            if(oldMap==null || con1.FirstName!=oldMap.get(con1.Id).FirstName ||
               con1.LastName!=oldMap.get(con1.Id).LastName ||
               con1.Email!=oldMap.get(con1.Id).Email ||
               con1.Birthdate!=oldMap.get(con1.Id).Birthdate){
		            fNameSet.add(con1.FirstName);
                    lNameSet.add(con1.LastName);
                    dobSet.add(con1.Birthdate);
                    emailSet.add(con1.Email);
               }
        }
        
        for(Contact con2: [SELECT Id,FirstName, LastName, Birthdate, Email
                           FROM Contact
                           WHERE FirstName IN :fNameSet AND
                           LastName IN :lNameSet AND
                           Birthdate IN :dobSet AND
                           Email IN :emailSet]){
                               uniqueRecordSet.add(con2.FirstName+''+con2.LastName+''+con2.Birthdate+''+con2.Email);
                           }
        
        for(Contact con3: conList){
            String uniqueRecord=con3.FirstName+''+con3.LastName+''+con3.BirthDate+''+con3.Email;
            
            if(uniqueRecordSet.contains(uniqueRecord))
                con3.addError('Duplicate Records');
            else
                uniqueRecordSet.add(uniqueRecord);
        }
        
    }
}
			//con.Description='dasda';
/*			if(con.FirstName==oldMap.get(con.Id).FirstName &&
               con.LastName==oldMap.get(con.Id).LastName &&
               con.Birthdate==oldMap.get(con.Id).Birthday &&
               con.Email==oldMap.get(con.Id).Email)
*/
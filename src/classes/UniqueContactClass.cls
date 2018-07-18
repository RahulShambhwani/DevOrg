public class UniqueContactClass {
    public void getUniqueContact(){
		
        Map<String,Contact> conMap=new Map<String, Contact>();

        List<Contact> conList=[SELECT Id, FirstName,LastName,Birthdate,Email FROM Contact];
        List<Contact> conList2=new List<Contact>();
		Set<String> uniqueRecordSet=new Set<String>();

        
        //Checkbox checks only duplicate not original one
        for(Contact con: conList){
            String uniqueRecord=con.FirstName+con.LastName+String.valueOf(con.Birthdate)+con.Email;
            if(!conMap.containsKey(uniqueRecord)){
	            conMap.put(uniqueRecord,con);
                uniqueRecordSet.add(uniqueRecord);
            }
            else{
                con.Duplicate_Record__c=true;
                conList2.add(con);
            }
/*            if(conMap.containsKey(uniqueRecord) && conList.contains(con)){    
                con.Duplicate_Record__c=true;
                conList2.add(con);
            }    
*/
        }
        if(conList2.size()>0)
            Update conList2;
        System.debug(conList2.size());
    }
}
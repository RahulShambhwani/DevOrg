@isTest
public class TestCopyAddress {
    
    @testSetup static void testCopyAddress(){
        List<Contact> conList=new List<Contact>();
        for(Integer i=0;i<20;i++){
            Contact con=new Contact(LastName='TestContact', MailingCity='TestCity', MailingCountry='TestCountry');
            conList.add(con);       
        }
        insert conList;
    }
    
    @isTest static void testCopyAddressForInsert(){
        
		Integer count=0;
        List<Contact> conList1=[SELECT MailingCity, MailingCountry 
                      			FROM Contact];
        for(Contact con1: conList1){
	        con1.MailingCity='abcd'+count;
            con1.MailingCountry='xyz'+count;
        }
        update conList1;        
        count++;
    }
    
    @isTest static void testCopyAddressForUpdate(){
        List<Contact> conList2=[SELECT OtherCity, OtherCountry, MailingCity, MailingCountry
                      FROM Contact];
        for(Contact con2: conList2){
            System.assertEquals(con2.OtherCity, con2.MailingCity,'Test Class Failed');
            System.assertEquals(con2.OtherCountry, con2.OtherCountry,'Test Class Failed');
        }
    }
}
@isTest
public class TestLocationJunction {
    
    
    @isTest static void testUniqueLocation(){
        List<Opportunity> oppInsertList=new List<Opportunity>();
        List<Location> locInsertList=new List<Location>();
        for(Integer i=0;i<5;i++){
             oppInsertList.add(new Opportunity(Name='TestOpp'+i, CloseDate=Date.today(), StageName='Closed Won'));
        }
    }
}
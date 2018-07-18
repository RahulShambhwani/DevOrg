public class Assesment3TriggerHandler {
    public static void createCompanyReport(List<Assessment3_Sales__c> saleNewList, Map<Id,Assessment3_Sales__c> saleOldMap){
        Map<Id,List<Assessment3_Sales__c>> exeMap=new Map<Id,List<Assessment3_Sales__c>>();
        Map<String,Id> uniqueReportMap=new Map<String,Id>();
        Map<String,Integer> companyMap=new Map<String, Integer>();
        Map<String,Integer> quarterMap=new Map<String, Integer>();
		List<Assessment3_Company_Report__c> reportInsertList=new List<Assessment3_Company_Report__c>();
        List<Assessment3_Company_Report__c> reportUpdateList=new List<Assessment3_Company_Report__c>();
		Set<Id> exeIdSet=new Set<Id>();       
        Set<String> quarterSet=new Set<String>();
        Set<Id> companyIdSet=new Set<Id>();
        String companyId,year;
        Integer quarterSale1,quarterSale2,quarterSale3,quarterSale4;
        Integer noOfExecutives=0;
        quarterSale1=0;quarterSale2=0;quarterSale3=0;quarterSale4=0;

        if(saleNewList!=null){
            for(Assessment3_Sales__c sale: saleNewList){               
                    if(saleOldMap==null || sale.Sale_Amount__c != saleOldMap.get(sale.Id).Sale_Amount__c){
                        System.debug('Insert/Update');
                        if(!exeIdSet.contains(sale.Executive__c))
                            exeIdSet.add(sale.Executive__c);
                    }
                }
        }
        System.debug('start');
        for(Assessment3_Executive__c exe: [SELECT Id, Company__c 
                                           FROM Assessment3_Executive__c 
                                           WHERE Id IN :exeIdSet]){
                                               companyIdSet.add(exe.Company__c);
                                               System.debug('fatching company Id '+exe.Company__c);
                                           }
            
        for(Assessment3_Executive__c exe: [SELECT Id, Company__c, Year__c, (SELECT Id, Quarter__c, Sale_Amount__c FROM Assessment3_Sales__r)
                                           FROM Assessment3_Executive__c
                                           WHERE Company__c IN :companyIdSet]){
                                               System.debug('Executive  '+ exe);
                                               for(Assessment3_Sales__c sale: exe.Assessment3_Sales__r){
                                                   System.debug('fatching Sales >> '+ sale.Quarter__c);
                                                   
                                                   if(sale.Quarter__c == 'Q1')
                                                       quarterSale1+=(Integer)sale.Sale_Amount__c;
                                                   else if(sale.Quarter__c=='Q2')
                                                       quarterSale2+=(Integer)sale.Sale_Amount__c; 
                                                   else if(sale.Quarter__c=='Q3')
                                                       quarterSale3+=(Integer)sale.Sale_Amount__c;
                                                   else if(sale.Quarter__c=='Q4')
                                                       quarterSale4+=(Integer)sale.Sale_Amount__c;
                                                   
                                                   if(!quarterSet.contains(sale.Quarter__c))
                                                       quarterSet.add(sale.Quarter__c);
                                                   //if(!quarterMap.containsKey(sale.Quarter__c+exe.Year__c))
                                                       //quarterMap.put(sale.Quarter__c+exe.Year__c, )
                                               }
                                               
                                               companyId=exe.Company__c;
                                               year=exe.Year__c;
                                               noOfExecutives++;
                                           }
        
        for(Assessment3_Company_Report__c report: [SELECT Id, Company__c, Year__c, Quater__c
                                                   FROM Assessment3_Company_Report__c 
                                                   WHERE Company__c IN :companyIdSet]){
                                                       String uniqueReport=report.Company__c+report.Quater__c+report.Year__c;
                                                       if(!uniqueReportMap.containsKey(uniqueReport))
                                                           uniqueReportMap.put(uniqueReport, report.Id);
                                                       
                                                   }
        
        for(String str: quarterSet){
            System.debug('Creating report');
            Assessment3_Company_Report__c report=new Assessment3_Company_Report__c();
			report.Company__c=companyId;
            report.Year__c=year;
            report.Quater__c=str;
            if(str=='Q1' && quarterSale1>0)
                    report.Average_Sale__c=(quarterSale1)/noOfExecutives;
            else if(str=='Q2' && quarterSale2>0)
                    report.Average_Sale__c=(quarterSale2)/noOfExecutives;
            else if(str=='Q3' && quarterSale3>0)
                    report.Average_Sale__c=(quarterSale3)/noOfExecutives;
            else if(str=='Q4' && quarterSale1>0)
                    report.Average_Sale__c=(quarterSale4)/noOfExecutives;
            
        String uniqueReport=report.Company__c+report.Quater__c+report.Year__c;
        if(uniqueReportMap.containsKey(uniqueReport)){
            report.Id=uniqueReportMap.get(uniqueReport);
            reportUpdateList.add(report);
        }
         else
             reportInsertList.add(report);
        }
        System.debug(reportInsertList.size());
        if(reportInsertList.size()>0)
            insert reportInsertList;
        if(reportUpdateList.size()>0)
            update reportUpdateList;
    }
}
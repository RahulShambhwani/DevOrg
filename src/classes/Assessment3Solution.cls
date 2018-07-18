public class Assessment3Solution {
    public static void assessment3Method(Id companyId, String year){


        Integer noOfExecutives=0;
        List<Assessment3_Company_Report__c> reportInsertList=new List<Assessment3_Company_Report__c>();
        List<Assessment3_Company_Report__c> reportUpdateList=new List<Assessment3_Company_Report__c>();
        Map<Id,List<Assessment3_Sales__c>> exeMap=new Map<Id,List<Assessment3_Sales__c>>();
        Map<String,Assessment3_Company_Report__c> reportMap=new Map<String,Assessment3_Company_Report__c>();
		for(Assessment3_Executive__c exe: [SELECT Id, (SELECT Id FROM Assessment3_Sales__r)
                                           FROM Assessment3_Executive__c
                                           WHERE Year__c=:year]){
                                               if(!exeMap.containsKey(exe.Id))
	                                           		exeMap.put(exe.Id, new List<Assessment3_Sales__c>());
                                               else
                                               exeMap.get(exe.Id).add(exe.Assessment3_Sales__r);
                                               noOfExecutives++;
                                           }
        Double sale1,sale2,sale3,sale4;
        sale1=0;sale2=0;sale3=0;sale4=0;
        Set<String> quarterSet=new Set<String>();
        for(Assessment3_Sales__c sale: [SELECT Id, Quarter__c, Sale_Amount__c
                                        FROM Assessment3_Sales__c
                                        WHERE Executive__c IN :exeMap.keySet()]){
                                            if(sale.Quarter__c=='Q1')
                                            	sale1+=sale.Sale_Amount__c;

                                            else if(sale.Quarter__c=='Q2')
                                            	sale2+=sale.Sale_Amount__c;

                                            else if(sale.Quarter__c=='Q3')
                                            	sale3+=sale.Sale_Amount__c;
                                                
                                            else if(sale.Quarter__c=='Q4')
                                            	sale4+=sale.Sale_Amount__c;
                                            
                                            if(!quarterSet.contains(sale.Quarter__c))
                                                quarterSet.add(sale.Quarter__c);
                                                
                                        }
        
        for(Assessment3_Company_Report__c report: [SELECT Id, Company__c,Year__c, Quater__c, Average_Sale__c
                                                   FROM Assessment3_Company_Report__c
                                                   WHERE Year__c=:year]){
                                                       String uniqueRecord= report.Company__c+report.Year__c+report.Quater__c;
                                                       reportMap.put(uniqueRecord,report);
                                                   }
        
        System.debug(sale1+' '+sale2+' '+sale3+' '+sale4);
        for(String str: quarterSet){
			Assessment3_Company_Report__c report=new Assessment3_Company_Report__c();
			report.Company__c=companyId;
			report.Year__c=year;
			report.Quater__c=str;
                                            
			if(str=='Q1')
				report.Average_Sale__c=sale1/noOfExecutives;
			else if(str=='Q2')
				report.Average_Sale__c=sale2/noOfExecutives;
			else if(str=='Q3')
				report.Average_Sale__c=sale3/noOfExecutives;
			else if(str=='Q4')
				report.Average_Sale__c=sale4/noOfExecutives;

            
            String uniqueRecord=report.Company__c+report.Year__c+report.Quater__c;
			if(report.Average_Sale__c!=0){
                if(!reportMap.containsKey(uniqueRecord))
					reportInsertList.add(report);
            	else{
                    report.Id=reportMap.get(uniqueRecord).Id;
                    reportUpdateList.add(report);
                }
            }     
        }
        
		if(reportInsertList.size()>0)
			insert reportInsertList;
        if(reportUpdateList.size()>0)
            update reportUpdateList;
    }

}
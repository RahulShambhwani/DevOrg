public class Qus3 {
    public Qus3(Date d1, Date d2){
		Integer count=0,noOfDays=0;
        Date temp;
//        If(d1>=d2){
        d2.addDays(-1);
			noOfDays=d1.daysBetween(d2);
            temp=d1;
//        }
  //      else{
//			noOfDays=d2.daysBetween(d1);
    //        temp=d2;
      //  }
			for(Integer d=d1.day();d<=noOfDays;d++){
            	DateTime myDateTime = (DateTime) temp;
            	String dayOfWeek=myDateTime.format('E');
                If(!dayOfWeek.equals('Sat') && !dayOfWeek.equals('Sun')){
                    count++;
            		System.debug(dayOfWeek);
                }
            	temp=temp.addDays(1);
        	}
        System.debug(count);
        	
    }
}
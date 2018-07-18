public class StringArrayTest {
    public static List<String> generateStringArray(Integer inputNumber){
        List<String> strList=new List<String>();
        for(Integer i=0;i<inputNumber;i++)
            strList.add('Test '+i);
    	return strList;
    }
}
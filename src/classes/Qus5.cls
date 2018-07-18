public class Qus5 {
    public static void get(){
        Map<String,Schema.SObjectType> objMap=Schema.getGlobalDescribe();
        //for(String sObj: objMap.keySet()){
            System.debug(objMap.values());
        //}
    }
}
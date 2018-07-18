public class SchedulableClass implements Schedulable{
    public void execute(SchedulableContext sc){
        batchClass bat=new batchClass();
		Id job = Database.executeBatch(bat,10);
    }
}
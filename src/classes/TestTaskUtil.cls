@isTest
public class TestTaskUtil {
    @isTest static void testTask(){
        String task1= TaskUtil.getTaskPriority('LA');
        System.assertEquals('Normal', task1);
        
        String task2= TaskUtil.getTaskPriority('CA');
        System.assertEquals('High', task2);
        
        String task3= TaskUtil.getTaskPriority('MdAS');
        System.assertEquals(null, task3);

        String task4= TaskUtil.getTaskPriority('');
        System.assertNotEquals('High', task4);
        
    }
}
@isTest
public class TestDivisionClass {
    @isTest static void testDivision(){

        Double div1=DivisionClass.division(5, 2);
        System.assertEquals(2.5,div1);
        
        Double div=DivisionClass.division(1, 0);
        System.assertEquals(0,div,'Cannot divide by zero');
        
    }	
}
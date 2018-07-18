@isTest
private class TestTemperatureConverter {
    @isTest static void TempConverter(){
        Double d=TemperatureConverter.FahrenheitToCelcius(90);
        System.assertEquals(58.5, d);
    }
}
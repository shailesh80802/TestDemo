@isTest
public class AccountWeatherControllerTest{
    testMethod static void testAccountWeather(){
        Account acc = new Account(Name='Wreather Test',BillingCity='Test City',BillingCountry='US',BillingPostalCode='12345');
        
        insert acc;
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        
        Test.startTest();
         // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockAccountWeatherHttpResponse());        
         
        AccountWeatherController testAccWeather = new AccountWeatherController(sc);
         
        PageReference pageRef = Page.AccountWeather;
        Test.setCurrentPage(pageRef);
        Test.stopTest();
        
        
    }    
}
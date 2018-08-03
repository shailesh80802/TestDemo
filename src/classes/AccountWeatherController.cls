public class AccountWeatherController{

    private final Account acct;
    private static final String SERVICE_URL= System.label.OpenWeatherURL; 
    private static final String APPID= System.label.OpenWeather_APPID; 
    public String htmlbody{get;set;}
    
    public AccountWeatherController(ApexPages.StandardController stdController) {
        String accId = stdController.getId();
        acct = [SELECT Id,Name,BillingCity,BillingCountry,BillingPostalCode,BillingStreet,BillingState FROM Account WHERE id=:accId LIMIT 1];
        processWeatherDetail();
    }
    public void processWeatherDetail(){
        String reqURL = '?q='+acct.BillingCity+','+acct.BillingCountry+'&zip='+acct.BillingPostalCode+','+acct.BillingCountry+'&mode=html&units=imperial&appid='+APPID;
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(SERVICE_URL+reqURL);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('Response body : '+res.getBody());
        htmlBody=res.getBody();
    }
    
}
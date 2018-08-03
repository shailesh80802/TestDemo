@isTest
global class MockAccountWeatherHttpResponse implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assert(req.getEndpoint().contains('http://api.openweathermap.org/data/2.5/weather'));
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('<html><body>Weather</body></html>');
        res.setStatusCode(200);
        return res;
    }
}
global class AutoTaskCreateOpportunityMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        
        	string endpoint = req.getEndpoint();
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
        	res.setBody('{"name": "helloWorld","items":[],"pageDetails":{"count":0,"requestCount":500,"prevPageUrl":null,"nextPageUrl":null}}');	
            res.setStatusCode(200);
            return res;
    }
}
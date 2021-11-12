global class AutoTaskOpportunitySchedule Implements Schedulable{
    
    private String endPoint{get; set;}
    public String RequestAndResponse {get; set;}
    private Http http{get; set;}
    private HttpRequest request{get; set;}
    private HttpResponse response{get; set;}
    private String respBody{get; set;}
    
    //API credentials
    private Static String ApiIntegrationcode;
    private Static String UserName;
    private Static String Secret;    
    public void appendAuthenticationHeaders(HttpRequest req){
        req.setHeader('ApiIntegrationcode', ApiIntegrationcode);
        req.setHeader('UserName', UserName);
        req.setHeader('Secret', Secret);
        req.setHeader('Content-Type', 'application/json');
    }
    
    public AutoTaskOpportunitySchedule(){}
    
    global void execute(SchedulableContext sc){
        
        List<User_Credential__mdt> userCreds = Test.isRunningTest() ? [SELECT Id, DeveloperName,Api_Integration_Code__c,
                                                                       User_Name__c,Secret__c
                                                                       from User_Credential__mdt LIMIT 1] 
            : User_Credential__mdt.getAll().values();
        
        ApiIntegrationcode = userCreds[0].Api_Integration_Code__c;//'SNGBS5L7SBTA733DSSUCKCJGYAD';
        UserName = userCreds[0].User_Name__c;//'buuufjxtjwj7r3x@iqinteractive.ca';
        Secret = userCreds[0].Secret__c;//'Da6~7$pZA5#xcM8*1n@EkG9~$';
        
        SearchOpportunities();      
    }
    
    public String SearchOpportunities(){
        
        List<User_Credential__mdt> userCreds = Test.isRunningTest() ? 
            [SELECT Id, DeveloperName, Api_Integration_Code__c,
             User_Name__c, Secret__c, DefaultOwner__c
             from User_Credential__mdt LIMIT 1] : User_Credential__mdt.getAll().values();
        
        ApiIntegrationcode = userCreds[0].Api_Integration_Code__c;//'SNGBS5L7SBTA733DSSUCKCJGYAD';
        UserName = userCreds[0].User_Name__c;//'buuufjxtjwj7r3x@iqinteractive.ca';
        Secret = userCreds[0].Secret__c;//'Da6~7$pZA5#xcM8*1n@EkG9~$';
        
        Date last3Days = Date.today();
        last3Days.addDays(-3);
        String OpportunityId = '';
        endPoint = 'https://webservices15.autotask.net/atservicesrest/v1.0/Opportunities/query?search=';
        
        List<String> SearchOppIncludeFields = new List<String>{'id', 'Name','onetimeRevenue', 'monthlyRevenue'};
            List<AutoTaskRequests.RequestFields> SearchOppfilter = new List<AutoTaskRequests.RequestFields>{
                
                new AutoTaskRequests.RequestFields('eq', 'closedDate', '"'+last3Days)};
                    
                    SearchOppfilter.add(new AutoTaskRequests.RequestFields('exist', 'salesOrderID', null));
        
        AutoTaskRequests.RequestFieldsWrapper SearchOppRequest = 
            new AutoTaskRequests.RequestFieldsWrapper(SearchOppIncludeFields, SearchOppfilter);
        
        String queryStr = JSON.serialize(SearchOppRequest);
        System.debug('12345: ' + queryStr);
        // Integration Logs
        RequestAndResponse += 'PrdRQ:' + queryStr + '\n';
        
        queryStr = encodingutil.urlEncode(queryStr, 'UTF-8');
        
        http = new Http();
        request = new HttpRequest();
        request.setEndpoint(endPoint + queryStr);
        request.setMethod('GET');
        appendAuthenticationHeaders(request);
        
        try{
            response = http.send(request);
            respBody = response.getBody();
            
            // Integration Logs
            RequestAndResponse += 'PrdRS:' + respBody + '\n';
            
            System.debug('Opportunity search JSON Response is: ' + respBody);
            if (response.getStatusCode() != 200) 
                System.debug('Error in Opportunity search is: ' + response.getStatusCode() + ' ' + 
                             response.getStatus());
            else {
                AutoTaskResponses.ResponseFields OppSearchResponse = (AutoTaskResponses.ResponseFields)
                    JSON.deserialize(respBody, AutoTaskResponses.ResponseFields.class);
                
                OpportunityId = OppSearchResponse.Items != null && !OppSearchResponse.Items.isEmpty() && 
                    OppSearchResponse.Items[0].id != null ? OppSearchResponse.Items[0].id : '';
                
                //AutoTaskResponses.ResponseItems OppSearchResponse = (AutoTaskResponses.ResponseItems)
                //JSON.deserialize(respBody, AutoTaskResponses.ResponseItems.class);
                System.debug('product else: ' + OppSearchResponse);
                //if(OppSearchResponse.id != null){
                //OpportunityId = OppSearchResponse.id;
                // }
            }
        }
        catch (Exception ex){
            System.debug('Exception during Opportunity search is: ' + ex.getMessage());   
        }
        
        return OpportunityId;
    }
    
}

////Write below in DC just one time so that a scheduled apex is created. 
////Time should be accord SF (check SF Account information for timezone)
//AutoTaskOpportunitySchedule m = new AutoTaskOpportunitySchedule(); 
//String sch = '0 15 10 * * ?';  //10:15 daily
//String jobID = system.schedule('Merge Job', sch, m); // It will create a scheduled apex job
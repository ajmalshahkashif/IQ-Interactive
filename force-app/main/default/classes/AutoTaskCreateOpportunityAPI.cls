public class AutoTaskCreateOpportunityAPI implements Queueable, Database.AllowsCallouts, Metadata.DeployCallback  {
    
    private String AccountName {get; set;}
    private Map<Id, Opportunity> OppList{get; set; }
    private Http http{get; set;}
    private HttpRequest request{get; set;}
    private HttpResponse response{get; set;}
    private String respBody{get; set;}
    private String endPoint{get; set;}
    private String companyId{get; set;}
    private String address1{get; set;}
    private String city{get; set;}
    private String state{get; set;}
    private String postalCode{get; set;}
    private String country{get; set;}
    private String contactId{get; set;}
    private String quoteLocationId{get; set;}
    private String autoTaskoppId{get; set;}
    
    //API credentials
    private Static String ApiIntegrationcode;
    private Static String UserName;
    private Static String Secret;
    
    public String RequestAndResponse {get; set;}
    public String contactRequestInit {get; set;}
    
    //API defaults
    private Static String autoTaskDefaultOwner;
    
    public AutoTaskCreateOpportunityAPI(Map<Id, Opportunity> opList){
        System.debug('constructor called...');
        OppList = opList;
       
        RequestAndResponse = '';
    }
    
    public void handleResult(Metadata.DeployResult result,Metadata.DeployCallbackContext context) {
        
    }
    
    
    
    
    
    
    public String SearchOpportunities(){
        Date last3Days = Date.today();
        last3Days = last3Days.addDays(-3);
        
        String lastThreeDays = String.valueOf(last3Days);
        
        Date todayy = Date.today();
        String todayDate = String.valueOf(todayy);
        String OpportunityId = '';
        endPoint = 'https://webservices15.autotask.net/atservicesrest/v1.0/Opportunities/query?search=';
        
        List<String> SearchOppIncludeFields = new List<String>{'id', 'Title', 'monthlyRevenue'};
             /*All those Opp which are closed in the last 3 days & having SalesOrder means => invoice alternatively*/
               
            List<AutoTaskRequests.RequestFields> SearchOppfilter = new List<AutoTaskRequests.RequestFields>{
                   
                new AutoTaskRequests.RequestFields('gte', 'closedDate', lastThreeDays)};
                    SearchOppfilter.add(new AutoTaskRequests.RequestFields('lte', 'closedDate', todayDate));
        SearchOppfilter.add(new AutoTaskRequests.RequestFields('noteq', 'salesOrderID', null));
        
        AutoTaskRequests.RequestFieldsWrapper SearchOppRequest = 
            new AutoTaskRequests.RequestFieldsWrapper(SearchOppIncludeFields, SearchOppfilter);
        
        String queryStr = JSON.serialize(SearchOppRequest);
        System.debug('qurrr: ' + queryStr);
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
            System.debug('body iss: ' + respBody);
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
    
    
    
    public void appendAuthenticationHeaders(HttpRequest req){
        
        req.setHeader('ApiIntegrationcode', ApiIntegrationcode);
        req.setHeader('UserName', UserName);
        req.setHeader('Secret', Secret);
        req.setHeader('Content-Type', 'application/json');
    }
    
    public void execute(QueueableContext context) {
        
        contactRequestInit = '';
        
        List<User_Credential__mdt> userCreds = Test.isRunningTest() ? [SELECT Id, DeveloperName,
                                                                       Api_Integration_Code__c,
                                                                       User_Name__c,
                                                                       Secret__c,
                                                                       DefaultOwner__c
                                                                       from 
                                                                       User_Credential__mdt LIMIT 1] 
            : User_Credential__mdt.getAll().values();
        
        ApiIntegrationcode = userCreds[0].Api_Integration_Code__c;//'SNGBS5L7SBTA733DSSUCKCJGYAD';
        UserName = userCreds[0].User_Name__c;//'buuufjxtjwj7r3x@iqinteractive.ca';
        Secret = userCreds[0].Secret__c;//'Da6~7$pZA5#xcM8*1n@EkG9~$';
        autoTaskDefaultOwner = userCreds[0].DefaultOwner__c; //'29682893';
        
        http = new Http();
        request = new HttpRequest();
        response = null;
        respBody = null;
        
        List<Account> accounts = [Select id, name, phone, 
                                  billingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry
                                  from account where id in (
                                      select accountid from opportunity where id in:OppList.keySet()) limit 1];
        
        Opportunity opp = new Opportunity();
        for(Id key : OppList.keySet()){
            opp = OppList.get(key);
        }
        
        opp = [Select id, name, closedate, stagename, amount from opportunity where id =:opp.Id];
        
        
        
        
         SearchOpportunities();
        
        
        
        
        
        
        endPoint = 'https://webservices15.autotask.net/atservicesrest/v1.0/Companies/query?search=';
        
        //looking up company
        
        List<String> IncludeFields = new List<String>{'id', 'companyName', 'address1', 'city', 'state', 'postalCode'};
            List<AutoTaskRequests.RequestFields> filter = 
            new List<AutoTaskRequests.RequestFields>{new AutoTaskRequests.RequestFields('eq', 'companyName', accounts[0].Name)};
                
                AutoTaskRequests.RequestFieldsWrapper AccountRequest = 
                new AutoTaskRequests.RequestFieldsWrapper(IncludeFields, filter);
        
        String AccountRequestStr = JSON.serialize(AccountRequest);
        
        // Integration Logs
        RequestAndResponse = 'AcctRQ:'+ AccountRequestStr + '\n';
        
        AccountRequestStr = encodingutil.urlEncode(AccountRequestStr, 'UTF-8');
        request.setEndpoint(endPoint + AccountRequestStr);
        request.setMethod('GET');
        appendAuthenticationHeaders(request);
        
        response = http.send(request);
        
        respBody = response.getBody();
        
        // Integration Logs
        RequestAndResponse += 'AcctRS:' + respBody + '\n';
        
        AutoTaskResponses.ResponseFields companyResponse = (AutoTaskResponses.ResponseFields)
            JSON.deserialize(respBody, AutoTaskResponses.ResponseFields.class);
      
        if(companyResponse.Items != null && companyResponse.Items.isEmpty()) 
            system.debug('Company Not Found, needs to be created.');
        
        companyId = companyResponse.Items != null && !companyResponse.Items.isEmpty() && 
            companyResponse.Items[0].companyName != null ? companyResponse.Items[0].id : null;
        
        address1 = companyResponse.Items != null && !companyResponse.Items.isEmpty() &&
            companyResponse.Items[0].companyName != null ? 
            companyResponse.Items[0].address1 : 
        '"' + accounts[0].BillingStreet + '"';
        
        city = companyResponse.Items != null && !companyResponse.Items.isEmpty() &&
            companyResponse.Items[0].companyName != null ? 
            companyResponse.Items[0].city : 
        '"' + accounts[0].BillingCity + '"';
        
        state = companyResponse.Items != null && !companyResponse.Items.isEmpty() &&
            companyResponse.Items[0].companyName != null ? 
            companyResponse.Items[0].state : 
        '"' + accounts[0].BillingState + '"';
        
        postalCode = companyResponse.Items != null && !companyResponse.Items.isEmpty() &&
            companyResponse.Items[0].companyName != null ? 
            companyResponse.Items[0].postalCode : 
        '"' + accounts[0].BillingPostalCode + '"';
        
        country = companyResponse.Items != null && !companyResponse.Items.isEmpty() &&
            companyResponse.Items[0].companyName != null ? null : 
        '"' + accounts[0].BillingCountry + '"';
        
        String countryId = companyResponse.Items != null && !companyResponse.Items.isEmpty() &&
            companyResponse.Items[0].companyName != null ? 
            null : SearchCompanyCountry(country);
        
        if(companyResponse.Items != null && companyResponse.Items.isEmpty()) 
            CompanyCreateSetting(accounts.get(0), countryId);
        
        try{
            
            response = companyResponse.Items != null && companyResponse.Items.isEmpty() ? 
                http.send(request) : response;
            respBody = companyResponse.Items != null && companyResponse.Items.isEmpty() ? 
                response.getBody() : respBody;
            
            // Integration Logs
            if(companyResponse.Items != null && companyResponse.Items.isEmpty()) 
                RequestAndResponse += 'AcctRS:' + respBody + '\n';
            
            system.debug('Company JSON Response: ' + respBody);
            
            AutoTaskResponses.ResponseItemId 
                companyResponseItemId = new AutoTaskResponses.ResponseItemId(null);
            if(companyResponse.Items.isEmpty())
                companyResponseItemId = (AutoTaskResponses.ResponseItemId)
                JSON.deserialize(respBody, AutoTaskResponses.ResponseItemId.class);
            
            if (response.getStatusCode() != 200 && companyResponse.Items != null &&  
                companyResponse.Items.isEmpty())
                System.debug('Error at Company creation is: ' + 
                             response.getStatusCode() + ' ' + 
                             response.getStatus() + ' ' + response.getBody());
            
            if (response.getStatusCode() == 200 && companyResponse.Items != null && 
                companyResponse.Items.isEmpty() &&
                companyResponseItemId.itemId != null){
                    companyId = companyResponseItemId.itemId;
                    system.debug('Company created.');
                    system.debug('New Company Id: ' + companyId);
                } 
            
        }catch(Exception ex){
            
            System.debug('Exception during Company creation is: ' + ex.getMessage()); 
        }
        
        //inserting quote location
        QuoteLocationCreateSetting();
        
        AutoTaskRequests.RequestQuoteLocation QuoteLocationRequest = 
            new AutoTaskRequests.RequestQuoteLocation(address1, city, state, postalCode);
        
        String quoteLocationStr = JSON.Serialize(QuoteLocationRequest);
        
        // Integration Logs
        RequestAndResponse += 'QLocRQ:' + quoteLocationStr + '\n';
        
        request.setBody(quoteLocationStr);
        try{
            
            response = http.send(request);
            respBody = response.getBody();
            
            // Integration Logs
            RequestAndResponse += 'QLocRS:' + respBody + '\n';
            
            if (response.getStatusCode() != 200) {
                System.debug('Error at QuoteLocation is: ' + response.getStatusCode() + ' ' + 
                             response.getStatus());
            }else {
                System.debug('QuoteLocation create JSON Response: ' + respBody);
                
                AutoTaskResponses.ResponseItemId quoteLocationResponse = (AutoTaskResponses.ResponseItemId)
                    JSON.deserialize(respBody, AutoTaskResponses.ResponseItemId.class);
                
                quoteLocationId = quoteLocationResponse.itemId;
                // redundant quote location code was here
            }
        }catch (Exception ex){
            System.debug('Exception during QuoteLocation creation is: ' + ex.getMessage());   
        }
        
        //looking up contact
        
        List<OpportunityContactRole> oppContRole = [select id, OpportunityId, Role, ContactId,
                                                    Contact.FirstName, Contact.LastName,Contact.Email,
                                                    Contact.Phone, Contact.MobilePhone
                                                    from OpportunityContactRole
                                                    where OpportunityId =: opp.Id 
                                                    and IsPrimary = true limit 1];
        
        List<String> searchContactIncludeFields = new List<String>{'id', 'firstName', 'lastName'};
            
            List<AutoTaskRequests.RequestFields> searchContactFilter = new List<AutoTaskRequests.RequestFields>{
                new AutoTaskRequests.RequestFields('eq', 'companyID', companyId)};
                    
                    if(!oppContRole.isEmpty()){
                        searchContactFilter.add(new AutoTaskRequests.RequestFields('eq', 'firstName', 
                                                                                   oppContRole[0].Contact.firstName));
                        searchContactFilter.add(new AutoTaskRequests.RequestFields('eq', 'lastName', 
                                                                                   oppContRole[0].Contact.LastName));
                    }
        
        AutoTaskRequests.RequestFieldsWrapper ContactRequest = 
            new AutoTaskRequests.RequestFieldsWrapper(searchContactIncludeFields, searchContactFilter);
        
        http = new Http();
        request = new HttpRequest();
        String ContactRequestStr = JSON.serialize(ContactRequest);
        
        contactRequestInit = 'CtRQ:' + ContactRequestStr + '\n';

        ContactRequestStr = encodingutil.urlEncode(ContactRequestStr, 'UTF-8');
        
        endPoint = 'https://webservices15.autotask.net/atservicesrest/v1.0/Contacts/query?search=';
        endPoint = endPoint + ContactRequestStr;
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        appendAuthenticationHeaders(request);
        try{
            response = http.send(request);
        }catch(Exception ex){
            System.debug('Exception at ContactRequest is: ' + ex.getMessage());
        }
        respBody = response.getBody();
        
        ContactRequestInit += 'CtRS:' + respBody + '\n';
        System.debug('cont respBody: ' + respBody);
        
        AutoTaskResponses.ResponseFields ContactResponse = (AutoTaskResponses.ResponseFields)
            JSON.deserialize(respBody, AutoTaskResponses.ResponseFields.class);
        System.debug('ContactResponse: ' + ContactResponse);
        
        contactId = ContactResponse.Items != null && !ContactResponse.Items.isEmpty() && 
            ContactResponse.Items[0].id != null ? ContactResponse.Items[0].id : null;
        
        
        System.debug('contactId: ' + contactId);
        
        if(contactId == null ){
            if(!oppContRole.isempty()){
                //inserting contact
                ContactCreateSetting(oppContRole[0].Contact.firstName, oppContRole[0].Contact.LastName, companyId, 
                                     1, oppContRole[0].Contact.Email, oppContRole[0].Contact.Phone,
                                     oppContRole[0].Contact.MobilePhone);
                try{
                    response = http.send(request);
                    respBody = response.getBody();
                    System.debug('respBody contact123: ' + respBody);
                    
                    ContactRequestInit += 'CtRS:' + respBody + '\n';
                    System.debug('respBody contact: ' + respBody);
                    
                    // respBody contact: {"itemId":30686789}
                    if (response.getStatusCode() != 200) 
                        System.debug('Error at Contact creation is: ' + response.getStatusCode() + ' ' + response.getStatus() + ' ' + response.getBody());
                    else {
                        AutoTaskResponses.ResponseContact ContResp = (AutoTaskResponses.ResponseContact)
                            JSON.deserialize(respBody, AutoTaskResponses.ResponseContact.class);
                        System.debug('ContResp contact: ' + ContResp);
                        contactId = ContResp.itemId;
                        System.debug('Contact is created & id is: ' + contactId);
                    }
                }catch(Exception ex){
                    System.debug('ex during contact creation is: ' + ex.getMessage());
                }
            }
        }
        
        
        RequestAndResponse += ContactRequestInit;
        
        //create opportunity in auto task
        OppCreateSetting(opp);
        
        try{
            response = http.send(request);
            respBody = response.getBody();
            System.debug('opp created 111: ' + respBody);
            // Integration Logs
            RequestAndResponse += 'OppRS:' + respBody + '\n';
            
            AutoTaskResponses.ResponseItemId OpportunityCreateResponse = (AutoTaskResponses.ResponseItemId)
                JSON.deserialize(respBody, AutoTaskResponses.ResponseItemId.class);
            
            if (response.getStatusCode() != 200) 
                System.debug('Error at Opportunity creation: ' + response.getStatusCode() + ' ' + 
                             response.getStatus());
            
            else {
                System.debug('Opportunity creation JSON response is: ' + respBody);
                autoTaskoppId = OpportunityCreateResponse.itemId;

                List<Quote> quotes = [Select id, CreatedDate, Name,
                                      (Select id, Product2.Name, Product2.Subscription_Period__c, quantity, unitprice, 
                                       totalprice from QuoteLineItems)
                                      from Quote where OpportunityId = :opp.Id 
                                      Order by isSyncing desc, CreatedDate desc limit 1];
                if(!quotes.isempty())
                {
                    QuoteCreateSetting(quotes[0]);
                    
                    try{
                        response = http.send(request);
                        respBody = response.getBody();
                        
                        // Integration Logs
                        RequestAndResponse += 'QtRS:' + respBody + '\n';
                        
                        if (response.getStatusCode() != 200) 
                            System.debug('Error at Quote creation is: ' + response.getStatusCode() + ' ' + 
                                         response.getStatus() + ' ' + response.getBody());
                        else {
                            System.debug('Quote creation JSON response is: ' + respBody);
                            AutoTaskResponses.ResponseItemId QuoteCreateResponse = 
                                (AutoTaskResponses.ResponseItemId)
                                JSON.deserialize(respBody, AutoTaskResponses.ResponseItemId.class);
                            
                            String quoteId = QuoteCreateResponse.itemId;
                            for(QuoteLineItem qli: quotes[0].QuoteLineItems)
                            {
                                String ProductId = SearchProduct(qli.Product2.Name);
                                System.debug('ProductId: ' + ProductId);
                                if(ProductId != ''){
                                    System.debug('inside if');
                                    QuoteItemsCreateSetting(quoteId, qli, ProductId);
                                    
                                    try{
                                        response = http.send(request);
                                        respBody = response.getBody();
                                        
                                        // Integration Logs
                                        RequestAndResponse += 'QtLRS:' + respBody + '\n';
                                        
                                        if (response.getStatusCode() != 200) 
                                            System.debug('Error at QuoteLineItem creation is: ' + 
                                                         response.getStatusCode() + ' ' + response.getStatus());
                                        else {
                                            System.debug('Quote line items created...');
                                            System.debug('Quote item creation JSON response: ' + response.getBody());
                                        }
                                    }
                                    catch (Exception ex){
                                        System.debug('Exception during Quote line item creation is: ' + ex.getMessage());   
                                    }
                                }
                            }
                        }
                        try{
                            // Create Integration Logs
                            Integration_Logs__c logs = new Integration_Logs__c();
                            logs.Request_Response__c = RequestAndResponse;
                            logs.Opportunity__c = opp.id;
                            
                            insert logs;
                        }catch(Exception ex){}
                        
                    }catch (Exception ex){
                        System.debug('Exception during Quote creation is ' + ex.getMessage());   
                    }
                }
            }
        }
        catch (Exception ex){
            System.debug('Exception during Opportunity creation is: ' + ex.getMessage());   
        }
        
        if(autoTaskoppId != null){
            opp.AutoTask_OppId__c = autoTaskoppId;
            update opp;
        }
    }
    
    public String SearchProduct(String productName){
        String ProductId = '';
        endPoint = 'https://webservices15.autotask.net/atservicesrest/v1.0/Products/query?search=';
        
        List<String> SearchProductIncludeFields = new List<String>{'id', 'Name'};
            List<AutoTaskRequests.RequestFields> SearchProductfilter = new List<AutoTaskRequests.RequestFields>{
                new AutoTaskRequests.RequestFields('eq', 'Name', productName)};
                    
                    AutoTaskRequests.RequestFieldsWrapper SearchProductRequest = 
                    new AutoTaskRequests.RequestFieldsWrapper(SearchProductIncludeFields, SearchProductfilter);
        
        String queryStr = JSON.serialize(SearchProductRequest);
        
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
            
            System.debug('Product search JSON Response is: ' + respBody);
            if (response.getStatusCode() != 200) 
                System.debug('Error in Product search is: ' + response.getStatusCode() + ' ' + 
                             response.getStatus());
            else {
                
                
                
                AutoTaskResponses.ResponseFields ProductSearchResponse = (AutoTaskResponses.ResponseFields)
                    JSON.deserialize(respBody, AutoTaskResponses.ResponseFields.class);
                
                
                ProductId = ProductSearchResponse.Items != null && !ProductSearchResponse.Items.isEmpty() && 
                    ProductSearchResponse.Items[0].id != null ? ProductSearchResponse.Items[0].id : '';
                
                
                //AutoTaskResponses.ResponseItems ProductSearchResponse = (AutoTaskResponses.ResponseItems)
                //JSON.deserialize(respBody, AutoTaskResponses.ResponseItems.class);
                System.debug('product else: ' + ProductSearchResponse);
                //if(ProductSearchResponse.id != null){
                //ProductId = ProductSearchResponse.id;
                // }
            }
        }
        catch (Exception ex){
            System.debug('Exception during Product search is: ' + ex.getMessage());   
        }
        
        
        return ProductId;
    }
    
    public String SearchCompanyCountry(String country){
        
        String countryId = '';
        endPoint = 'https://webservices15.autotask.net/atservicesrest/v1.0/Countries/query?search=';
        
        List<String> SearchCompanyIncludeFields = new List<String>{'id', 'Name'};
            List<AutoTaskRequests.RequestFields> SearchCompanyfilter = 
            new List<AutoTaskRequests.RequestFields>{new AutoTaskRequests.RequestFields(
                'eq', 'Name', country
            )};
                
                AutoTaskRequests.RequestFieldsWrapper SearchCompanyRequest = 
                new AutoTaskRequests.RequestFieldsWrapper(SearchCompanyIncludeFields, SearchCompanyfilter);
        
        String queryStr = JSON.serialize(SearchCompanyRequest);
        
        // Integration Logs
        RequestAndResponse += 'CtryRQ:' + queryStr + '\n';
        
        queryStr = encodingutil.urlEncode(queryStr, 'UTF-8');
        
        http = new Http();
        request = new HttpRequest();
        request.setEndpoint(endPoint + queryStr);
        request.setMethod('GET');
        appendAuthenticationHeaders(request);
        
        try{
            response = http.send(request);
            respBody = response.getBody();
            System.debug('Country search response is: ' + respBody);
            
            // Integration Logs
            RequestAndResponse += 'CtryRS:' + respBody + '\n';
            
            if (response.getStatusCode() != 200) 
                System.debug('Error at country search is: ' + response.getStatusCode() + ' ' + 
                             response.getStatus());
            else {
                
                AutoTaskResponses.ResponseItems CountrySearchResponse = (AutoTaskResponses.ResponseItems)
                    JSON.deserialize(respBody, AutoTaskResponses.ResponseItems.class);
                
                if(CountrySearchResponse.id != null){
                    countryId = CountrySearchResponse.id;
                }
            }
        }
        catch (Exception ex){
            System.debug('Exception during country search is: ' + ex.getMessage());   
        }
        
        return countryId;
    }
    
    public void CompanyCreateSetting(Account acc, String countryId){
        countryId = countryId == '' ? '237' : countryId;
        //TODO: add countryId in line 253 
        http = new Http();
        request = new HttpRequest();
        endPoint = 'https://webservices15.autotask.net/atservicesrest/v1.0/Companies';
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        appendAuthenticationHeaders(request);
        
       List<AutoTaskRequests.UDFields> udf = new List<AutoTaskRequests.UDFields>{
            new AutoTaskRequests.UDFields('Primary Product?', 'truffle')};
                
        AutoTaskRequests.RequestCompany CompanyRequest = 
            new AutoTaskRequests.RequestCompany(
                countryId, nullValue(acc.BillingStreet), nullValue(acc.BillingCity), 
                nullValue(acc.BillingState), nullValue(acc.BillingPostalCode), acc.Name, 
                '2',True, nullValue(acc.Phone == null ? '0000000000' : acc.Phone),autoTaskDefaultOwner,udf);
        
        System.debug('comp12: ' + CompanyRequest);
        String CompanyRequestStr = JSON.serialize(CompanyRequest);
        System.debug('CompanyRequestStr: ' + CompanyRequestStr);
        system.debug('Company Request JSON:' + CompanyRequestStr);
        
        RequestAndResponse += 'AcctRQ:' + CompanyRequestStr + '\n';
        
        request.setBody(CompanyRequestStr);
        
    }
    
    public static String nullValue(String str){
        return (str == null ? '' : str);
    }
    
    public void ContactCreateSetting(String fname, String lname, String companyId, Integer isActive,
                                    String email, String phone, String mobile){
        http = new Http();
        request = new HttpRequest();
        endPoint = 'https://webservices15.autotask.net/atservicesrest/v1.0/Companies/'+companyId+'/Contacts';
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        appendAuthenticationHeaders(request);
        
        AutoTaskRequests.RequestContact ContactRequest = new AutoTaskRequests.RequestContact(
            isActive, lname, fname, companyId, email, mobile, phone);
        System.debug('ContactRequest 111: ' + ContactRequest);
        String ContStr = JSON.serialize(ContactRequest);
         System.debug('ContStr 222: ' + ContStr);
        ContactRequestInit = 'CtRQ:' + ContStr + '\n';
        
        request.setBody(ContStr);
    }
     
    public void OppCreateSetting(Opportunity opp){
        http = new Http();
        request = new HttpRequest();
        endPoint = 'https://webservices15.autotask.net/atservicesrest/v1.0/Opportunities';
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        appendAuthenticationHeaders(request);
        
        AutoTaskRequests.RequestOpportunity OppRequest = new AutoTaskRequests.RequestOpportunity(
            opp.Amount, companyId, contactId, opp.Amount, autoTaskDefaultOwner, '100', opp.CloseDate, Date.today(),
            autoTaskDefaultOwner, 1, '29682776', opp.CloseDate, '1', opp.Name, 'false' );
        
        String OppStr = JSON.serialize(OppRequest);
        system.debug('Opportunity Request JSON is:' + OppStr);
        
        // Integration Logs
        RequestAndResponse += 'OppRQ:' + OppStr + '\n';
        
        request.setBody(OppStr);
    }
    
    public void QuoteCreateSetting(Quote q){
        http = new Http();
        request = new HttpRequest();
        endPoint = 'https://webservices15.autotask.net/atservicesrest/v1.0/Quotes';
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        appendAuthenticationHeaders(request); 
        Date todayPlus30Days = Date.today();  
        
        
        AutoTaskRequests.RequestQuote QuoteRequest = new AutoTaskRequests.RequestQuote(
            quoteLocationId, autoTaskoppId, contactId, q.CreatedDate.format('yyyy-MM-dd'), todayPlus30Days.addDays(30), 
            q.Name + '-' + Date.today().format(), quoteLocationId, 
            quoteLocationId);
        
        String QuoteRequestStr = JSON.serialize(QuoteRequest);
        
        // Integration Logs
        RequestAndResponse += 'QtRQ:' + QuoteRequestStr + '\n';
        
        system.debug('Quote Request JSON is:' + QuoteRequestStr);
        request.setBody(QuoteRequestStr);
    }
    
    public void QuoteItemsCreateSetting(String quoteId, QuoteLineItem qli, String productId){
        System.debug('quoteitems function');
        http = new Http();
        request = new HttpRequest();
        endPoint = 'https://webservices15.autotask.net/atservicesrest/v1.0/Quotes/'+quoteId+'/Items';
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        appendAuthenticationHeaders(request);
        
        integer periodType = 
            qli.Product2.Subscription_Period__c == 'One Time' ? 1 : 
        qli.Product2.Subscription_Period__c == 'Monthly' ? 2 : 5;
        
        AutoTaskRequests.RequestQuoteItems QuoteItemsRequest = 
            new AutoTaskRequests.RequestQuoteItems(
                quoteId, false, '0', qli.Quantity, qli.UnitPrice, '1', 
                periodType, productId, qli.Product2.Name, '0', '0');
        
        String QuoteItemsRequestStr = JSON.serialize(QuoteItemsRequest);
        
        // Integration Logs
        RequestAndResponse += 'QtLRQ:' + QuoteItemsRequestStr + '\n'; 
        
        system.debug('Quote item Request JSON is: ');
        system.debug(QuoteItemsRequestStr);
        
        request.setBody(QuoteItemsRequestStr);
    }
    
    public void QuoteLocationCreateSetting(){
        http = new Http();
        request = new HttpRequest();
        endPoint = 'https://webservices15.autotask.net/atservicesrest/v1.0/QuoteLocations';
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        appendAuthenticationHeaders(request);
    }
    
}
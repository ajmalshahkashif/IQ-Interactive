@isTest
public class AutoTaskRequestsTest {
    
    @isTest static void runTests(){
        
     
       List<AutoTaskRequests.RequestFields> reqFields = new
           List<AutoTaskRequests.RequestFields>{new AutoTaskRequests.RequestFields('abc', 'abc', 'abc')};
        
       AutoTaskRequests.RequestFieldsWrapper reqFieldsWrapper = 
           new AutoTaskRequests.RequestFieldsWrapper(new List<String>{'abc'}, reqFields);
        
       AutoTaskRequests.RequestQuoteLocation reqQuoteLocation = 
           new AutoTaskRequests.RequestQuoteLocation('abc', 'abc','abc', 'abc');
        
        List<AutoTaskRequests.UDFields> udf = new List<AutoTaskRequests.UDFields>{
            new AutoTaskRequests.UDFields('Primary Product?', 'truffle')};
                
       AutoTaskRequests.RequestCompany reqCompany = 
           new AutoTaskRequests.RequestCompany('abc', 'abc', 'abc', 'abc', 'abc', 
                                               'abc', 'abc', true, 'abc', 'abc', udf);
        
       AutoTaskRequests.RequestOpportunity reqOpportunity = 
           new AutoTaskRequests.RequestOpportunity(123, 'abc', 'abc', 123,'abc', 
                                  'abc', Date.Today(),Date.today(), 'abc',
                                  1,'abc',Date.today(), 'abc',
                                  'abc', 'abc');
        
       AutoTaskRequests.RequestQuote reqQuote = new AutoTaskRequests.RequestQuote(
           'abc', 'abc', 'abc', 'abc', Date.Today(), 'abc', 'abc', 'abc');
        
       AutoTaskRequests.RequestQuoteItems reqQuoteItems = 
           new AutoTaskRequests.RequestQuoteItems('abc', true, '123', 1, 123, 'abc', 
                                 1, 'abc', 'abc', 'abc', 'abc');
    }
}
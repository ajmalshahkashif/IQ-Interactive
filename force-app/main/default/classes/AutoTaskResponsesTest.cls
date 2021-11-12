@isTest
public class AutoTaskResponsesTest {
    
    @isTest static void runTests(){
        
        List<AutoTaskResponses.ResponseItems> respItems = new
            List<AutoTaskResponses.ResponseItems>{new AutoTaskResponses.ResponseItems('123', 'abc', 'abc', 
                                                                                      'abc', 'abc', 'abc', new List<String>{'abc'})};
        
        AutoTaskResponses.ResponsePageDetails pageDetails = 
            new AutoTaskResponses.ResponsePageDetails('100', '500', 
                                   'http://www.test.com/0', 'http://www.test.com/1');
        
     	AutoTaskResponses.ResponseFields resp = 
            new AutoTaskResponses.ResponseFields(respItems, pageDetails);
        
        AutoTaskResponses.ResponseItemId respItemId = 
            new AutoTaskResponses.ResponseItemId('123');
        
        AutoTaskResponses.ResponseContact respCt = 
            new AutoTaskResponses.ResponseContact('123','123');
    }
}
@isTest
public class AutoTaskCreateOpportunityTest {
	
    @TestSetup static void TestData(){
        
        AutoTaskSync__c autotasksync = new AutoTaskSync__c();
        
        autotasksync.autotasksync__c = true;
        
        insert autotasksync;
        
        Account acct = new Account();
        
        acct.Name = 'Test Account';
        acct.Type_of_Account__c = 'Franchise';
        acct.Currency__c = 'USD';
        
        insert acct;
        
        Product2 prd = new Product2();
        
        prd.name = 'Test Product';
        prd.ProductCode = 'Product ABC';
        
        insert prd;
        
        Id priceBook2Id = Test.getStandardPricebookId();
        
        PriceBookEntry pbe = new PriceBookEntry();
        
        pbe.Pricebook2Id = priceBook2Id;
        pbe.Product2Id = prd.id;
        pbe.UnitPrice = 1;
        pbe.IsActive = true;
        
        insert pbe;
        
        Opportunity oppty = new Opportunity();
        
        oppty.Name = 'Test Opportunity';
        oppty.AccountId = acct.id;
        oppty.CloseDate = Date.today() + 7;
        oppty.StageName = 'Negotiation';
        
        insert oppty;
        
        OpportunityLineItem opptyLine = new OpportunityLineItem();
        
        opptyLine.OpportunityId = oppty.id;
        opptyLine.Quantity = 1;
        opptyLine.Product2Id = prd.id;
        opptyLine.PricebookEntryId = pbe.id;
        opptyLine.UnitPrice = 100;
        
        insert opptyLine;
        
        Quote qt = new Quote();
        
        qt.OpportunityId = oppty.id;
        qt.Name = 'Test Quote';
        qt.Pricebook2Id = priceBook2Id;
        
        insert qt;
        
        QuoteLineItem quoteLine = new QuoteLineItem();
        
        quoteLine.QuoteId = qt.id;
        quoteLine.Quantity = 1;
        quoteLine.OpportunityLineItemId = opptyLine.id;
        quoteLine.Description = 'Test';
        quoteLine.UnitPrice = 100;
        quoteLine.PricebookEntryId = pbe.id;
        
        insert quoteLine;

    }
    
    @isTest static void runTests(){
        
        Test.setMock(HttpCalloutMock.class, new AutoTaskCreateOpportunityMock());
        
        Opportunity oppty = [Select id, stagename from opportunity limit 1];
        
        oppty.stagename = 'Closed Won';
        
        Test.startTest();
        	update oppty;
        Test.stopTest();
        
        
    }
}
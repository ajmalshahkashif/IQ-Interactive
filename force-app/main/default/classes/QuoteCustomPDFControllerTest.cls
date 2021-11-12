@isTest
public class QuoteCustomPDFControllerTest {
	public static testmethod void testQuoteCustomPDFController()
    {
        Account acc = new Account(Name = 'test account');
        insert acc;
        
        Opportunity opp = new Opportunity(AccountId = acc.Id, name='test opp', Stagename='Closed Won');
        opp.closedate = system.today();
        insert opp;
        
        Quote q = new Quote(OpportunityId = opp.Id, name='test quote', PriceBook2Id = Test.getStandardPricebookId());
        insert q;
        
        Product2 prod = new Product2(name='test', isActive = true);
        insert prod;
        
        PriceBookEntry pbe = new PriceBookEntry(Product2Id = prod.Id, 
                                                Pricebook2Id = Test.getStandardPricebookId(),
                                               UnitPrice = 1, isActive=true);
        insert pbe;
        
        QuoteLineItem qli = new QuoteLineItem(QuoteId = q.Id, unitPrice= 1, quantity= 1);
        qli.PricebookEntryId = pbe.Id;
        insert qli;
        
        QuoteCustomPDFController cont = new QuoteCustomPDFController(new Apexpages.StandardController(q));
    }
}
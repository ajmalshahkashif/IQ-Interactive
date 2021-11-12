public class TotalRevenueExtension {
    
    public decimal totalRevenue {get; set;}
    
    public TotalRevenueExtension(){
        
        totalRevenue = 0;
        List<Opportunity> closedOpp = [select id, Amount
                                       from Opportunity where id in (
                                           select Opportunityid from OpportunityLineItem
                                           where Product2.Subscription_Period__c = 'Yearly'
                                       ) and StageName = 'Closed Won'];
        
        for(Opportunity opp : closedOpp){
            totalRevenue = totalRevenue + opp.Amount;
        }
        totalRevenue = totalRevenue.setScale(2);
        
    }
}
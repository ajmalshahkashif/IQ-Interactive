public class QuoteCustomPDFController {
    public Integer colSpan{get;set;}
    public class SubscriptionItem{
        public String subPeriod{get;set;}
        public Map<String, FamilyItem> familyItems{
            get{
                if(familyItems == null)	familyItems = new Map<String, FamilyItem>();
                return familyItems;
            } 
            set;
        }
    }
    public class FamilyItem{
        public String family{get;set;}
        public List<QuoteLineItem> qlis{
            get{
                if(qlis == null)	qlis = new List<QuoteLineItem>();
                return qlis;
            } 
            set;
        }
    }
    public List<SubscriptionItem> items{get;set;}
	public QuoteCustomPDFController(ApexPages.StandardController sc)
    {
        colSpan = 6;
        items = new List<SubscriptionItem>();
        Map<String, SubscriptionItem> subItemsMap = new Map<String, SubscriptionItem>();
        for(QuoteLineItem qli : [Select id, quantity, UnitPrice, Description, TotalPrice,
                                 Product2.Subscription_Period__c, Product2.Family,
                                 Product2.Name, Product2.Description, Product2.Image_URL__c
                                From QuoteLineItem where QuoteId =:sc.getId()
                                order by Product2.Subscription_Period__c asc])
        {
            if(!subItemsMap.containsKey(qli.Product2.Subscription_Period__c))	subItemsMap.put(qli.Product2.Subscription_Period__c, new SubscriptionItem());
            subItemsMap.get(qli.Product2.Subscription_Period__c).subPeriod = qli.Product2.Subscription_Period__c;
            
            if(!subItemsMap.get(qli.Product2.Subscription_Period__c).familyItems.containsKey(qli.Product2.Family))	subItemsMap.get(qli.Product2.Subscription_Period__c).familyItems.put(qli.Product2.Family, new FamilyItem());
            subItemsMap.get(qli.Product2.Subscription_Period__c).familyItems.get(qli.Product2.Family).family = qli.Product2.Family;
            subItemsMap.get(qli.Product2.Subscription_Period__c).familyItems.get(qli.Product2.Family).qlis.add(qli);
        }
        items = subItemsMap.values();
    }
}
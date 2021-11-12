public class UpdateOLICommissionHandler {
    
    static boolean runOnce = true;
    
    public static void updateOLICommissions(List<Product2> olddata, List<Product2> newdata){
        
        if(UpdateOLICommissionHandler.runOnce)
        {
            runOnce = false;
            integer i = 0;
            Set<id> ProdIdsSet = new Set<Id>();
            
            for(Product2 n : newData){
                
                if (n.Percentage__c != olddata[i].Percentage__c){ProdIdsSet.add(n.Id);
                }
                i++;
            }
            
            List<OpportunityLineItem> oliList = [select id, Percentage__c, Commission__c, PricebookEntry.Product2.Id, TotalPrice
                                                 from OpportunityLineItem
                                                 where PricebookEntry.Product2.Id in : ProdIdsSet];
            
            List<OpportunityLineItem> oliToUpdate = new List<OpportunityLineItem>();
            
            for(OpportunityLineItem oli : oliList){for(Product2 prod : [select id, Percentage__c from Product2 where id in : ProdIdsSet]){ if(oli.PricebookEntry.Product2.Id == prod.Id ){
                                             oli.Percentage__c = prod.Percentage__c;
                                             oli.Commission__c = (prod.Percentage__c * oli.TotalPrice)/100 ;
                                             oli.Run_Validation_Rule__c = false;
                                             oliToUpdate.add(oli);
                                         }
                                     }
            }
            if(oliToUpdate.size() > 0) update oliToUpdate;
        }
    }
    
}
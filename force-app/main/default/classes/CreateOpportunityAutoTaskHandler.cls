public class CreateOpportunityAutoTaskHandler {
    static boolean runOnce = true;
    public static void CreateOpportunity(List<Opportunity> oldData, List<Opportunity> newData){
        if(CreateOpportunityAutoTaskHandler.runOnce)
        {
            runOnce = false;
            Boolean StageUpdatedToWon = false;
            integer i = 0;
            Set<id> OppIdsSet = new Set<Id>();
            
            for(Opportunity n : newData){
                System.debug('stage1 is: ' + olddata[i].StageName);
                System.debug('stage2 is: ' + n.StageName);
                
                if (n.StageName != olddata[i].StageName){
                    if(n.StageName == 'Closed Won'){
                        StageUpdatedToWon = true;
                        OppIdsSet.add(n.Id);
                    }        
                }
                i++;
            }
            if(StageUpdatedToWon){
                System.debug('inside if');
                
                Map<Id, Opportunity> oppList =new Map<Id, Opportunity>([select id, Name, Account.Name, CloseDate,
                                                                        Account.BillingStreet, Account.BillingCity,
                                                                        Account.BillingState, Account.BillingPostalCode,
                                                                        AutoTask_OppId__c
                                                                        from Opportunity
                                                                        where id in: OppIdsSet]);
                
                System.enqueueJob(new AutoTaskCreateOpportunityAPI(oppList));
            } 
        }
    }
}
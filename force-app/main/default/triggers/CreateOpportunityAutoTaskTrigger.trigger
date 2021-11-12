trigger CreateOpportunityAutoTaskTrigger on Opportunity (after update) {
    
    // get the custom setting "Auto Task Sync" to run the trigger or not
    AutoTaskSync__c autotasksync = AutoTaskSync__c.getOrgDefaults();
    
    if(trigger.IsUpdate && trigger.IsAfter && autotasksync.AutoTaskSync__c){
        
        CreateOpportunityAutoTaskHandler.CreateOpportunity(Trigger.old, Trigger.new);
    }
}
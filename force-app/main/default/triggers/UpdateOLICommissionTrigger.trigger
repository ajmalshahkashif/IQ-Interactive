trigger UpdateOLICommissionTrigger on Product2 (after update) {
    
    if(trigger.IsUpdate && trigger.IsAfter){
        
        UpdateOLICommissionHandler.updateOLICommissions(Trigger.old, Trigger.new);
        
    }
    
}
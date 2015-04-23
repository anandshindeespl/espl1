/**
*   on cration of account trigger will create the new task 
*/
trigger CreateTAsk on Account (before insert) 
{
   /* TriggerSetting__c triggSet= TriggerSetting__c.getInstance();
    AccountTaskHandler taskHandler = new AccountTaskHandler();
    
    // condition to check custom setting to start or stop the trigger 
    if(!triggSet.DisableTrigger__c)
        {
        taskHandler.createTask(Trigger.new);
        }
    else 
        {
        System.debug('---------------Trigger Disabled');
        }*/
}
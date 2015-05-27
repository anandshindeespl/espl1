/*
*   Trigger  functionality :  It will update the count variable of parent campaign according campaignMember status
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   20 May 2015
 ===========================================================================================================================================
*/
trigger CampaignMemberTrigger on CampaignMember (after delete, after insert, after update) {
    
   CampaignMemberTriggerHndler campHandler =new CampaignMemberTriggerHndler();
    
    //fire after insert new campaignMember
    if(trigger.isInsert && trigger.isAfter)
    {
       campHandler.CountStatusForInsert(trigger.new);
    }
    
    //fire after deletion of campaignMember
    if(trigger.isDelete && trigger.isAfter)
     {
       campHandler.CountStatusForDelete(trigger.old);
     }
     
     //fire after updation of campaignMember
     if(trigger.isUpdate && trigger.isAfter)
     {
       campHandler.CountStatusForUpdate(trigger.old, trigger.new );
     }
}
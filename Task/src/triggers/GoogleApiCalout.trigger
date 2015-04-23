/**
*       After the insertion of Email_Query__c ,this trigger will fire 
*       and it will call the google api and fetch the result links in json format and store it 
 ========================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   19 Feb 2015
 ========================================================================================================
**/
trigger GoogleApiCalout on Email_Query__c (after insert) 
    {
        if(Trigger.isInsert)
            {
                new GoogleApiCalout().caloutAndGetResult(trigger.new);
            }
    }
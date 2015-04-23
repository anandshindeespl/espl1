/**
*    BatchEmailProcessor will call method which call google API and fetch the result in JSON ,deserialize it and
*    send responce back through email
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   20 Feb 2015
 ===========================================================================================================================================
 **/
    global class BatchEmailProcessor implements Database.Batchable<sObject> {
    
    //start method to fetch the records from Email_Query__c and pass it to execute method
    global Database.QueryLocator start(Database.BatchableContext BC)
        {
            return Database.getQueryLocator([select Result_Status__c,Query_result__c,Search_Query__c,From_Email__c ,
                                            From_Name__c,Related_Contact__c from Email_Query__c where Result_Status__c=FALSE]);
        }
        
        //execute method will call batch handler to execute actual logic
        global void execute(Database.BatchableContext BC, List <Email_Query__c> queryList)
            {
                new BatchEmailHandler().processandEmailResponse(queryList);
            }
    public void finish(Database.BatchableContext BC)
        {
        }   
}
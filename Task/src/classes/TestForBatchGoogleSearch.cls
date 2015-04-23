/**
*  This test class will check the behaviour of email functionality of batch class
*  to check whether email send in bulk or not
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   25 Feb 2015
 ===========================================================================================================================================
 **/
@isTest
private class TestForBatchGoogleSearch {

    static testMethod void myUnitTest() {
    	
    	//to store the jsonresult in Email_Query_result__c table
        String resultlinks=JsonString.searchResponse;
        Email_Query_result__c eqResult=new Email_Query_result__c();
        eqResult.Query_Result_Links__c=resultlinks;
        insert eqResult;
        
       //insert a new contact
        Contact contact = new Contact();
        contact.LastName = 'Salesforce';
        contact.Email = 'test.salesforce@test.com';
        insert contact;
        
        //create a list to insert bulk records for email processing.
        List <Email_Query__c> queryList=new List<Email_Query__c>();
        for(Integer i=0;i<150;i++)
        {
        Email_Query__c equery=new Email_Query__c();
        equery.Result_Status__c=FALSE;
        equery.Query_result__c=eqResult.id;
        equery.Search_Query__c='salesforce';
        equery.From_Email__c='test.salesforce@test.com'; 
        equery.From_Name__c='Salesforce';
        equery.Parent_Query_Id__c=null;
        equery.Related_Contact__c=contact.ID;
        queryList.add(equery);
        }
        insert queryList;
        //this will call the batch and check asset output
        Test.startTest();
        BatchEmailProcessor batchobj = new BatchEmailProcessor();
        database.executebatch(batchobj,200);
        Test.stopTest();
        
        list <Email_Query__c> eqlist=[select Result_Status__c,Query_result__c,Search_Query__c,From_Email__c ,From_Name__c,Related_Contact__c from Email_Query__c where Result_Status__c=FALSE];
        system.assertEquals(eqlist.size(),0);
       
      }

}
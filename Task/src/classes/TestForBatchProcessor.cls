/**
 * This class contains unit tests for validating the behavior of Apex classes
 
 */
@isTest
private class TestForBatchProcessor {

    static testMethod void myUnitTest() {
    	
    	Event__C event=new Event__C();
    	event.JSON__c='{"Name":"Holi"}';
    	event.Object_Name__c='Account';
    	event.Status__c='New';
    	insert event;
        
        BatchProcessor batchobj = new BatchProcessor();
        database.executebatch(batchobj);
        
        List <Account> accountlist=new List<Account>();
        accountlist=[select Id from Account where Name='Holi' ];
        system.assertNotEquals(1,accountlist.size()); 
    }
}
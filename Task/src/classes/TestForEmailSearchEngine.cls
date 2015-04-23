/**
*    test class to chech email search query is received or not
*    to check whether contact is cereated or not for related search String
*    test whether email query record is created or not
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   25 Feb 2015
 ===========================================================================================================================================
 **/
@isTest(SeeAllData=true)
private class TestForEmailSearchEngine {

    static testMethod void myUnitTest() 
    {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
       
        //to check whether this contact is already present or not
        List <Contact> contList1=[select Id from Contact where LastName='Salesforce'];
        system.assertEquals(0,contList1.size());
        
        email.fromAddress = 'test.salesforce@test.com';
        email.fromName = 'Salesforce';
        email.subject = 'Custom Serach Engine';
        email.plainTextBody = 'Components in Visual Force';
        
        Test.startTest(); 
        EmailServices emailSearch = new EmailServices();
        Messaging.InboundEmailResult result = emailSearch.handleInboundEmail(email, envelope);
        Test.stopTest();
        
        //to check whether contact is cereated or not for related search String
        List <Contact> contList=[select Id from Contact where LastName='Salesforce'];
        system.assertEquals(1,contList.size());
        
        //to check whether email is received or not
        system.assertEquals(result.success, true);
        
        //test whether email query record is created or not
        List <Email_Query__C> eqList=[select Id from Email_Query__C where Search_Query__c='Components in Visual Force'];
        system.assertEquals(1,eqList.size());
    }
    
    //if contact is present then it will not create new contact and execute in a smooth way.
    static testMethod void testforContact() {

        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        Contact contact = new Contact();
        contact.LastName = 'Salesforce';
        contact.Email = 'test.salesforce@test.com';
        insert contact;
           
        email.fromAddress = 'test.salesforce@test.com';
        email.fromName = 'Salesforce';
        email.subject = 'Custom Serach Engine';
        email.plainTextBody = 'Components in Visual Force';
        
        Test.startTest(); 
        EmailServices emailSearch = new EmailServices();
        Messaging.InboundEmailResult result = emailSearch.handleInboundEmail(email, envelope);
        
        system.assertEquals(result.success, true);
        
        Test.stopTest();
    }
    
        //to check for approval process from  opportunity custom class 
        //this wilil check for specified email address 
    static testMethod void testforContactSpecificEmail() {
    	Test.startTest(); 
    	//Manager_Email__c mailAddress= Manager_Email__c.getInstance(); //get custom email address
        //String addr=mailAddress.Mngr_Email__c;
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        email.fromAddress ='anandshindeespl@gmail.com';
        email.fromName = 'Salesforce';
        email.subject = 'Custom Serach Engine';
        email.plainTextBody = 'id,006280000025IiYAAU';
        
        EmailServices emailSearch = new EmailServices();
        Messaging.InboundEmailResult result = emailSearch.handleInboundEmail(email, envelope);
        
        system.assertEquals(result.success, true);
        
        Test.stopTest();
    }
}
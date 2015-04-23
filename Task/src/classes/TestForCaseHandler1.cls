/**
 * To check whether Account id is created in Case or not.
 */
@isTest
private class TestForCaseHandler1 {

    static testMethod void myUnitTest() 
    {
        Case caseo=new Case();
        List<Case> caseobj=new List<Case>();
        
        caseo.Email_Id__c='anandshinde@gmail.com';
        caseo.Status='New';
        caseo.Origin='Email';
        
        
        Account objAccount=new Account();
        objAccount.Name='Maharashtra';
        objAccount.Email_Id__c='anandshinde@gmail.com';
        insert objAccount;
        
     
        
    }
}
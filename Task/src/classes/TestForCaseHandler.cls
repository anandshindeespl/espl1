/**
 * To check whether Account id is created in Case or not.
 */
@isTest
private class TestForCaseHandler {

    static testMethod void myUnitTest() 
    {
        
        Account objAccount=new Account();
        objAccount.Name='Maharashtra';
        objAccount.Email_Id__c='anandshinde@gmail.com';
        insert objAccount;
        
        Case caseobj=new Case();
        caseobj.Email_Id__c='anandshinde@gmail.com';
        caseobj.Status='New';
        caseobj.Origin='Email';
        insert caseobj;
        
        List<Case>caselist=new List<Case>();
        caselist=[select Account_ID__c from Case where Email_Id__c='anandshinde@gmail.com' and Account_ID__c <> null ];
        system.assertEquals(1,caselist.size());
        
    }
}
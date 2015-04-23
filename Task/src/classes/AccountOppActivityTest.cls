/*
*   test class to check authentication of user and whether Account and related oportunities gets fetch or not
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |  3 march 2015
 ===========================================================================================================================================
 */
@isTest
private class AccountOppActivityTest {

    static testMethod void myUnitTest() {
    	
        PageReference Pageref=Page.LoginAccount;
        System.test.setCurrentPageReference(Pageref);
        AccountOppActivity accActivity=new AccountOppActivity();
        
        User user=new user();
        user.id=UserInfo.getUserId();
        user.Username=UserInfo.getUsername();
        update user;
        
        //check for wrong Username and Password
        accActivity.validateUser();
        system.assertEquals(0,accActivity.loginList.size());
        
        Login__c loginuser = new Login__c();
        loginuser.User_Name__c ='anand.shinde@eternussolutions.com';
        loginuser.password__c = '24339981';
        insert loginuser;
        
        //insert Account 
        Account account = new Account();
        account.Name = 'ESPL';
        account.OwnerId =user.Id;
        insert account;
        
        //insert Opportunity
        Opportunity opprtunity = new Opportunity();
        opprtunity.Name = 'opp1';
        opprtunity.AccountId = account.Id;
        opprtunity.StageName = 'Prospecting';
        opprtunity.CloseDate = system.Today(); 
        insert opprtunity;
        
        Opportunity opprtunity2 = new Opportunity();
        opprtunity2.Name = 'Opp2' ;
        opprtunity2.AccountId = account.Id;
        opprtunity2.StageName = 'Prospecting';
        opprtunity2.CloseDate = system.Today(); 
        insert opprtunity2;


        //check whether 
        accActivity.username='anand.shinde@eternussolutions.com';
        accActivity.password='24339981';
        accActivity.validateUser();
        system.assertNotEquals(0,accActivity.loginList.size());
        
        accActivity.UpdateOpp();
        system.assertEquals(0,accActivity.opplst.size());
        
    }
}
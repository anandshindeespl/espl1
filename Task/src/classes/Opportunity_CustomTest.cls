/**
*  to check whether opp updated,deleted or not
*  to check whether delete request sent or not
*  
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |    9th Feb 2015
 ===========================================================================================================================================
 **/
@isTest
private class Opportunity_CustomTest {

    static testMethod void myUnitTest() {
        PageReference pageref=Page.Opportunity_Custom;
        system.Test.setCurrentPageReference(pageref);
     
        //create opp for test data
        Opportunity opportunity1=new Opportunity();
        opportunity1.Name = 'TestOpp';
        opportunity1.StageName = 'Prospecting';
        opportunity1.DeleteFlag__c=false;
        opportunity1.amount=10000;
        opportunity1.CloseDate = system.Today(); 
        insert opportunity1;
        
        Opportunity oppobj = new Opportunity();
        ApexPages.StandardController sc = new ApexPages.standardController(oppobj);
        Opportunity_Custom customOpp = new Opportunity_Custom(sc);
        
        //set oppportunity value for Opportunity object in class 
        Opportunity opportunity2=new Opportunity();
        customOpp.opportunity.id=opportunity1.Id;
        customOpp.opportunity.stagename='Qualification';
        customOpp.opportunity.amount=50000;
        customOpp.opportunity.closedate=system.Today();
        test.startTest();
        customOpp.updateOpportunity();
        opportunity oppobject=[select id ,amount from opportunity where id=:opportunity1.Id];
        system.assertequals(50000,oppobject.amount);
        test.StopTest();
    }
    
    
    static testMethod void deleteTest() {
    	PageReference pageref=Page.Opportunity_Custom;
        system.Test.setCurrentPageReference(pageref);
     
        //create opp for test data
        Opportunity opportunity1=new Opportunity();
        opportunity1.Name = 'TestOpp';
        opportunity1.StageName = 'Prospecting';
        opportunity1.DeleteFlag__c=false;
        opportunity1.amount=10000;
        opportunity1.CloseDate = system.Today(); 
        insert opportunity1;
        
        Opportunity oppobj = new Opportunity();
        ApexPages.StandardController sc = new ApexPages.standardController(oppobj);
        Opportunity_Custom customOpp = new Opportunity_Custom(sc);
        
        //to check delete request is sent or not
        test.startTest();
        ApexPages.CurrentPage().getparameters().put('oppId', opportunity1.Id);
        ApexPages.currentPage().getParameters().put('oppname',opportunity1.Name);
        ApexPages.currentPage().getParameters().put('oppcheck','false');
        customOpp.deleteOpportunity();
        system.assertNotEquals(0,customOpp.bodyList.size());

        //to check whether opp deleted or not
        ApexPages.CurrentPage().getparameters().put('oppId', opportunity1.Id);
        ApexPages.currentPage().getParameters().put('oppname',opportunity1.Name);
        ApexPages.currentPage().getParameters().put('oppcheck','true');
        customOpp.deleteOpportunity();
        
        list <Opportunity> opplist=[select name from Opportunity where Id=:opportunity1.Id];
        system.assertEquals(0,opplist.size());
        test.stopTest();
    }
}
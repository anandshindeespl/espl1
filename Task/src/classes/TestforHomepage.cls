/**
        Test Class for homepage Vf page which display the records according to list view 
 */
@isTest
private class TestforHomepage {

    static testMethod void myUnitTest() 
    {
    	
       
        PageReference pageref=Page.Campaign_Detail;
        system.Test.setCurrentPageReference(pageref);
        
        Campaign campaign=new Campaign();
        campaign.Name='TestClassCamp';
        campaign.Last_Modified_Date__c=System.Today();
        insert campaign;
        
  
        campaign=[select Id from Campaign where Name='TestClassCamp'];
        ApexPages.CurrentPage().getparameters().put('campid', campaign.Id);
        ApexPages.StandardController sc = new ApexPages.standardController(campaign);
        
        CampaignDetailPage campdetailpage=new CampaignDetailPage(sc);
        
         //test for updation of records
        //List<Campaign>camplst=new List<Campaign>();
        campaign.Name='Test';
        //update camplst;
        campdetailpage.updateCamp();
        //update campaign;
        List <Campaign>campUpdate=new List<Campaign>();
        campupdate=[select Id from Campaign];
        system.assertEquals(1,campupdate.size());
        
        //test for deletion of records
        List<Campaign> allrecords = [Select Id From Campaign];
        campdetailpage.deleteRecord();        
        List <Campaign> records=[select Id from Campaign];
        Integer i=records.size()-1;
        system.assertEquals(records.size(),allrecords.size()-1);
      
    }
}
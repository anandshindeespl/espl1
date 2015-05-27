/**
*   Test class would checks whether trigger will fired or not.
*   It would also check for whether RSVPcount variable in Campaign is updated or not.
*...It will Check the RSVP count after insert, update, delete operation on CampaignMember. 
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   25 May 2015
 ===========================================================================================================================================
**/
@isTest
private class CampaignMemberTriggerHndlerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Contact cont=new Contact();
        cont.LastName='espl';
        insert cont;
        
        Contact cont2=new Contact();
        cont2.LastName='espl22';
        insert cont2;
        
        Campaign superCamp=new Campaign();
        superCamp.Name='Blood Donation' ;
        insert superCamp;
        
        //Create child campaign
        Campaign Camp=new Campaign();
        Camp.Name='TV Campaign' ;
        Camp.ParentID=superCamp.id;
        insert Camp;
        
        //create CampaignMemberStatus for each Campaign
        CampaignMemberStatus cms1 = new CampaignMemberStatus( CampaignId=camp.Id, 
                                                              Label='RSVP Yes',
                                                              IsDefault=false,
                                                              HasResponded=true,
                                                              SortOrder=3 );
        insert cms1 ;
                                                              
        CampaignMemberStatus cms2 = new CampaignMemberStatus( CampaignId=camp.Id, 
                                                              Label='RSVP No',
                                                              IsDefault=false,
                                                              HasResponded=false,
                                                              SortOrder=4);
        insert cms2 ;
        //insert new List<CampaignMemberStatus>{cms1,cms2};
        
        //Check RSVP count Before any insert operation 
        list<Campaign> campList1=[select RSVP_Count__c from Campaign where id=: camp.id];
        system.assertEquals(null,campList1.get(0).RSVP_Count__c);
        
        //list<CampaignMember> lstCampMember =new list<CampaignMember>();
        CampaignMember cm=new CampaignMember();
        cm.CampaignId = camp.id;
        cm.status='RSVP Yes';
        cm.ContactId=cont.id;
        
        CampaignMember cm2=new CampaignMember();
        cm2.CampaignId = camp.id;
        cm2.status='RSVP No';
        cm2.ContactId=cont2.id;
        
        insert new list<CampaignMember>{cm,cm2} ;
        
        //Check RSVP count after insert operation 
        list<Campaign> campList2=[select id, RSVP_Count__c,RSVP_No__c from Campaign where id=: camp.id];
        system.assertEquals(1,campList2.get(0).RSVP_Count__c);
        system.assertEquals(1,campList2.get(0).RSVP_No__c);
        
        //Check RSVP count after update  operation 
        list<CampaignMember> lstcmsYes=[select id, status from CampaignMember where id=: cm.id];
        lstcmsYes.get(0).status='RSVP No';
        update lstcmsYes;
        
        list<CampaignMember> lstcmsYes2=[select id, status from CampaignMember where id=: cm2.id];
        lstcmsYes2.get(0).status='RSVP Yes';
        update lstcmsYes2;
        
        list<Campaign> lstUpdateCount=[select id, RSVP_Count__c,RSVP_No__c from Campaign where id=: camp.id];
        system.assertEquals(1,lstUpdateCount.get(0).RSVP_Count__c);
        system.assertEquals(1,lstUpdateCount.get(0).RSVP_No__c);
        
        //Check RSVP count after delete  operation
        list<CampaignMember> lstcmsYes3=[select id, status from CampaignMember where id=: cm.id];
        delete lstcmsYes3;        
        
        list<CampaignMember> lstcmsNo2=[select id, status from CampaignMember where id=: cm2.id];
        delete lstcmsNo2;
        
        list<Campaign> lstdeleteCount=[select id, RSVP_Count__c,RSVP_No__c from Campaign where id=: camp.id];
        system.assertEquals(0,lstdeleteCount.get(0).RSVP_Count__c);
        system.assertEquals(0,lstdeleteCount.get(0).RSVP_No__c);
    }
}
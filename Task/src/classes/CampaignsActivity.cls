/**
*   Class to display the list view records
***/

public class CampaignsActivity
{
        public List<Campaign> camplist{get;set;}
        public List<Campaign> lst;
        public List<Campaign> activelist{get;set;}
        public String pickvalue{get;set;}

        ApexPages.StandardSetController ssc ;

        public CampaignsActivity(ApexPages.StandardController controller)
        {
                camplist=new List<Campaign>();
                lst=[select Id,Name,StartDate,Status from Campaign where Last_Modified_Date__c= TODAY Order By Last_Modified_Date__c  DESC ];
                ssc = new ApexPages.StandardSetController(lst);
                ssc.setPageSize(5);
                camplist=(List<Campaign>)ssc.getRecords();

        }
        //Functions for get the data according to list view    
        public void creatUser()
        {
                if(pickvalue =='All Active Campaigns')
                        {
                                lst=[select Id,Name,StartDate,Status from Campaign where IsActive=TRUE Order By StartDate DESC];
                                ssc = new ApexPages.StandardSetController(lst);
                                ssc.setPageSize(5);
                                camplist=(List<Campaign>)ssc.getRecords();
                        }

                if(pickvalue =='Recently Modified')
                        {
                                lst=[select Id,Name,StartDate,Status from Campaign where Last_Modified_Date__c= TODAY Order By Last_Modified_Date__c  DESC];
                                ssc = new ApexPages.StandardSetController(lst);
                                ssc.setPageSize(5);
                                camplist=(List<Campaign>)ssc.getRecords();           
                        }

                if(pickvalue =='Inactive Campaigns')
                        {
                                lst=[select Id,Name,StartDate,Status from Campaign where IsActive=FALSE Order By StartDate DESC];
                                ssc = new ApexPages.StandardSetController(lst);
                                ssc.setPageSize(5);
                                camplist=(List<Campaign>)ssc.getRecords();        
                        }

                if(pickvalue =='All Campaigns')
                        {
                                lst=[select Id,Name,StartDate,Status from Campaign];
                                ssc = new ApexPages.StandardSetController(lst);
                                ssc.setPageSize(5);
                                camplist=(List<Campaign>)ssc.getRecords();
                        }

        }

                public void firstPage()
                        {
                                ssc.first();
                                camplist=ssc.getRecords();
                        }
                public void nextPage()
                        {
                                ssc.next();
                                camplist=ssc.getRecords();
                        }
                public void previousPage()
                        {
                                ssc.previous();
                                camplist=ssc.getRecords();
                        }
                public void lastPage()
                        {
                        ssc.last();
                        camplist=ssc.getRecords();

                        }
}
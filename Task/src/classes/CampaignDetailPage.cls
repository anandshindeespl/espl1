/***
***  Class to display details of selected record and perform DML Operation
*/

public class CampaignDetailPage
{
    Id camp = ApexPages.CurrentPage().getparameters().get('campid');
    public Campaign record{get;set;}
    public boolean detail{get;set;}
    public boolean edit{get;set;}
    public Campaign deleteCamp{get;set;}
    public Campaign updateCamp{get;set;}
   
    /**** method to fetch records using id */
    public CampaignDetailPage(ApexPages.StandardController controller)
        {
           detail=true;
           edit=false;
           record= [ Select Type,Status,StartDate,ParentId,OwnerId, Name, LastModifiedById, 
                     LastActivityDate, EndDate,Description,CreatedById  From Campaign where Id = : camp ];
        }
        
        /** to swap the rendered Values**/
    public void editBlock()
        {
             System.debug('---------------in editblock'); 
             detail=false;
             edit=true;
        }
        
    /** function to delete the record **/
    public PageReference deleteRecord()
         {
            PageReference page=new PageReference('/apex/homepage');
            deleteCamp=[Select Id From Campaign where Id=: camp ];
            delete deleteCamp;
            page.setRedirect(true);
            return page;
           }

	/*****Function to update the campaign Record ***/
	public PageReference updateCamp()
         {
              updateCamp=new Campaign();
              PageReference pageupdate=new PageReference('/apex/homepage');
              updatecamp.Id=camp;
              updatecamp.Type=record.Type ;
              updatecamp.Status=record.Status;
              updatecamp.StartDate=record.StartDate;
              updatecamp.ParentId=record.ParentId;
              updatecamp.OwnerId=record.OwnerId;
              updatecamp.Name=record.Name;
              updatecamp.EndDate=record.EndDate;
              updatecamp.Description=record.Description;
              update updatecamp ;
              pageupdate.setRedirect(true);
              return pageupdate;
           }

}
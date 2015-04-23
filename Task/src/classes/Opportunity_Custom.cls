/**
*  this class will get the all opportunity related with login user and display on vf page
*  Also update and delete the opportunity and send delete request for approval
*  
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |    6th Feb 2015
 ===========================================================================================================================================
 **/
public class Opportunity_Custom{

     public Opportunity opportunity{get;set;}
     public List<Opportunity> opportunities{get;set;}
     public list <String> bodyList{get;set;}
     
     public Opportunity_Custom(ApexPages.StandardController controller) {
        opportunity=new Opportunity();
        opportunities=new List<Opportunity>();
        bodyList=new list<String>();
        opportunities=[select id,name,stagename,amount,closedate,DeleteFlag__c, Delete_Request_Flag__c from opportunity where OwnerId =:UserInfo.getUserId()];
     }
     
     //function will will send delete approval request or delete opp after getting approval
     public void deleteOpportunity(){
     	try{
                String oppId=ApexPages.currentPage().getParameters().get('oppId');
                String oppName=ApexPages.currentPage().getParameters().get('oppname');
                String check =ApexPages.currentPage().getParameters().get('oppcheck');
                system.debug('******check*****'+check);
                    if(check.equals('false'))
                    {
                        //set delete request flag true in opp
                        list<Opportunity> oppLst=[select Id, Delete_Request_Flag__c from Opportunity where Id=:oppId ];
                            for(Opportunity oopp:oppLst)
                            {
                            	oopp.Delete_Request_Flag__c=true;
                            	for(Opportunity opps:opportunities)
                                    {
                                     if(opps.id==oopp.id)
                                         {
                                             opps.Delete_Request_Flag__c=true;
                                             break;
                                         }
                                    }
                            }
                            update oppLst;
                            bodyList.add('in delete Request');
                        Manager_Email__c mailAddress= Manager_Email__c.getInstance(); //to get manager email id from custom settings
                        //send delete approval request through email 
                        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                        // Step 2: Set list of people who should get the email
                        List<String> sendTo = new List<String>();
                        sendTo.add(mailAddress.Mngr_Email__c);
                        mail.setToAddresses(sendTo);
                        
                        // Step 3: Set who the email is sent from
                        mail.setReplyTo(mailAddress.Org_Email__c);
                        mail.setSenderDisplayName('Opportunuty deletion Activity');
                            
                        // Step 4. Set email contents - you can use variables!
                        mail.setSubject('Need Approval for opportunity '+oppName + 'deletion');
                        String body='';
                        body += 'Hi ,</br>';
                        body +='Respected Manager, </br></br>';
                        body +='Please approve delete permission for oppportunity <font color="red">'+oppName+'. id ,'+'</font>'+oppId+'</br>';
                        mail.setHtmlBody(body);
                        mails.add(mail);
                        Messaging.sendEmail(mails);  
                        system.debug('******mail*****');
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Delete request sent for Approval'));
                    }
                    
                    //else part to delete the opportunity directly
                    else
                    {
                        Opportunity op=[select id  from opportunity where id=:oppId];
                        system.debug('******indelete*****'+oppId);
                        Integer index=0;
                        for(Opportunity xopp:opportunities)
                        {
                            if(xopp.id==op.id){
                            delete op;
                            opportunities.remove(index);
                            break;
                            }
                            index++;
                        }
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, +oppName+' opportunity Deleted...'));
                    }
         
     	}
     	catch(Exception e)
     	{
     		system.debug(e);
     	}
     
     }
     
     //function to update the opp
         public void updateOpportunity()
         {
	         System.debug('update opportunity : '+opportunity);
	         Opportunity oppobj=new Opportunity();
	         oppobj.id=opportunity.id;
	         oppobj.stagename=opportunity.stagename;
	         oppobj.amount=opportunity.amount;
	         oppobj.closedate=opportunity.closedate;
	         for(Opportunity opp:opportunities)
	         {
                 if(opp.id==oppobj.id)
                 {
                     opp.stagename=oppobj.stagename;
                     opp.amount=oppobj.amount;
                     opp.closedate=oppobj.closedate;
                     break;
                 }
             }
         update oppobj;
        }
}
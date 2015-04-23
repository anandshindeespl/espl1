/**
 *  Email services are automated processes that use Apex classes
 *  to process the contents, headers, and attachments of inbound email.
 *  this class will receive the email get the parameters from the mail and
 *  process the data calout to google api and send result
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   18 Feb 2015
 ===========================================================================================================================================
 */
global class EmailServices implements Messaging.InboundEmailHandler {
            
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

        // Create an InboundEmailResult object for returning the result 
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
	
    try {
            String plaintext=email.plainTextBody;
            if(plaintext!='')
            {
            String body=plaintext.trim();
            Id contactId;
            String presult=null;
            
            //this code is for approval process only
            @testvisible
            Manager_Email__c mailAddress= Manager_Email__c.getInstance(); //to get manager email id from custom settings
            if(email.fromAddress.equals(mailAddress.Mngr_Email__c)){
            	String bdy=email.plainTextBody.trim();
            	String[] str=bdy.split(',');
            	String oppid=str[1];
            	list<Opportunity> oppList=[select id,DeleteFlag__c from Opportunity where Id=:oppid ];
            	for(Opportunity opp:oppList)
            	{
            		opp.DeleteFlag__c=true;
            	}
            	update oppList;
            }
            else{
            
            //search for queryString which is already present or not
            List<Email_Query__c> searchList =new List<Email_Query__c>();
            searchList = [SELECT Id,Query_result__c, Search_Query__c FROM Email_Query__c where Search_Query__c = :body];
            system.debug('----------'+searchList.size()) ;  
            
            //search for contact which is already present or not
            List <Contact>contact=new List<Contact>();
            contact = [SELECT Id, Name, Email FROM Contact WHERE Email = :email.fromAddress Limit 1];
            system.debug('--------contact--'+contact.size()) ;
            
    //to check contact is present or not. if not it will create new contact 
    if(contact.size()!=0)
        {
            for(Contact cont:contact)
                {
                    contactId=cont.Id;
                }
            if(searchList.size()!=0)
                {
                    system.debug('--------ii--'+searchList.get(0).Id) ;
                    new EmailServices().insertEmail(email, searchList.get(0).Id,contactId,searchList.get(0).Query_result__c);
                }
            else
                {
                    String id=null;
                    new EmailServices().insertEmail(email, id, contactId,presult);
                }
        }
    else
        {
            // create new contact
            Contact cntactobj=new Contact();
            cntactobj.LastName=email.fromName;
            cntactobj.Email=email.fromAddress;
            insert cntactobj;
            
            if(searchList.size()!=0)
                {
                    new EmailServices().insertEmail(email, searchList.get(0).Id, cntactobj.Id,searchList.get(0).Query_result__c);
                }
            else
                {
                    String id=null;
                    new EmailServices().insertEmail(email, id, cntactobj.Id,presult);
                }
        } 
      }
            }
   }
    catch (QueryException e) 
        {
            System.debug('Query Issue: ' + e);
        }
            // Set the result to true. No need to send an email back to the user 
            //result.success = true;
            return result;
        }
        
    //function to insert emailquery
    public void insertEmail(Messaging.InboundEmail email, String extid, Id contactId, String presult)
        {
            system.debug('ext'+extid);
            Email_Query__c  emailquery=new Email_Query__c();
            emailquery.Search_Query__c= email.plainTextBody;
            emailquery.From_Email__c = email.fromAddress;
            emailquery.From_Name__c = email.fromName;
            emailquery.Subject__c = email.subject;
            emailquery.Parent_Query_Id__c=extid;
            emailquery.Related_Contact__c=contactId;
            emailquery.Query_result__c=presult;
            emailquery.Result_Status__c=FALSE;
            insert emailquery;
        }
}
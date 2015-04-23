/**
*       batch handler will call to google api fetch the result in JSON ,deserialize it and
*       send responce back through email
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   18 Feb 2015
 ===========================================================================================================================================
 **/
    global class BatchEmailHandler {
    
    //batch handler will call to google api fetch the result in JSON ,deserialize it and
    //send responce back through email
    global void processandEmailResponse(List <Email_Query__c> queryList)
        {
        	try
            {
                String result;
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                for(Email_Query__c equery : queryList)
                    {   
                        // Step 1: Create a new Email
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        // Step 2: Set list of people who should get the email
                        List<String> sendTo = new List<String>();
                        sendTo.add(equery.From_Email__c);
                        mail.setToAddresses(sendTo);
                        
                        // Step 3: Set who the email is sent from
                        mail.setReplyTo('anand.shinde@eternussolutions.com');
                        mail.setSenderDisplayName('Salesforce Search Engine Result');
                        mail.setTargetObjectId(equery.Related_Contact__c);
                        Id id='00X28000000YOSF';
                        mail.setTemplateId(id);
                        mail.setWhatId(equery.Id);
                        mail.setSaveAsActivity(false);
                        mails.add(mail); 
                        equery.Result_Status__c=TRUE;
                        update equery;
                    }   
                        Messaging.sendEmail(mails); 
                        queryList.clear();
                        mails.clear();
            }
            
    catch(Exception e)
        {
        
        }
    }
}
/**
** Web service class to perform CRUD Operation on Lead
**/
global class SoapWebServices 
{
    //method for lead creation
    webService static String createLead(String lastName, String company, String status) 
    {
        Lead lead = new Lead();
        lead.LastName=lastName;
        lead.Company=company;
        lead.Status=status;
        insert lead;
        return 'Lead Successfully Created with Id '+lead.id;
    }
    
   //method for lead Deletion
    webService static String deleteLead( String lastName,String firstName,String email,String phone) 
    {
        List <Lead> leadList=new List<Lead>();
        leadList=[select Id from Lead where FirstName=:firstName and LastName=:lastName and Email=:email and Phone=:phone];
        if(leadList.size()!= null)
	        {
	        delete leadList;
	        return firstName+'  Lead Successfully Deleted' ;
	        }
       else
	       {
	       	 return 'Bad Data';
	       }
    }
   
    //method for lead Updation
    webService static String updateLead( String lastName,String firstName,String email,String phone) 
    {
        List <Lead> leadList=new List<Lead>();
        String id;
        leadList=[select Id ,Email ,Phone from Lead where FirstName=:firstName and LastName=:lastName ];
        if(leadList.size()!= null)
            {
            	for(Lead l:leadList)
            	{
		            l.Email=email;
		            l.Phone=phone;
		            id=l.Id;
                }
                    update leadList;
                    return 'Lead Successfullyt Updated with Id '+id;
            }
       else
           {
             return 'Bad Data';
           }
    }
}
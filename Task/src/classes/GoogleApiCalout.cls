/**
*   callout to fetch the results from google Api
*   parse the josn and store it on custom field
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   19 Feb 2015
 ===========================================================================================================================================
**/
public with sharing class GoogleApiCalout {
    
    public static String jsonResponse;
    //to check is serach query and search result allready exist or not
    public void caloutAndGetResult(List <Email_Query__c> queryList)
    {
        String searchString; 
        Id qid;
        String parentid; 
        String Rlinks;
        for(Email_Query__c equery : queryList)
        {
            searchString =equery.Search_Query__c.replaceAll( '\\s+', '%20');
            qid=equery.Id;
            parentid=equery.Parent_Query_Id__c;
            Rlinks=equery.Query_result__c;
        }
        system.debug('------------------rr'+Rlinks);
        
         callGoogleService(searchString, qid,Rlinks);
    }
    
    //callout to fetch links in json format
    @future(callout=true)
    public static void  callGoogleService(String searchString, Id qid,String Rlinks)
    {
        try
        {
            system.debug('---------iin calout----'+Rlinks);
            HttpRequest request = new HttpRequest();
            request.setHeader('Content-Type', 'application/json');
            String url = 'https://www.googleapis.com/customsearch/v1?key=AIzaSyB_DVzKRQFZYxP5XSPxLCP6GFbsE7iK0fU&cx=006899659569287428950:o-tjufatuia&q='+searchString;
            system.debug('url--------'+url);
            request.setEndpoint(url);
            request.setMethod('GET');
            if(Test.isRunningTest())
            {
            	jsonResponse=JsonString.searchResponse;
            }
            else
            {
            Http http = new Http();
            HTTPResponse response = http.send(request);
            jsonResponse=response.getBody();
            System.debug('>>>>>>>>>>>>>>>json>>>>>>>>>:'+jsonResponse);
            }
            //this will deserialize the incoming JSON 
            Map<String, Object> linkmap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
            system.debug('****Json*****'+ linkmap); 
            List<Object> ItemsList =(List<Object>) linkmap.get('items');
            system.debug('***Items******' + ItemsList); 
            
            List<String> linklst=new List<String>();
            for(Object Obj:ItemsList )
            {   
                map<string, Object> innerItemData = (map<string, Object>) Obj;
                String title=(String) innerItemData.get('title');
                title+='<br/>';
                String snippet=(String) innerItemData.get('snippet');
                snippet+='<br/>';
                String link='<a href="'+(String)innerItemData.get('link')+'">'+(String)innerItemData.get('link')+'</a>';
                link+='<br/><br/><br/>';
                
                linklst.add(title);
                linklst.add(snippet);
                linklst.add(link);
             }
            
                String body='' ;
                for(String str :linklst)
                    {
                        body+=str;
                    }
                system.debug ('Result.........'+Rlinks);
        
            //store deserialized json 
            //if result is already present override with new result
            Email_Query_result__c queryResult=new Email_Query_result__c();
            String resultQuryId;
            if(Rlinks != null)
            {
                system.debug('*********inif');
                List<Email_Query_result__c>	queryResultList=[select Query_Result_Links__c from Email_Query_result__c where Id=:Rlinks];
            	for(Email_Query_result__c emailQuery : queryResultList)
            	{
            		system.debug('*********inupdate');
            		emailQuery.Query_Result_Links__c=body;
            	}
            	update queryResultList;
            	resultQuryId=Rlinks;
            }
            //else get the new resultlinks and store it
            else
            {
                system.debug('*********inelse');
                queryResult.Query_Result_Links__c= body;
                queryResult.Query_Id__c=qid;
                queryResult.Send_Status__c=FALSE;
                insert queryResult;
                resultQuryId=queryResult.Id;
            }
        
                List <Email_Query__c> recList=[select Query_result__c from Email_Query__c where Id= :qid ];
                for(Email_Query__c query:recList )
                {
        	       query.Query_result__c=resultQuryId;
                }
                   update recList;
        }
    catch(Exception e)
        {
            system.debug(e);
        }
    }
}
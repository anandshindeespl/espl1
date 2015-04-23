/*
*   fetch the resultlinks from googleAPI and display the result on vf page
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   22 Feb 2015
 ===========================================================================================================================================
 */
public class VfSerachEngine
{
    public list<String> listString {get;set;}
    public String searchquery{get;set;}
    public List<String> linklst{get;set;}
    public String body{get;set;}
    public Boolean check{get;set;}
    
    public VfSerachEngine()
    {
        check=false;
        listString = new list<String>();
        for(Visual_Force_Query__c emailQuery : [select VF_Search_Query__c from Visual_Force_Query__c]){
            listString.add(emailQuery.VF_Search_Query__c);
        }
        system.debug('---listString---'+listString);
        linklst=new List<String>();
        searchquery='';
        linklst.add('');
        body='';
    }
    //to check is searchString null or not
    public void checkString()
    {
        if(searchquery!='')
        {
                searchResults();
        }
        else
        {
                body='';
        }
    }
    //fetch the results from googleAPI
    public void searchResults()
    {   
        try
        {
            check=true;
            searchquery=searchquery.trim();
            String searchString=searchquery.replaceAll( '\\s+', '%20');
            String jsonResponse;
            system.debug('---------iin calout----');
            HttpRequest request = new HttpRequest();
            request.setHeader('Content-Type', 'application/json');
            String url = 'https://www.googleapis.com/customsearch/v1?key=AIzaSyB_DVzKRQFZYxP5XSPxLCP6GFbsE7iK0fU&cx=006899659569287428950:o-tjufatuia&q='+searchString;
            
            //if condition will be used in test class execution context
            if(Test.isRunningTest())
            {
                jsonResponse=JsonString.searchResponse;
            }
            else
            {
                request.setEndpoint(url);
                request.setMethod('GET');
                Http http = new Http();
                HTTPResponse response = http.send(request);
                jsonResponse=response.getBody();
            }
            //this will deserialize the incoming JSON 
                Map<String, Object> linkmap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
                List<Object> ItemsList =(List<Object>) linkmap.get('items');
                linklst=new List<String>();
            for(Object Obj:ItemsList )
            {   
                map<string, Object> innerItemData = (map<string, Object>) Obj;
                String title='<b><font color="blue" size="3">'+(String) innerItemData.get('title')+'</font></b>';
                title+='<br/>';
                String snippet=(String) innerItemData.get('snippet');
                snippet+='<br/>';
                String link='<a href="'+(String)innerItemData.get('link')+'" style="color:green">'+(String)innerItemData.get('link')+'</a>';
                link+='<br/><br/><br/>';
                
                linklst.add(title);
                linklst.add(snippet);
                linklst.add(link);
            }
            
                body='' ;
                for(Integer i=0; i<linklst.size()/2; i++)
                {
                        body+=linklst.get(i);
                }
                //storing serchString
                List <Visual_Force_Query__c> vfList=[select VF_Search_Query__c from Visual_Force_Query__c where VF_Search_Query__c=:searchquery];
            if(vfList.size()==0)
                {
                    Visual_Force_Query__c vfquery=new Visual_Force_Query__c();
                    vfquery.VF_Search_Query__c=searchquery;
                    insert vfquery;
                }
        }
        catch(Exception e)
        {
                check=false;
                body='<p><font color="red">No result found</font></p>';
                system.debug(e);
        }       
    }
    
    //method to get previous results 
    public void prev()
    {
        body='';
        for(Integer i=0; i<(linklst.size()/2); i++)
        {
            body+=linklst.get(i);
        }
    }
    
    ////method to get next results
    public void next()
    {
        body='';
        for(Integer i=(linklst.size()/2); i<(linklst.size()); i++)
        {
            body+=linklst.get(i);
        }
    }

}
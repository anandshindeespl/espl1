/*
*  class to do authentication of user and fetch Account and related oportunities and display on vf page
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |  2 march 2015
 ===========================================================================================================================================
 */
public with sharing class AccountOppActivity {
    public String username{get;set;}
    public String password{get;set;}
    public list <Login__c> loginList{get;set;}
    public list <Account> accList{get;set;}
    public list <User> userList{get;set;}
    public list <Opportunity> oppList{get;set;}
    public map <String,list <WrapperOpp>> mapList{get;set;}
    public map <String,list <WrapperOpp>> mapList2{get;set;}
    public boolean check{get;set;}
    public boolean check2{get;set;}
    public String pickvalue{get;set;}
    public list<WrapperOpp> wrapList{get;set;}
    public list <Opportunity> opplst{get;set;}
    public AccountOppActivity()
    {
        check=true;
        check2=false;
        
    }
    
     public class WrapperOpp
    {
        public Opportunity oppobj{get;set;}
        public boolean isCheck{get;set;}
        public WrapperOpp(Opportunity oppobj,boolean isCheck)
        {
                this.oppobj=oppobj;
                this.isCheck=isCheck;
        }
    }
    
    public void validateUser()
    {
        try
        {
            loginList=[select id from Login__c where User_Name__c=:username and password__c=:password LIMIT 1];
            if(loginList.size()!=0)
            {
                userList=[select id from User where Username=:username ];
                String owner=userList.get(0).ID;
               
                accList=[select id ,Name from Account where OwnerId=:userList.get(0).Id ];
                List<String> accid=new List<String>();
                for(Account acc:accList){
                    accid.add(acc.id);
                }

                 //Get all Opportunity of all accounts
                mapList = new Map<String,List<WrapperOpp>>();
                
                //Account accountList=[select ]
                
                list <Account> accntList=[Select Id, Name From Account ];
                list<String>idlist=new list<String>();
                list<String>accNamelist=new list<String>();
                for(Account aclist :accntList){
                	idList.add(aclist.Id);
                	accNamelist.add(aclist.Name);
                }
                
                  list <Opportunity> oppoList=[Select Id, Name,AccountId, StageName From Opportunity where accountid in :idlist];
                    for(Account accc:accntList )
                    {
                           for(Opportunity oppo :oppoList)
                           {
                                if(oppo.accountid==accc.Id)
                                {
                                	wrapList = new List<WrapperOpp>();
                                    wrapList.add(new WrapperOpp(oppo,false));
                                    if(mapList.keySet().contains(accc.Name))
                                    {
                                        mapList.get(accc.Name).add(new WrapperOpp(oppo,false));
                                    }
		                            else
			                        {
			                            mapList.put(accc.Name,wrapList); 
			                        }
                                }
                           }     
                     }
            
                //this commented code is for limited query and governor limit will be hitted. 
                /* for(Integer i=0;i<50;i++)
                  {
                  for(Opportunity objOpp : [Select Id, Name,AccountId, StageName From Opportunity where accountid =:idlist.get(i)])
                   {
            
                            wrapList = new List<WrapperOpp>();
                            wrapList.add(new WrapperOpp(objOpp,false));
                            if(mapList.keySet().contains(accNamelist.get(i)))
                            {
                            	 mapList.get(accNamelist.get(i)).add(new WrapperOpp(objOpp,false));
                            }
                            else
                            {
                            mapList.put(accNamelist.get(i),wrapList); 
                            }
                   }
                  }*/
                  
                // this code get the parent from child
                /* Get all Opportunity of all accounts 
                mapList = new Map<String,List<WrapperOpp>>();
                for(Opportunity objOpp : [Select Id, Name,AccountId, StageName From Opportunity where accountid in :accid])
                {
                    if(mapList.keySet().contains(objOpp.AccountId))
                    {
                        List<WrapperOpp> wrapList = mapList.get(objOpp.AccountId);
                        if(wrapList==null)
                        {
                            mapList.put(objOpp.AccountId,new List<WrapperOpp>());
                        }
                            mapList.get(objOpp.AccountId).add(new WrapperOpp(objOpp,false));
                    }
                    else
                    {
                            wrapList = new List<WrapperOpp>();
                            wrapList.add(new WrapperOpp(objOpp,false));
                            mapList.put(objOpp.AccountId,wrapList);
                    }
                 }
                            check=false;
                            check2=true;
                }*/

                            check=false;
                            check2=true;
                }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Invalid UserName or Password')); 
            }
            
        }
        catch(Exception e)
        {
                system.debug(e);
        }    
        }
        //this function will get the selected opportunity and update the stage
        public void UpdateOpp()
        {
            opplst=new list<Opportunity>();
            for(List <WrapperOpp> wraplstt : mapList.Values())
            {
                for(WrapperOpp wrapperobj : wraplstt)
                {
                    if(wrapperobj.isCheck==true)
                    {
                        wrapperobj.oppobj.StageName=pickvalue;
                        opplst.add(wrapperobj.oppobj);
                    }
                }
            }
                update opplst;
        }

}
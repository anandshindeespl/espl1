/**
*   Trigger Handler functionality :  It will update the count variable of parent campaign according to RSVP status of campaignMember 
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   20 May 2015
 ===========================================================================================================================================
**/
public with sharing class CampaignMemberTriggerHndler {

    /***   method will be called after new campaign member insertion   *****/
    public void CountStatusForInsert(list<CampaignMember> CampMemberList)
    {
        map <String, list<String>> campMapp=new map<String,list<String>>();
        map <String, list<String>> campMappforNo=new map<String,list<String>>();
        
        for(CampaignMember cm :CampMemberList)
        {
            if(cm.Status=='RSVP Yes')
            {
                list<String>strList=new list<String>();
                strList.add(cm.id);
                if(campMapp.containsKey(cm.CampaignId))
                {
                    campMapp.get(cm.CampaignId).add(cm.id);
                }   else {
                            campMapp.put( cm.CampaignId,strList );
                         }
            }  
            
            if(cm.Status=='RSVP No')
            {
                list<String>strListNo=new list<String>();
                strListNo.add(cm.id);
                if(campMappforNo.containsKey(cm.CampaignId))
                {
                    campMappforNo.get(cm.CampaignId).add(cm.id);
                }   else {
                            campMappforNo.put( cm.CampaignId,strListNo );
                         }
            }     
        }
        
        if(campMapp.size() != 0)
        {
            insertYesCountMethod(campMapp);
        }
        
        if(campMappforNo.size() != 0)
        {
            insertNoCountMethod(campMappforNo);
        }
    }    
    
    public void insertNoCountMethod(map <String,list<String>> campMapp) {
       system.debug('campMapp'+campMapp);
       map<String,Decimal> mappSupercampaign=new map <String,Decimal>();
       List <Campaign>lstcampid=[select id,RSVP_No__c, ParentId from campaign where id in:campMapp.keyset()];
       for(Campaign camp :lstcampid)
        {
            Integer PrevCount;
            if(camp.RSVP_No__c==null)
            {
               PrevCount=0 ;
               camp.RSVP_No__c= PrevCount ;
               
            }  else {
                PrevCount=(Integer)camp.RSVP_No__c;
            }
            Integer y=campMapp.get(camp.id).size();
            camp.RSVP_No__c+= y ;
            Decimal countVal=(Decimal)(PrevCount+= y);
            
            if(camp.ParentId != null)
            {
                if(mappSupercampaign.containskey(camp.ParentId))
                {
                    Decimal val= mappSupercampaign.get(camp.ParentId) + y;
                     mappSupercampaign.put(camp.ParentId, val);
                } else {
                           mappSupercampaign.put(camp.ParentId, y);
                       }
            }
            update lstcampid;
            system.debug('supermapp****'+ mappSupercampaign);
            
            if(mappSupercampaign.size()!= 0)
            {
               String fieldValue='NO';
               superCampaignInsertCount(mappSupercampaign,fieldValue);
            }
        }
    }
    
    
    public void insertYesCountMethod(map <String,list<String>> campMapp)
    {
       system.debug('campMapp'+campMapp);
       map<String,Decimal> mappSupercampaign=new map <String,Decimal>();
       List <Campaign>lstcampid=[select id,RSVP_Count__c, ParentId from campaign where id in:campMapp.keyset()];
       for(Campaign camp :lstcampid)
        {
            Integer PrevCount;
            if(camp.RSVP_Count__c==null)
            {
               PrevCount=0 ;
               camp.RSVP_Count__c= PrevCount ;
               
            }  else {
                PrevCount=(Integer)camp.RSVP_Count__c;
            }
            Integer y=campMapp.get(camp.id).size();
            camp.RSVP_Count__c+= y ;
            Decimal countVal=(Decimal)(PrevCount+= y);
            
            if(camp.ParentId != null)
            {
                if(mappSupercampaign.containskey(camp.ParentId))
                {
                    Decimal val= mappSupercampaign.get(camp.ParentId) + y;
                     mappSupercampaign.put(camp.ParentId, val);
                } else {
                           mappSupercampaign.put(camp.ParentId, y);
                       }
            }
            update lstcampid;
            system.debug('supermapp****'+ mappSupercampaign);
            
            if(mappSupercampaign.size()!= 0)
            {
               String fieldValue='Yes';
               superCampaignInsertCount(mappSupercampaign, fieldValue);
            }
        }
    }
    
    /****   method will be called after deletion of campaign member record    *****/   
    public void CountStatusForDelete(list<CampaignMember> CampMemberList)
        {
            map <String, list<String>> campMapp=new map<String,list<String>>();
            map <String, list<String>> campMappforNo=new map<String,list<String>>();
            for(CampaignMember cm :CampMemberList)
            {
                 if(cm.Status=='RSVP Yes')
                 {
                    list<String>strList=new list<String>();
                    strList.add(cm.id);
                    if(campMapp.containsKey(cm.CampaignId))
                    {
                        campMapp.get(cm.CampaignId).add(cm.id);
                    }   else {
                                campMapp.put( cm.CampaignId,strList );
                             }
                 }
                 
                 if(cm.Status=='RSVP No')
                 {
                    list<String>strListNo=new list<String>();
                    strListNo.add(cm.id);
                    if(campMappforNo.containsKey(cm.CampaignId))
                    {
                        campMappforNo.get(cm.CampaignId).add(cm.id);
                    }   else {
                                campMappforNo.put( cm.CampaignId,strListNo );
                             }
                 }
            }
            
            if(campMapp.size() != 0)
	        {
	            deleteYesCountMethod(campMapp);
	        }
        
	        if(campMappforNo.size() != 0)
	        {
	            deleteNoCountMethod(campMappforNo);
	        }
    }
    
    public void deleteNoCountMethod(map <String,list<String>> campMapp)
    {
       system.debug('campMapp'+campMapp);
       map<String,Decimal> mappSupercampaign=new map <String,Decimal>();
       List <Campaign>lstcampid=[select id,RSVP_No__c, ParentId from campaign where id in:campMapp.keyset()];
       
       for(Campaign camp :lstcampid)
        {
            Integer PrevCount;
            if(camp.RSVP_No__c==null)
            {
               PrevCount=0 ;
               camp.RSVP_No__c= PrevCount ;
            }  else {
                PrevCount=(Integer)camp.RSVP_No__c;
            }
            integer y=campMapp.get(camp.id).size();
            
            if(PrevCount > y)
            {
                camp.RSVP_No__c=PrevCount- y ;
            }   else {
                        camp.RSVP_No__c= y-PrevCount ;
                     }
                     
            if(camp.ParentId != null)
            {
                if(mappSupercampaign.containskey(camp.ParentId))
                {
                    Decimal val= mappSupercampaign.get(camp.ParentId) + y;
                    mappSupercampaign.put(camp.ParentId, val);
                } else {
                           mappSupercampaign.put(camp.ParentId, y);
                       }         
        }
            update lstcampid;
             system.debug('supermapp****'+ mappSupercampaign);
            
            if(mappSupercampaign.size()!= 0)
            {
               String strflag = 'NoDelete';
               superCampaignDeletionCount(mappSupercampaign, strflag);
            }
        }
    }
    
    public void deleteYesCountMethod(map <String,list<String>> campMapp)
    {
       system.debug('campMapp'+campMapp);
       map<String,Decimal> mappSupercampaign=new map <String,Decimal>();
       List <Campaign>lstcampid=[select id,RSVP_Count__c, ParentId from campaign where id in:campMapp.keyset()];
       
       for(Campaign camp :lstcampid)
        {
            Integer PrevCount;
            if(camp.RSVP_Count__c==null)
            {
               PrevCount=0 ;
               camp.RSVP_Count__c= PrevCount ;
            }  else {
                PrevCount=(Integer)camp.RSVP_Count__c;
            }
            integer y=campMapp.get(camp.id).size();
            
            if(PrevCount > y)
            {
                camp.RSVP_Count__c=PrevCount- y ;
            }   else {
                        camp.RSVP_Count__c= y-PrevCount ;
                     }
                     
            if(camp.ParentId != null)
            {
                if(mappSupercampaign.containskey(camp.ParentId))
                {
                    Decimal val= mappSupercampaign.get(camp.ParentId) + y;
                    mappSupercampaign.put(camp.ParentId, val);
                } else {
                           mappSupercampaign.put(camp.ParentId, y);
                       }         
        }
            update lstcampid;
             system.debug('supermapp****'+ mappSupercampaign);
            
            if(mappSupercampaign.size()!= 0)
            {
               String strflag = 'YesDelete';
               superCampaignDeletionCount(mappSupercampaign, strflag);
            }
        }
    }
    
    /*****  method will be called after updation of campaign member record to increase or decrease in count variable ****/  
    public void CountStatusForUpdate(list<CampaignMember> OldCampMemberList, list<CampaignMember> NewCampMemberList)
    {
        list<CampaignMember> lstUpdateToNoOld=new list<CampaignMember>();
        list<CampaignMember> lstUpdateToNoNew=new list<CampaignMember>();
        list<CampaignMember> lstUpdateToYesNew=new list<CampaignMember>();
        list<CampaignMember> lstUpdateToYesOld=new list<CampaignMember>();
        for(CampaignMember cm :OldCampMemberList)
        {
             if(cm.Status=='RSVP Yes')
             {
                lstUpdateToNoOld.add(cm);
             }
             
             if(cm.Status=='RSVP No')
             {
                lstUpdateToYesOld.add(cm);
             }
        }    
             //call to the method to decrease the count because of updation to No
             CountStatusForDelete(lstUpdateToNoOld);
             CountStatusForDelete(lstUpdateToYesOld);
             
             
        for(CampaignMember cm :NewCampMemberList)
        {
             if(cm.Status=='RSVP Yes')
             {
                lstUpdateToYesNew.add(cm);
             }
             
             if(cm.Status=='RSVP No')
             {
                lstUpdateToNoNew.add(cm);
             }
        }    
             //call to the method to add count because of updation to Yes 
             CountStatusForInsert(lstUpdateToYesNew);
             CountStatusForInsert(lstUpdateToNoNew);
    }
    
    /**** This method will increase the count from parent Campaign  ****/
    public void superCampaignInsertCount(map<String ,decimal> supermapp , String fieldValue)
    {
         system.debug('fieldValue*11111** '+fieldValue);
         Integer intflag;
        if(fieldValue =='Yes')
        {
        List <Campaign>lstSupaercampid=[select id,RSVP_Count__c, ParentId from campaign where id in:supermapp.keyset()];
                for(Campaign lstSupercamp:lstSupaercampid)
                {
                    if(lstSupercamp.RSVP_Count__c==null)
                    {
                        intflag=0;
                        lstSupercamp.RSVP_Count__c= intflag + supermapp.get(lstSupercamp.id);
                    }   else {
                                 lstSupercamp.RSVP_Count__c+=supermapp.get(lstSupercamp.id);
                             }
                }
                update lstSupaercampid;
        }
        if(fieldValue =='No')
        {
        system.debug('fieldValue*** '+fieldValue);
        List <Campaign>lstSupaercampid=[select id,RSVP_No__c, ParentId from campaign where id in:supermapp.keyset()];
                
                for(Campaign lstSupercamp:lstSupaercampid)
                {
                    if(lstSupercamp.RSVP_No__c==null)
                    {
                        intflag=0;
                        lstSupercamp.RSVP_No__c= intflag + supermapp.get(lstSupercamp.id);
                    }   else {
                                lstSupercamp.RSVP_No__c= lstSupercamp.RSVP_No__c + supermapp.get(lstSupercamp.id);
                             }
                }
                update lstSupaercampid;
        }
    }
    
    /**** This method will decrease the count from parent Campaign  ****/
    public void superCampaignDeletionCount(map<String ,decimal> supermapp , String strflag)
    {
        if(strflag == 'YesDelete')
        {
        List <Campaign>lstSupaercampid=[select id,RSVP_Count__c, ParentId from campaign where id in:supermapp.keyset()];
                for(Campaign lstSupercamp:lstSupaercampid)
                {
                    if(lstSupercamp.RSVP_Count__c==null)
                    {
                        integer intflag=0; 
                        lstSupercamp.RSVP_Count__c = supermapp.get(lstSupercamp.id) - intflag ;
                    }
                    if(lstSupercamp.RSVP_Count__c > supermapp.get(lstSupercamp.id))
                    {
                        lstSupercamp.RSVP_Count__c-=supermapp.get(lstSupercamp.id);
                    }   else {
                        lstSupercamp.RSVP_Count__c = supermapp.get(lstSupercamp.id) - lstSupercamp.RSVP_Count__c ;
                    }
                }
                    update lstSupaercampid;
        }
        
        if(strflag == 'NoDelete')
        {
        List <Campaign>lstSupaercampid=[select id,RSVP_No__c, ParentId from campaign where id in:supermapp.keyset()];
                for(Campaign lstSupercamp:lstSupaercampid)
                {
                    if(lstSupercamp.RSVP_No__c==null)
                    {
                        integer intflag=0; 
                        lstSupercamp.RSVP_No__c = supermapp.get(lstSupercamp.id) - intflag ;
                    }
                    if(lstSupercamp.RSVP_No__c > supermapp.get(lstSupercamp.id))
                    {
                        lstSupercamp.RSVP_No__c-=supermapp.get(lstSupercamp.id);
                    }   else {
                        lstSupercamp.RSVP_No__c = supermapp.get(lstSupercamp.id) - lstSupercamp.RSVP_No__c ;
                    }
                }
                    update lstSupaercampid;
        }
    }
    }
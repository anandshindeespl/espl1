/*
 *  this class will receive the data in json format deserialise it and Create new custom setting records
 *  It also insert the multiple object dynamically and in given order .
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   13 April 2015
 ===========================================================================================================================================
 */
public with sharing class InsertMetaData {

    
    list<sobject> objectlist=new list<sObject>();
    
    //method to insert custom setting records and it will also calls the method which insert object records
        public void onInstall() {
            PageReference pageRef = new PageReference('/resource/ZipFiles/HIRCRM/CustomSettings/Settings.json');
            Blob contentAsBlob = pageRef.getContent();
            String contentAsText = contentAsBlob.toString();
            system.debug('andy1'+contentAsText); 
            
            //deserialize the incoming JSON Data. 
            Map<String, Object> mapp = (Map<String, Object>) JSON.deserializeUntyped(contentAsText);
            system.debug('mapp'+mapp);
            String keyvalue;
            //to get the key of mapp;
             list<object> obList=new list<object>();
             list<String> strList=new list<String>();
            for(String strkey :mapp.keyset()) {
                system.debug('keyvalue'+strkey);
               
                String str = JSON.serialize(mapp.get(strkey)); 
                strList.add(str);
            }
            system.debug('andy'+strList+'dfgdfg'+strList.size());
             Map<String ,object> mapp2 =new map<String,object>();
            for(String str :strList)
            {
               mapp2.putall((Map<String ,object>)JSON.DeserializeUntyped(str));
               
            }
              system.debug('mapp2'+mapp2);
        }
        
        public void InsertObject()
        {
	        String str='{"Contact": [{"LastName__c": "ESPL1", "Email__c": "espl@gmail.com", "Account_Topic_Id__c":{"External_Id__c": "Test1234" } }]}';
			Map<String, Object> mapp = (Map<String, Object>) JSON.deserializeUntyped(str);
			String child;
			for(String strr : mapp.keyset())
			{
				child=strr;
				break;
			}

			list<Object> strlist =new list<Object>();
			system.debug(mapp);
			list<object> objlist=(list <Object>)mapp.get('Contact');
			Map<String, Object> mapp6=new Map<String, Object>();
			for(Object accTopicList : objlist)
            {
                mapp6=(map<String ,Object>)accTopicList;
            }
            
			//Map<String, Object> mapp56=new Map<String, Object>();
			Map<String, Object> mapp111= new Map<String, Object>();
			String extRelationship;
			SObject childObject = Schema.getGlobalDescribe().get(child).newSObject();
			Schema.SObjectType targetType ;
			 sObject obj;
			for(String str5 : mapp6.keyset())
			{
			    
			    if(mapp6.get(str5) instanceof Map<String,Object>)
			    {
			        system.debug('pppp'+str5);
			        extRelationship=str5;
			        targetType = Schema.getGlobalDescribe().get('Account_Topic__c');
                    obj = targetType.newSObject();
			        String extdata=Json.serialize(mapp6.get(str5));
			        system.debug('extdata'+extdata);
			        mapp111 =(Map<String, Object>)JSON.deserializeUntyped(extdata);
			        system.debug('map111'+mapp111);
			        for(String str11 :mapp111.keyset()){
			        	obj.put(str11, mapp111.get(str11));
			        	//obj.str11=mapp111.get(str11);
			            break;
			        }
			        childObject.putSObject(str5, obj);
			        system.debug(obj);
			   }
			    else{
			        system.debug('second'+str5);
			        childobject.put(str5,mapp6.get(str5));
			        }
			        
			        objectlist.add(childObject);
			        /*SObject childObject = Schema.getGlobalDescribe().get(child).newSObject();
                    //will put the parent external id in lookfield of child. ie childParent association
                    // childObject.putSObject(fieldToUpdateDescribe.getRelationshipName(), obj); 
                    childObject.putSObject('extRelationship', obj);
                    childObject.put('LastName__c','espl');
                    //childObject.put('Account_Topic_Id__c','Test1234');
                    upsert childObject;*/
			}
			try
			{
				upsert objectlist;
			}
			catch(Exception e)
			{
				system.debug(e);
			}
			        
                
			        
			        } 

}
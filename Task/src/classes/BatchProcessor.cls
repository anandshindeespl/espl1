/**
**   Create Dynamic sobject and insert records into it using batch
**/
global class BatchProcessor implements Database.Batchable<sObject>  {
	global List<sObject> record=new List<SObject>();
	
	global Database.QueryLocator start(Database.BatchableContext bc) 
	{
		System.debug('----------------in Start');
		// method will return records and  assign to the execute method 
		return Database.getQueryLocator([select JSON__C,Object_Name__c from Event__C where Status__C='New']);
		//return Database.getQueryLocator('select JSON__C,Object_Name__c from Event__C where Status__C=\'New\'');
	}
    
    
    global void execute(Database.BatchableContext BC, List <Event__C> contactList)
    {
    	for(Integer i=0;i<contactList.size();i++)
    	{
    		//parse the string into json Map
	    	Map<String, Object> mapp = (Map<String, Object>) JSON.deserializeUntyped(contactList.get(i).JSON__C);
	    	system.debug('-----mapp***--------'+mapp);
	    	
	    	String typeName = contactList.get(i).Object_Name__C;
	    	System.debug('----------String is--'+typeName);
	    	
            List<Schema.Sobjecttype> lstObjects = Schema.getGlobalDescribe().values();

            //To Check if the sObject is present in the schema 
            Boolean objectTypePresent = false;
            for(Schema.Sobjecttype sObjType : lstObjects)
            {
                if(typeName.equalsIgnoreCase(sObjType.getDescribe().getLabel()))
                {
                    objectTypePresent = true;
                    break;
                }
            }
            if(!objectTypePresent){
                return;
            }
            // next two line will convert incoming String variable into Object 
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
            sObject obj = targetType.newSObject();
            
            // Map <String, Schema.SObjectField> fieldMap = schemaMap.get(obj).getDescribe().fields.getMap();
            SObjectType accountType = Schema.getGlobalDescribe().get(typeName);
            Map<String,Schema.SObjectField> fieldMap = accountType.getDescribe().fields.getMap();
          
              for(String s : mapp.keySet())
              {
                if(fieldMap.get(s)!=null)
                {
                    obj.put(s,mapp.get(s));
                }
              }  
            // Insert the sObject Record and update status 
            try{
                insert obj;
            }catch(Exception e){
                return;
            }
    	}
    }
    
    global void finish(Database.BatchableContext BC)
    {
    	   system.debug('-------------------in Finish');
    }
}
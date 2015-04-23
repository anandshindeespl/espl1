/**
 *  this class will receive the data in json format deserialise it and Create the Contact Records
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   18 Mar 2015
 ===========================================================================================================================================
 */

global class InsertionScript /* implements Database.Batchable<sObject>,InstallHandler*/
{/*
       public  String objectString;
        public InsertionScript()
        {
        	objectString
        }
       global static String objectString;
       global static void fieldsvalue(String objstr)
       {
       	    objectString=objstr;
       }
        
        Package_Installation__c packageValues2;
        //Package_Installation__c packageValues=Package_Installation__c.getInstance('AccountInfo') ;
        global static String pi;
        //start() method to get json body in a list which will assign to execute methos 
        global Database.QueryLocator start(Database.BatchableContext bc)
        {
            
            Map<String, Package_Installation__c> customMap = Package_Installation__c.getAll();
            system.debug('mapppp'+customMap);
            List<String> keys = new List<String>(customMap.keySet());
            system.debug('mapppp'+keys);
            
            for(String key : customMap.keySet()) 
            {
                Package_Installation__c packageValues=Package_Installation__c.getInstance(key) ;
                if(packageValues.Object_Order__c=='1')
                {
                    pi=key;
                    system.debug('*******pi'+pi);
                    break;
                }
            }
            //return null;
            system.debug('out pi '+pi);
            Package_Installation__c packageValues2=Package_Installation__c.getInstance(pi) ;
             objectString='asdfg';//packageValues2.Object_Name__c;
            //fieldsvalue(objString);
            return Database.getQueryLocator([select Body from StaticResource where Name =:packageValues2.Static_Resource_Name__c]);
        }
        
        //method to insert records according to JSON file
        global void execute(Database.BatchableContext BC, List <StaticResource> jsonList)
        {
            system.debug('*******execute pi'+objectString);
            list <String> recList=new list<String>();
            StaticResource sr=jsonList.get(0);
            Blob csvFileBody=sr.body;
            String  recList1=csvFileBody.toString();
            Map<String, Object> mapp = (Map<String, Object>) JSON.deserializeUntyped(recList1);
            
            String keyvalue;
            //to get the key of mapp;
            for(String strkey :mapp.keyset())
            {
            	keyvalue=strkey;
            }
            
            //to convert values in list of object
            List<Object> objList =(List<Object>)mapp.get(keyvalue);
            list<String> accSerializeList=new list<String>();
            
            //loop for serialize the object
            for(Object accTopicList : objList)
            {
                String str=Json.serialize(accTopicList);
                accSerializeList.add(str);
            }
            
            Schema.SObjectType targetType =Schema.getGlobalDescribe().get(packageValues2.Object_Name__c);
            list<sobject> objectlist=new list<sobject>();
            
            //loop to iterate on serialize list and again deserialze it also add records in list of sobject
            for(String jsonstr : accSerializeList)
            {
                Map<String, Object> mappRec = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
                // next line will create Object dynamically from variable of Schema.SObjectType 
                sObject objectVal = targetType.newSObject();
                
                for(String str1 : mappRec.keySet())
                {
                    objectVal.put(str1,mappRec.get(str1));
                } 
                objectlist.add(objectVal); 
            }
            
            try
            {
                insert objectlist;
            }
            catch(Exception e)
            {
                system.debug(e);
            }
    }
    
global void finish(Database.BatchableContext bc)
    {

    }

//method to insert custom setting records and it will also call the Batch 
global void onInstall()/*(InstallContext context)*/
/*{
            StaticResource sr=[select Body from StaticResource where Name ='CustomSettingRecords'];
            Blob csvFileBody=sr.body;
            String  recList1=csvFileBody.toString();
            Map<String, Object> mapp = (Map<String, Object>) JSON.deserializeUntyped(recList1);
            
            String keyvalue;
            //to get the key of mapp;
            for(String strkey :mapp.keyset())
            {
                keyvalue=strkey;
            }
            
            //to convert values in list of object
            List<Object> objList =(List<Object>)mapp.get(keyvalue);
            list<String> accSerializeList=new list<String>();
            
            //loop for serialize the object
            for(Object accTopicList : objList)
            {
                String str=Json.serialize(accTopicList);
                accSerializeList.add(str);
            }
            
            Schema.SObjectType targetType =Schema.getGlobalDescribe().get('Package_Installation__c');
            list<sobject> objectlist=new list<sobject>();
            
            //loop to iterate on serialize list and again deserialze it also add records in list of sobject
            for(String jsonstr : accSerializeList)
            {
                Map<String, Object> mappRec = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
                // next line will create Object dynamically from variable of Schema.SObjectType 
                sObject objectVal = targetType.newSObject();
                
                for(String str1 : mappRec.keySet())
                {
                    objectVal.put(str1,mappRec.get(str1));
                } 
                objectlist.add(objectVal); 
            }
            
            try
            {
                insert objectlist;
            }
            catch(Exception e)
            {
                system.debug(e);
            }
            
            InsertionScript obj=new InsertionScript();
            Database.executeBatch(obj);

}
*/
}
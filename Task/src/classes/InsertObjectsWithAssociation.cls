/**
 *  this class will receive the data in json format deserialise it and Create new custom setting records
 *  It also insert the multiple object dynamically and in given order .
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   18 Mar 2015
 ===========================================================================================================================================
 */
global class InsertObjectsWithAssociation {/* implements InstallHandler*/
    list <WrapperData>wrapList;
    list<sobject> objectlist;
    
    global class WrapperData implements Comparable {
        public String StaticResourceName{get;set;}
        public String ObjectName{get;set;}
        public Integer ObjectOrder{get;set;}
        
        public WrapperData(String ObjName, String StatResName, Integer ObjOrder) {
            this.ObjectName=ObjName;
            this.StaticResourceName=StatResName;
            this.ObjectOrder=ObjOrder;
        }
        
        //compareTo() will sort the wrapper list 
        public Integer compareTo(Object compareTo) {
            WrapperData wrapObject = (WrapperData) compareTo;
            if (ObjectOrder == wrapObject.ObjectOrder) return 0;
            if (ObjectOrder > wrapObject.ObjectOrder) return 1;
            return -1;
        }
    }
     
    //method to insert custom setting records and it will also calls the method which insert object records
        public void onInstall()/*(InstallContext context)*/ {
            //read the custom settings data from static resources
            StaticResource sr=[select Body from StaticResource where Name ='CustomSettingRecords'];
            Blob csvFileBody=sr.body;
            String  recList1=csvFileBody.toString();
            
            //deserialize the incoming JSON Data. 
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
            system.debug('objList'+objList);
            //loop for serialize the object
            for(Object accTopicList : objList)
            {
                String str=Json.serialize(accTopicList);
                accSerializeList.add(str);
            }
            system.debug('accSerializeList'+accSerializeList);
            //Schema.SObjectType targetType =Schema.getGlobalDescribe().get('Package_Installation');
            list<sobject> objectlist=new list<sobject>();
            wrapList=new list<WrapperData>();
            //loop to iterate on serialize list and again deserialze it also add records in list of sobject
            for(String jsonstr : accSerializeList)
            {
                Map<String, Object> mappRec = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
                system.debug('**mappRec**'+mappRec);
                system.debug('**mappRecketset**'+mappRec.keyset());
                
                list<String> objNameList=new list<String>();
                list<String> statResList=new list<String>();
                list<Integer> orderList=new list<Integer>();
                system.debug('mappRec.keySet()'+mappRec.keySet());
                for(String str1 : mappRec.keySet())
                {
                    system.debug('str111'+str1);
                    if(str1=='Object_Name')
                    {
                        objNameList.add((String)mappRec.get(str1));
                    }
                    if(str1=='Static_Resource_Name')
                    {
                        statResList.add((String)mappRec.get(str1));
                    }
                    if(str1=='Object_Order')
                    {
                        orderList.add((Integer)mappRec.get(str1));
                    }
                } 
                   for(Integer i=0;i<objNameList.size(); i++)
                   {
                    wrapList.add(new WrapperData(objNameList.get(i),statResList.get(i),orderList.get(i)));
                   }
            }
                    system.debug('out wrapList11'+wrapList);
                    wrapList.sort();
                    system.debug('out wrapList22'+wrapList);
                    /*calls the method which insert records in multiple object*/
  
                    //execute();
}

        //method to insert records according to JSON file
        public void execute() {
            for(WrapperData wrap : wrapList)
            {
                String objString=wrap.ObjectName;
                //system.debug('*******execute pi'+objString);
                list <String> recList=new list<String>();
                StaticResource sr=[select Body from StaticResource where Name =:wrap.StaticResourceName];
                Blob csvFileBody=sr.body;
                String  recList1=csvFileBody.toString();
                Map<String, Object> mapp = (Map<String, Object>) JSON.deserializeUntyped(recList1);
                system.debug('///////////'+mapp);
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
                
                Schema.SObjectType targetType =Schema.getGlobalDescribe().get(objString);
                objectlist=new list<sobject>();
               
                
                //loop to iterate on serialize list and again deserialze it also add records in list of sobject
                for(String jsonstr : accSerializeList)
                {
                    Map<String, Object> mappRec = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
                    // next line will create Object dynamically from variable of Schema.SObjectType 
                    sObject objectVal = targetType.newSObject();
                    system.debug('vallllll'+mappRec.keyset());
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
        }

}
/*
    MetaDataAutomationHandler : Class used to:
                                1) Parse the static resource
                                2) Create the metadata records
*/

public with sharing class MetaDataAutomationHandler
{
    public string strStaticResourceName{get;set;}
    public boolean isSubmitted {get;set;}
    public string strChoice{get;set;}
    
    private list<RunConfigCustomSettingRecordInfo> lstCustomSettingRecordsToCreate;
    private list<RunConfigCustomObjectRecordInfo> lstCustomObjectRecordsToCreate;
    private map<Integer,RunConfigCustomObjectRecordInfo> mapOrderNoWithObject;
    private map<Integer,map<string,List<Sobject>>> mapOrderWithExterNalIdSobjectList;
    private map<string,string> mapObjectWithFields;
    
    public MetaDataAutomationHandler()
    {
          isSubmitted = false;
          lstCustomSettingRecordsToCreate = new List<RunConfigCustomSettingRecordInfo>();
          lstCustomObjectRecordsToCreate = new List<RunConfigCustomObjectRecordInfo>();
          mapOrderWithExterNalIdSobjectList = new map<Integer,map<string,List<Sobject>>>();
    }
    
    public List<SelectOption> getFirstRunOption()
    {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('YES','YES'));
            options.add(new SelectOption('NO','NO'));
            return options;
    }
        
    public void runMetaDataSetUp()
    {
        isSubmitted = true;
        system.debug('************strChoice'+strChoice);
        if(strStaticResourceName !=null )
        {
            try
            {
                Blob content;
                string URL;
                if(Test.isrunningTest()) {
                     String content2=MetadataAutomationForMockData.jsonContent;
                     content = blob.valueOf(content2);
                     URL='/resource/'+ strStaticResourceName +'/' + strStaticResourceName + '/RunConfig.json';
                }
                else {
                URL = '/resource/'+ strStaticResourceName +'/' + strStaticResourceName + '/RunConfig.json';
                PageReference pr = new PageReference(URL);
                content = pr.getContent();
                }
                system.debug('andycontent'+content.toString());
                if(content !=null && content.size() > 0)
                {
                   // System.Debug('%%%%%%%content'+content.size());
                    parseRunConfigFile(content.toString(), URL);
                }
                
            }
            catch(exception ex)
            {
                Apexpages.addMessage(new apexpages.message(apexpages.severity.error,'Invalid Static Resources. Please correct it.'+'\n'+ ex.getMessage() ));
                isSubmitted = false;
            }
        }
    }
    
    public class RunConfigCustomSettingRecordInfo
    {
        public string strExternalID;
        public string strFileName;
        public string strRecordName;
        public boolean blnIsActive;
        public integer intIndex;
    }
    
    public class RunConfigCustomObjectRecordInfo
    {
        public string strExternalID;
        public string strFileName;
        public string strOrder;
        public string strObjectName;
        public boolean blnIsActive;
    }
    
    
    public void parseRunConfigFile(string pstrRunConfigFileBody , string strResourceURL)
    {
         Map<String, Object> mapRunconfigResponse = 
                    (Map<String, Object>)JSON.deserializeUntyped(pstrRunConfigFileBody);
         
        // system.debug('********mapRunconfigResponse'+mapRunconfigResponse); 
         if(mapRunconfigResponse.size() > 0)
         {
              Integer index = 0;
               for(String strRecordInfo :mapRunconfigResponse.keyset())
               {
                    //system.debug('********strRecordInfo'+strRecordInfo); 
                    Map<String, Object> mapRecordsInfo = (Map<String, Object>) mapRunconfigResponse.get(strRecordInfo);
                    if( mapRecordsInfo.containskey('GroupActive') && 
                        mapRecordsInfo.get('GroupActive') != null && 
                        string.valueof(mapRecordsInfo.get('GroupActive')) == 'true')
                    {
                        RunConfigCustomSettingRecordInfo objSettingRecordInfo;
                        RunConfigCustomObjectRecordInfo objObjectRecordInfo;
                         for( string strSingleRecord: mapRecordsInfo.keyset() )
                         {
                            if(strSingleRecord != 'GroupActive')
                             {
                                if(strRecordInfo == 'CustomSettings')
                                 { 
                                     objSettingRecordInfo =  new RunConfigCustomSettingRecordInfo();
                                 }
                                 else if(strRecordInfo == 'CustomObjects')
                                 {
                                     objObjectRecordInfo =  new RunConfigCustomObjectRecordInfo();
                                     mapOrderNoWithObject = new map<Integer,RunConfigCustomObjectRecordInfo>();
                                 }
                                 Map<String, Object> mapRecordsDetails = (Map<String, Object>) mapRecordsInfo.get(strSingleRecord);
                                
                                 if(mapRecordsDetails.containskey('isActive') && 
                                   mapRecordsDetails.get('isActive') != null && 
                                   string.valueof(mapRecordsDetails.get('isActive')) == 'true' )
                                 {
                                    if(isvalidOperation(strRecordInfo , objSettingRecordInfo))
                                    { objSettingRecordInfo.blnIsActive  = true;
                                      objSettingRecordInfo.intIndex = index++;  
                                    }
                                    if(isvalidOperation(strRecordInfo , objObjectRecordInfo))
                                    objObjectRecordInfo.blnIsActive = true;
                                    
                                    for(String strRecInfo :mapRecordsDetails.keyset())
                                    {
                                       // system.debug('*******strRecInfo'+strRecInfo);
                                        if(strRecInfo !='isActive')
                                        {
                                            if(strRecInfo == 'ExternalID')
                                            { 
                                                if(isvalidOperation(strRecordInfo , objSettingRecordInfo))
                                                objSettingRecordInfo.strExternalID  = string.valueof(mapRecordsDetails.get(strRecInfo));
                                                if(isvalidOperation(strRecordInfo , objObjectRecordInfo) )
                                                objObjectRecordInfo.strExternalID  = string.valueof(mapRecordsDetails.get(strRecInfo));
                                            }
                                            
                                            if(strRecInfo == 'FileName')
                                            { 
                                                if(isvalidOperation(strRecordInfo , objSettingRecordInfo) )
                                                objSettingRecordInfo.strFileName  = string.valueof(mapRecordsDetails.get(strRecInfo));
                                                if(isvalidOperation(strRecordInfo , objObjectRecordInfo) )
                                                objObjectRecordInfo.strFileName  = string.valueof(mapRecordsDetails.get(strRecInfo));
                                            }
                                            
                                            if(strRecInfo == 'Name' && isvalidOperation(strRecordInfo , objSettingRecordInfo) )
                                            { 
                                                 objSettingRecordInfo.strRecordName  = string.valueof(mapRecordsDetails.get(strRecInfo));
                                            }
                                            
                                            if(strRecInfo == 'ObjectName' && isvalidOperation(strRecordInfo , objObjectRecordInfo) )
                                            { 
                                                system.debug('**********ObjectName'+strRecInfo);
                                                objObjectRecordInfo.strObjectName  = string.valueof(mapRecordsDetails.get(strRecInfo));
                                            }
                                            
                                            if(strRecInfo == 'Order' && isvalidOperation(strRecordInfo , objObjectRecordInfo) )
                                            { 
                                                objObjectRecordInfo.strOrder  = string.valueof(mapRecordsDetails.get(strRecInfo));
                                            }
                                        }
                                    }
                                    if( objSettingRecordInfo !=null)
                                    {   
                                         lstCustomSettingRecordsToCreate.add(objSettingRecordInfo);
                                    }
                                    if( objObjectRecordInfo !=null)
                                    lstCustomObjectRecordsToCreate.add(objObjectRecordInfo);
                                }
                             } 
                         }
                    }
               } 
               
               system.debug('(((((lstCustomObjectRecordsToCreate)))))'+lstCustomObjectRecordsToCreate);
               
              if(lstCustomSettingRecordsToCreate.size() > 0 )
                createCustomSettingRecords(lstCustomSettingRecordsToCreate , strResourceURL);
               
              if(lstCustomObjectRecordsToCreate.size() > 0 )
                createCustomObjectRecords(lstCustomObjectRecordsToCreate , strResourceURL);
               
         }        
        
    }
    
    public void createCustomObjectRecords(List<RunConfigCustomObjectRecordInfo> plstCustomObjectRecordsToCreate , string pstrResourceURL)
    {
         string strEndPointURL = getEndPointURL(pstrResourceURL);
         List<sObject> lstCustomObjectsRecordsToCreateWithYes = new List<sObject>();
         
         for(RunConfigCustomObjectRecordInfo objCustomObjectRecord :plstCustomObjectRecordsToCreate )
        {
            List<sObject> lstCustomObjectsRecordsToInsert = new List<Sobject>();
            sObject sObj = Schema.getGlobalDescribe().get(objCustomObjectRecord.strObjectName).newSObject() ; 
            // List<Schema.ChildRelationship> C = sObj.getChildRelationships(); 
              Map<String, Schema.SObjectType> GlobalDescribe = Schema.getGlobalDescribe(); 
              Schema.SObjectType objCurrentDec = GlobalDescribe.get(objCustomObjectRecord.strObjectName); 
              Schema.DescribeSObjectResult descResult = objCurrentDec.getDescribe();
              List<Schema.ChildRelationship> lstChildRelations = descResult.getChildRelationships(); 
              system.debug('*********C'+lstChildRelations);
              map<string,string> mapRelationShipObject = new map<string,string>();
              for(Schema.ChildRelationship obj :lstChildRelations )
              {
                if(obj.getRelationshipName() !=null && obj.getChildSObject() !=null)
                mapRelationShipObject.put(string.valueof(obj.getRelationshipName()) ,string.valueof(obj.getChildSObject()));
                system.debug('(((((())))))'+obj.getRelationshipName() + '>>>>>>>>'+ obj.getChildSObject());
              }
              
               
              //Map<String, Schema.SobjectField> fmap = ctype.getDescribe().fields.getMap();
              
            if(objCustomObjectRecord.blnIsActive)
            {
                PageReference pr = new PageReference(strEndPointURL + objCustomObjectRecord.strFileName);
                Blob content = pr.getContent();
                if(content !=null && content.size() > 0)
                {
                    //List<Object> lstRecords = (List<Object>)JSON.deserializeUntyped(content.toString());
                    Map<String, Object> mapFileResponse = 
                    (Map<String, Object>)JSON.deserializeUntyped(content.toString());
                    for(String strRecords : mapFileResponse.keyset())
                    {
                        
                         system.debug('******strRecords'+strRecords);
                          system.debug('******strRecords'+string.valueof(mapFileResponse.get(strRecords)));
                    }
                   /* for(Object objRecord :lstRecords )
                    {
                       sObject sObj = Schema.getGlobalDescribe().get(objCustomObjectRecord.strRecordName).newSObject() ; 
                      // Map<String, Schema.SobjectField> fieldsMap = sObj.getSObjectType().getDescribe().fields.getMap();
                       Map<String, Object> mapRecordsInfo = (Map<String, Object>) objRecord;
                       //system.debug('*******mapRecordsInfo'+mapRecordsInfo);
                       string strFields = '';
                       for(String strFieldName :mapRecordsInfo.keyset())
                       {  
                           sObj.put(strFieldName , mapRecordsInfo.get(strFieldName));
                           strFields = strFields + strFieldName + ',' ;
                       }
                       mapObjectWithFields.put(objCustomObjectRecord.strRecordName , strFields);
                       lstCustomObjectsRecordsToInsert.add(sObj);
                    }
                    if(lstCustomSettingToCreate.size() > 0)
                    {
                        lstCustomObjectsRecordsToCreateWithYes.addAll(lstCustomObjectsRecordsToInsert);
                    }
                     mapOrderWithExterNalIdSobjectList.put(objCustomObjectRecord.intIndex , 
                                                           new map<string,List<sobject>>
                                                           {objCustomObjectRecord.strRecordName + ',' + 
                                                            objCustomObjectRecord.strExternalID +','+ 
                                                            objCustomObjectRecord.intIndex =>lstCustomObjectsRecordsToInsert }
                                                           );
                    */                                       
                }
                
            }
        }
         
    }
    
    public string getEndPointURL(string pstrResourceURL)
    {
        string strEndPointURL='';
         if(pstrResourceURL.contains('/'))
        {
            List<String> lstURL = pstrResourceURL.split('/');
            lstURL[lstURL.size() - 1] = '';
            string strURLJoin = string.join(lstURL,'/');
            strEndPointURL = strURLJoin;
           // system.debug('*****strEndFolder'+strURLJoin);
           return strEndPointURL;
        }
        else
        {
            return strEndPointURL;
        }
    }
    public void createCustomSettingRecords(List<RunConfigCustomSettingRecordInfo> plstCustomSettingToCreate , string pstrResourceURL)
    {
        Blob content;
        string strEndPointURL = getEndPointURL(pstrResourceURL);
       /* if(pstrResourceURL.contains('/'))
        {
            List<String> lstURL = pstrResourceURL.split('/');
            lstURL[lstURL.size() - 1] = '';
            string strURLJoin = string.join(lstURL,'/');
            strEndPointURL = strURLJoin;
            system.debug('*****strEndFolder'+strURLJoin);
        }*/
        
        mapObjectWithFields = new map<string,string>();
        List<sObject> lstCustomSettingToCreateWithYes = new List<sObject>();
        
        for(RunConfigCustomSettingRecordInfo objSettingRecord :plstCustomSettingToCreate )
        {
            List<sObject> lstCustomSettingToCreate = new List<Sobject>();
            if(objSettingRecord.blnIsActive)
            {
               if(Test.isrunningTest())
               {
                String content2=MetadataAutomationForMockData.customSettingJson;
                content = blob.valueOf(content2);
               }
               else {
              
                PageReference pr = new PageReference(strEndPointURL + objSettingRecord.strFileName);
                content = pr.getContent();
               }
               system.debug('andycontent'+content.toString());
                if(content !=null && content.size() > 0)
                {
                    system.debug('andycontent2');
                    List<Object> lstRecords = (List<Object>)JSON.deserializeUntyped(content.toString());
                    system.debug('andycontent3');
                    for(Object objRecord :lstRecords )
                    {
                       sObject sObj = Schema.getGlobalDescribe().get(objSettingRecord.strRecordName).newSObject() ; 
                      // Map<String, Schema.SobjectField> fieldsMap = sObj.getSObjectType().getDescribe().fields.getMap();
                       Map<String, Object> mapRecordsInfo = (Map<String, Object>) objRecord;
                       //system.debug('*******mapRecordsInfo'+mapRecordsInfo);
                       string strFields = '';
                       for(String strFieldName :mapRecordsInfo.keyset())
                       {  
                           sObj.put(strFieldName , mapRecordsInfo.get(strFieldName));
                           strFields = strFields + strFieldName + ',' ;
                       }
                       mapObjectWithFields.put(objSettingRecord.strRecordName , strFields);
                       lstCustomSettingToCreate.add(sObj);
                    }
                    if(lstCustomSettingToCreate.size() > 0)
                    {
                        lstCustomSettingToCreateWithYes.addAll(lstCustomSettingToCreate);
                    }
                     mapOrderWithExterNalIdSobjectList.put(objSettingRecord.intIndex , 
                                                           new map<string,List<sobject>>
                                                           {objSettingRecord.strRecordName + ',' + 
                                                            objSettingRecord.strExternalID +','+ 
                                                            objSettingRecord.intIndex =>lstCustomSettingToCreate }
                                                           );
                                                           
                }
                
            }
        }
        
        //system.debug('*********lstCustomSettingToCreate'+lstCustomSettingToCreate);
       // system.debug('MMMMMMMMMmapOrderWithExterNalIdSobjectList'+mapOrderWithExterNalIdSobjectList);
        if(mapOrderWithExterNalIdSobjectList.size() > 0)
        {
            if(strChoice == 'YES')
            {
                if(lstCustomSettingToCreateWithYes.size() > 0 )
                {
                    //system.debug('*************lstCustomSettingToCreateWithYes*'+lstCustomSettingToCreateWithYes);
                    //system.debug('*************lstCustomSettingToCreateWithYes*'+lstCustomSettingToCreateWithYes.size());
                    CreateErrorSobjectAndErrorLogRecord(lstCustomSettingToCreateWithYes , true);
                }
            }
            else
            {
               system.debug('in andyELse');
                createSobjectRecordsFromMap(mapOrderWithExterNalIdSobjectList , 0);
            }
        }
        
    }
    
    public integer intRecCnt = 0;
    
    public void createSobjectRecordsFromMap(map<Integer,map<string,List<Sobject>>> pmapOrderWithExterNalIdSobjectList , Integer intIndex)
    {
       system.debug('in andy function4 ');
        List<Sobject> lstObject = new List<Sobject>();
        String strObjectExternalIdAsKey;
        List<Integer> lstIndex = new List<Integer>();
        lstIndex.addAll(pmapOrderWithExterNalIdSobjectList.keyset());
        //system.debug('*********intRecCnt'+intRecCnt);
       // system.debug('*********pmapOrderWithExterNalIdSobjectList.get(intIndex).keyset()'+pmapOrderWithExterNalIdSobjectList.get(intIndex));
        //system.debug('*********pmapOrderWithExterNalIdSobjectList.get(intIndex).keyset()'+pmapOrderWithExterNalIdSobjectList.get(intIndex).keyset()); 
        if(pmapOrderWithExterNalIdSobjectList.get(intIndex) != null)
        {
             for(string str : pmapOrderWithExterNalIdSobjectList.get(intIndex).keyset())
             {
                strObjectExternalIdAsKey = str;
                lstObject = pmapOrderWithExterNalIdSobjectList.get(intIndex).get(str);
                 if(lstObject.size() > 0)
                 { 
                        break;
                 }
            }
        }
       // system.debug('*********intIndex'+intIndex );
        //system.debug('*********intRecCnt'+intRecCnt + '>>>>>>>lstIndex.size()'+lstIndex.size());
      //  system.debug('***********lstObject'+lstObject +'>>>>>>strExterNalId'+strObjectExternalIdAsKey);
        if(intRecCnt < lstIndex.size())
        {
          if(lstObject.size() > 0)
          {
            String strObjectName ;
            String strExterNalId ;
            if(strObjectExternalIdAsKey.contains(','))
            {
                    List<String> lstkeys = strObjectExternalIdAsKey.split(',');
                    strObjectName = lstkeys[0];
                    strExterNalId = lstkeys[1];
            }
            compareandupdateSobjectRecords(strObjectName ,strExterNalId, lstObject );
          }
            intRecCnt++;
            createSobjectRecordsFromMap(pmapOrderWithExterNalIdSobjectList ,intRecCnt );
        }
    }
    
    public void compareandupdateSobjectRecords(string pstrObjectName , string pstrExterNalId , List<Sobject> lstNewSobjectRecords)
    {
            system.debug('in andy function 3');
        //system.debug('***********lstSobject'+lstNewSobjectRecords);
        //system.debug('***********pstrExterNalId'+pstrExterNalId);
        //system.debug('*********GetCall'+lstSobject.get(0).get(pstrExterNalId));
        //system.debug('********mapObjectWithFields'+mapObjectWithFields);
        //system.debug('********mapObjectWithFields'+mapObjectWithFields.get(pstrObjectName));
        String strQueryFields ;
        if(mapObjectWithFields.size() > 0)
        {
            String strFields = mapObjectWithFields.get(pstrObjectName);
            system.debug('************strFields*'+strFields);
            
          if( strFields != null)
          {
            strQueryFields = strFields.Substring(0,strFields.length()-1);
            system.debug('*****strEndFolder'+strQueryFields);
            String strQueryForExisitngRecords = 'select ' + strQueryFields + ' from ' + pstrObjectName ;
            system.debug('**********strQueryForExisitngRecords'+strQueryForExisitngRecords);
            
            List<sObject> lstExisitingRecords = Database.query(strQueryForExisitngRecords);
            List<sObject> lstSobjectRecordsToUpdate = new List<Sobject>();
            List<sObject> lstSobjectRecordsToInsert = new List<Sobject>();
            if(lstExisitingRecords.size() > 0 && lstNewSobjectRecords.size() > 0)
            {
                for(Integer intExistingIndex = 0 ; intExistingIndex < lstExisitingRecords.size() ; intExistingIndex++ )
                {
                    for(Integer intNewIndex = 0 ; intNewIndex < lstExisitingRecords.size() ; intNewIndex++)
                    {
                        if(lstExisitingRecords[intExistingIndex].get(pstrExterNalId) == lstNewSobjectRecords[intNewIndex].get(pstrExterNalId))
                        {
                            system.debug('*************HitsHere');
                            lstSobjectRecordsToUpdate.add(lstNewSobjectRecords[intNewIndex]);
                        }
                        else
                        {
                            lstSobjectRecordsToInsert.add(lstNewSobjectRecords[intNewIndex]);
                        }
                        
                    }
                }
                
                if(lstSobjectRecordsToUpdate.size() > 0)
                {
                     system.debug('in andy function10 ');
                    // Update List
                    //system.debug('*********************lstSobjectRecordsToUpdate'+lstSobjectRecordsToUpdate);
                    //system.debug('*********************lstSobjectRecordsToUpdateSize'+lstSobjectRecordsToUpdate.size());
                    CreateErrorSobjectAndErrorLogRecord(lstSobjectRecordsToUpdate , false);
                }
                if(lstSobjectRecordsToInsert.size() > 0)
                {
                    // Insert List
                    system.debug('in andy function2 ');
                    CreateErrorSobjectAndErrorLogRecord(lstSobjectRecordsToInsert , true);
                }
            }
          }
        }
        
    }
    
    public void CreateErrorSobjectAndErrorLogRecord(list<Sobject> lstCustomSettingToCreate , boolean blnInsertFlag)
    {system.debug('in andy function ');
        Database.Saveresult[] lstSobjectInsertResult;
        if(blnInsertFlag){system.debug('in andy insert ');
        lstSobjectInsertResult = Database.insert(lstCustomSettingToCreate , false);}
        else
        lstSobjectInsertResult = Database.update(lstCustomSettingToCreate , false);
        
        Integer intfailureRecordCnt = 0 , intsuccessRecordCnt = 0;
        List<ErrorLogs__c> lstErrorLog = new List<ErrorLogs__c>();
        String strErrorMessage ='';
        for(Database.Saveresult sr : lstSobjectInsertResult)
        {
            Database.Error[] errors = sr.getErrors();
            if(!sr.isSuccess())
            {
                 intfailureRecordCnt ++;
                 strErrorMessage = strErrorMessage + errors[0].getmessage();
            }else
            {
                intsuccessRecordCnt ++;
            }
        }
        
        /*Map<String,object> jsonMapErrorMessage = new Map<String,object>();
        Map<String,object> jsonMapContent = new Map<String,object>();
        
        jsonMapErrorMessage.put('Total Records',lstSobjectInsertResult.size());
        jsonMapErrorMessage.put('Success',intsuccessRecordCnt);
        jsonMapErrorMessage.put('Failure Records',intfailureRecordCnt);
        if(intfailureRecordCnt > 0)
        {
           jsonMapContent.put('Error Reason',jsonMapErrorMessage);
           jsonMapContent.put('Error Message',strErrorMessage);
           jsonMapContent.put('Error Context',new Map<String,object> {'Class' => 'MetaDataAutomationHandler','Method' => 'CreateErrorSobjectAndErrorLogRecord'});
     
        String jsonString = Json.serialize(jsonMapContent);
        system.debug('\n\n jsonString \n\t'+jsonString);
       
        ErrorLogs__c objLog = NotificationUtilityController.createErrorLog(jsonString, 
                                                                        'Error' , 
                                                                        true);
        insert objLog;*/
        
        
    }    
    public boolean isvalidOperation(string pstrName , Object pObject)
    {
        if(pstrName == 'CustomSettings' && pObject !=null) return true;
        if(pstrName == 'CustomObjects' && pObject !=null) return true;
        return false;
    }
    
}
public with sharing class ReadAndProcessCSV {

    public void LoadResource() {
        try
        {
            Blob Filecontent;
            string URL;
            if(Test.isrunningTest()) {
                 String content2=MetadataAutomationForMockData.jsonContent;
                 Filecontent = blob.valueOf(content2);
            }
            else {
            //URL = '/resource/'+ 'CsvToJson/CsvToJson' + '/Ens_Domain.csv';
            //URL = '/resource/'+ 'CsvToJson/CsvToJson' + '/Ens_Credential.csv';
            URL = '/resource/'+ 'CsvToJson/CsvToJson' + '/Ens_ObjectMapping.csv';
           
            
            PageReference pr = new PageReference(URL);
            Filecontent = pr.getContent();
            }
            
            system.debug('andycontent'+Filecontent.toString());
            
            String strJson=Filecontent.toString();
            list<String>strRowList=new list<String>();
            strRowList=strJson.split('\n');
            system.debug('andycontent2'+strRowList.get(0));
            
            list<String>RowHeaderList=new list<String>();
            list<String>RowFieldList=new list<String>();
            list<String>jsonList=new list<String>();
            
            for(Integer i=0; i < strRowList.size(); i++) 
            {
                system.debug('in outer for');
                String strjsn='';
                system.debug('strRowList'+strRowList);
                RowHeaderList=strRowList.get(i).split(',');
                system.debug('RowHeaderList'+RowHeaderList);
                system.debug('RowHeaderList2'+RowHeaderList.get(0));
                
                for(Integer j=1, k=0 ; j < strRowList.size(); j++)
                {
                    system.debug('in inner for');
                    RowFieldList=strRowList.get(j).split(',');
                        
                    for(Integer p=0; p< RowHeaderList.size(); p++)
                    {
                        if(RowHeaderList.get(p).contains('.')) 
                        {
                            system.debug('in if');
                            if(p==RowHeaderList.size()-1)
                            {
                               system.debug(strRowList.size()-1+'aaa');
                                if(j==strRowList.size()-1)
                                {
                                    
                                    strjsn= '"'+RowHeaderList.get(p).substringBefore('.').trim()+'":{"'+ RowHeaderList.get(p).substringAfterLast('.').trim()+'":"'+RowFieldList.get(p).trim() +'"}' ;
                                    jsonList.add(strjsn.trim());
                                      
                                }   else{
                                            strjsn= '"'+RowHeaderList.get(p).substringBefore('.').trim() +'":{"'+ RowHeaderList.get(p).substringAfterLast('.').trim()+'":"'+RowFieldList.get(p).trim() +'"}},' ;
                                            jsonList.add(strjsn.trim());
                                        }
                            }   else {
	                                      if(p==0)
	                                      {
	                                          strjsn= '{"'+RowHeaderList.get(p).substringBefore('.').trim() +'":{"'+ RowHeaderList.get(p).substringAfterLast('.').trim()+'":"'+RowFieldList.get(p).trim() + '"},' ;
	                                          jsonList.add(strjsn.trim());
	                                            
	                                      }   else {
	                                                  strjsn= '"'+RowHeaderList.get(p).substringBefore('.').trim() +'":{"'+ RowHeaderList.get(p).substringAfterLast('.').trim()+'":"'+RowFieldList.get(p).trim() +'"},' ;
	                                                  jsonList.add(strjsn.trim());
	                                               }
                                     }
                        }  else
                                {
	                                if(p==RowHeaderList.size()-1)
	                                {
	                                   if(j==strRowList.size()-1)
	                                   {
	                                       strjsn = '"'+RowHeaderList.get(p).trim() +'" : "' +RowFieldList.get(p).trim() +'" }' ;
	                                       jsonList.add(strjsn.trim());
	                                   }   else {
	                                               strjsn = '"'+RowHeaderList.get(p).trim() +'" : "' +RowFieldList.get(p).trim() +'" },' ;
	                                               jsonList.add(strjsn.trim());
	                                            }
	                                } else {
	                                           if(p==0)
	                                           {
	                                               strjsn = '{"'+RowHeaderList.get(p).trim() +'" : "' +RowFieldList.get(p).trim() +'" ,' ;
	                                               jsonList.add(strjsn.trim());
	                                           }   else{
                                                            strjsn = '"'+RowHeaderList.get(p).trim() +'" : "' +RowFieldList.get(p).trim() +'" ,' ;
                                                            jsonList.add(strjsn.trim());
                                                       }
                                           }
                                }
                        }
                    }
                break;
            }
            
            system.debug('jsonLISt'+jsonList);
            
            String strToConcat= '[';
            for(String str5 : jsonList){
                strToConcat += str5;
            }
            strToConcat +=']';
            String strFinal=strToConcat.trim();
            system.debug('str6'+strFinal);
            Document doc = new Document(); 
            doc.Name = 'My Json file'; 
            String myContent = 'aabbcc'; 
            doc.FolderId = '00528000000cY2x';  
            doc.Body = Blob.valueOf(strFinal); 
            doc.ContentType = 'text/plain';
            doc.Type = 'txt';
            insert doc;
            }
            
            catch(exception ex)
            {
                System.debug(''+ex);
                //Apexpages.addMessage(new apexpages.message(apexpages.severity.error,'Invalid Static Resources. Please correct it.'+'\n'+ ex.getMessage() ));
            }
        
    }

}
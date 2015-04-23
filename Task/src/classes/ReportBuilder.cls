/**
**   this controller get the list of allsobject and their respected fields ..
**   It also generate the dynamic query
**/

public class ReportBuilder
    {
        public String sQuery {get;set;}
        public String sparameter {get;set;}
        public String robject {get;set;}
        public SelectOption[] selectedFields { get; set; }
        
        public SelectOption[] allSFields { get; set; }
        public String txt{get;set;}
        public String radValue{get;set;}
        public String pickvalue{get;set;}
        public String abc{get;set;}
        public List<SObject> recList{get;set;}
        public String objfields{get;set;}
        
        public ReportBuilder(ApexPages.StandardController controller)
         {
            
            robject='Account';
            getAllFields();
            
          radValue = 'Ascending';
          pickvalue= '500';
         }
    //get the list of allsobject 
    public List<SelectOption> getName()
    {
        List<Schema.SObjectType> objList = Schema.getGlobalDescribe().Values();    
        List<SelectOption> options = new List<SelectOption>();
        for(Schema.SObjectType objtype : objList )
        {
        options.add(new SelectOption(objtype .getDescribe().getName(),objtype .getDescribe().getLabel()));
        }
        options.sort();
        return options;
    }
   
   //get the list of all the fields with respect to their Sobject
   public void getAllFields(){
       
        system.debug('robject value before: '+robject);
        //robject= ApexPages.currentPage().getParameters().get('robject');
        system.debug('robject value after : '+robject);
        SObjectType accountType = Schema.getGlobalDescribe().get(robject);
        Map<String,Schema.SObjectField> fieldMap = accountType.getDescribe().fields.getMap();
        System.debug('all fields for '+robject+' : '+fieldMap );
        selectedFields = new List<SelectOption>();
       // List<Contact> contacts = [SELECT Name, Id FROM Contact];
        allSFields = new List<SelectOption>();
        for ( String c : fieldMap.keySet()) {
            allSFields.add(new SelectOption(c,c));
        }
       
        System.debug('List of fields' +allSFields);
   }
   
   //function to generate dynamic query
   public void getQuery()
       {
             objfields= Apexpages.currentPage().getParameters().get('pvalue2');
            system.debug('-------------------p2 '+ Apexpages.currentPage().getParameters().get('pvalue'));
            system.debug('-------------------pickvalue is '+pickvalue);
            sQuery='select Id, '+' '+objfields+' '+' from '+robject+' '+radValue +' '+'Limit' +' '+pickvalue ;
            System.debug('generated sql query : '+squery);
       }
   
   //function to get the records from dynamic query
   public void getRecords()
       {
          try{
                recList=Database.query(sQuery);
             }
          catch(Exception e){system.debug(e);}
       }
       
    public List<SelectOption> getNumberOfRecords()
       {   
           List<SelectOption> numberList=new List<SelectOption>();
           numberList.add(new SelectOption('500','500'));
           numberList.add(new SelectOption('1000','1000')) ;
           numberList.add(new SelectOption('5000','5000'));
           numberList.add(new SelectOption('50000','50000'));
           return numberList;
       }   

}
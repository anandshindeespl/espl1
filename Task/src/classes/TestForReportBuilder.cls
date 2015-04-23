/**
 * This class will test all the condition which occurs during dynamic query generation 
 */
@isTest
private class TestForReportBuilder {

    //test to populate Sobject list and their respective fields
    static testMethod void myUnitTest() {
    	PageReference pageref=Page.Report_Builder;
    	System.test.setCurrentPageReference(pageref);
    	ApexPages.CurrentPage().getparameters();
    	Report report=new Report();
    	
    	ApexPages.StandardController sc = new ApexPages.standardController(report);
    	ReportBuilder repbuilder=new ReportBuilder(sc);
    	
    	List<SelectOption> options = new List<SelectOption>();
        options=repbuilder.getName();
        system.assertNotEquals(0,options.size());
        
         SObjectType accountType = Schema.getGlobalDescribe().get('Account');
         Map<String,Schema.SObjectField> fieldMap = accountType.getDescribe().fields.getMap();
         List <SelectOption>allSFields = new List<SelectOption>();
         for ( String c : fieldMap.keySet()) {
            allSFields.add(new SelectOption(c,c));
         }
         
         repbuilder.robject='Account';
         repbuilder.getAllFields();
         system.assertEquals(allSFields.size(), repbuilder.allSFields.size());
         repbuilder.getQuery();
         
         /*String query='select Id from Account OrderBy Id ASC Limit 1000';
          repbuilder.objfields='Id';
          repbuilder.radValue='OrderBy Id ASC';
          repbuilder.pickvalue='1000';
          repbuilder.getQuery();
          //sQuery='select Id, '+' '+objfields+' '+' from '+robject+' '+radValue +' '+'Limit' +' '+pickvalue ;
          system.assertEquals(query,repbuilder.sQuery);*/
        
       
        
        
        
        
        
    }
}
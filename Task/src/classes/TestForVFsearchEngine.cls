/**
*  this test class will check the behavior of visualforce search engine .
*  to check whether resultlinks are displayed or not 
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   25 Feb 2015
 ===========================================================================================================================================
 **/
@isTest
private class TestForVFsearchEngine {

    static testMethod void myUnitTest() {
    	
    	//creating object of pagereferene
    	PageReference Pageref=Page.VF_Custom_Search;
    	System.test.setCurrentPageReference(Pageref);
    	VfSerachEngine searchEngine=new VfSerachEngine();
    	
    	//to check will it accept blank string or not
    	searchEngine.searchquery='';
    	searchEngine.checkString();
    	system.assertEquals('',searchEngine.body);
    	
    	//to check links were display or not
    	searchEngine.searchquery='salesforce';
    	searchEngine.checkString();
    	system.assertNotEquals('',searchEngine.body);
    	
    	//to check  is prev() pagination work or not
    	searchEngine.prev();
    	system.assertNotEquals('',searchEngine.body);
    	//to check  is next() pagination work or not
    	searchEngine.next();
    	system.assertNotEquals('',searchEngine.body);
    }
}
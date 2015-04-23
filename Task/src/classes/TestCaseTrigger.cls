/**
 * test Class for case creation
 */
@isTest
private class TestCaseTrigger {

    //test Class for case creation
    static testMethod void myUnitTest() 
	    {
	    	list <Case> caselist=new List<Case>();
	    	Case caseobj=new Case();
	    	caseobj.Origin='Email';
	    	caseobj.Status='New';
	    	caseList.add(caseobj);
		   	test.startTest();
		   	if(!caseList.isEmpty())
			   	{
			    	insert	 caseList ;
			   	}
		    test.stopTest() ;
		    system.assertNotEquals(caselist.Size(),0);
	    }
}
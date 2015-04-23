/**
 **test case to check for clone of record  
 */
@isTest
private class TestForClone {

    //test case to check for clone of record  
    static testMethod void myUnitTest() {
    	List<Lead> lstLead=new List<Lead>();
    		Lead lead=new Lead();
    		lead.FirstName='sunny';
    		lead.LastName='M';
    		lead.Company='Infosys';
    		lead.Status='New';
    		lstLead.add(lead);
	    	test.startTest();
	    	if(!lstlead.isEmpty())
		    	{
		    		insert lstLead;
		    	}
	    	test.StopTest();
	    	system.assertNotEquals(lstLead.Size(),0);
	    
	    List<Lead> recordList=new List<Lead>();
	    recordList=[select FirstName,Company from Lead where FirstName='sunny' and Company='Infosys'];	
	    system.assertEquals(recordList.Size(),2,'');	
	    	
    }
}
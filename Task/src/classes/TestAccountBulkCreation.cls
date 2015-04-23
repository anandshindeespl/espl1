/**
 * Test class for bulk creation of account

 */
@isTest
private class TestAccountBulkCreation
 {
    static testMethod void myUnitTest() 
    {
    	List <Account> accInsert=new List <Account>();
    	for(Integer i=0 ;i< 1; i++)
    	{
    		Account account=new Account();
    		account.Name='ESPLAccount'+ i;
    		accInsert.add(account);
    	}
	    	 Test.startTest();
	    	 insert accInsert; 
	    	 system.assertNotEquals(0,accInsert.size());
	    	 Test.stopTest();   
    }
}
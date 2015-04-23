/**
 * test case for account record insertion
 *
 */
@isTest
private class TestAccountInsert 
{
    static testMethod void myUnitTest() 
    {
    	List<Account> accounts = new List<Account>();
    	  Account acc =new Account();
    	
   	    for(Integer i = 0; i < 200; i++)
   			 {
   			 	acc.Name='ESPLaccount'+i;
        		accounts.add(acc);
   		     }
   		     	test.startTest();
   		     	insert accounts ;
   		     	test.stopTest();
   		 	   System.assertNotEquals(accounts.Size(),0);
    }
}
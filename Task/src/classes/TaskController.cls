/**
 * test class to check whether task is created or not on creation of Account
 */
@isTest
private class TaskController {

    static testMethod void myUnitTest() {
    	
    	// method to test creation of task on creation of account
    	test.startTest();
    	Account account=new Account();
    	account.Name='IndiaEspl';
    	insert account;
    	
    	List<Task>tasklist=new List<Task>();
    	tasklist=[select Subject from Task where Subject='Meeting with IndiaEspl' ];
    	system.assertEquals(1,tasklist.size());
    	
        // TO DO: implement unit test
    }
}
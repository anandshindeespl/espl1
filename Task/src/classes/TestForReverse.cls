/**
 * test cases for multiple function

 */
@isTest
private class TestForReverse {

    static testMethod void myUnitTest() {
    	ReverseString revString=new ReverseString();
    	/*InsertintoContact insertCon=new InsertintoContact();
    	InsertintoAccount insertAcc=new InsertintoAccount();
    	InsertintoLead insertlead=new InsertintoLead();
    	InsertintoOPP insertOpp = new InsertintoOPP();*/
    	
    	test.startTest();
    	//revString.main();
    	
    	/** test reverse String */
    	system.assertEquals('dnana',revString.reverse_String('anand'));
    	system.assertEquals('',revString.reverse_String(''));
    	
        system.assertEquals(144,revString.fibonacci(10));
    	
    	revString.stringOperation('Welcome to @pex Programming');
    	
    	
    	//** test for fetching contacts
    	Account acc=new Account();
    	acc.Name='Sahara';
    	insert acc;
    	
    	Account acc2=new Account();
    	acc2=[select ID from Account where Name='Sahara'];
    	
    	Contact cont = new Contact();
        cont.FirstName='anand';
        cont.LastName = 'Shinde';
        cont.Phone='98989898' ;
        cont.AccountID=acc2.ID;
        insert cont;
    	
    	List<contact> lstContact=revString.printContact();
    	system.assertEquals(1,lstContact.size());
        system.assertEquals('98989898',lstContact.get(0).Phone);
        
        //
        List<contact> lstCont2=revString.queries();
        system.assertEquals(1,lstCont2.size());
        
    	
    	//****test for fetching Account
    	
    	 List <Account> abList2=new List<Account>();       
         abList2 =[SELECT Id, Name, (SELECT Id, FirstName, LastName FROM Contacts) FROM Account];
         List <Account> account2 =revString.queriesAccount();
         system.assertNotEquals(0,account2.size());
         
    	
    	//***test to insert active user in Map
    	
    	Map <Id,User> mapp= new Map<Id,User>();   
    	
    	mapp= revString.mapUser();
        List <User> userList=new List<User>();       
        userList=[select Id,Name,Username,Phone,Email,Address from User where IsActive=TRUE];
        
        for(User u : userList)
        {
        mapp.put(u.Id ,u);
        System.debug('---------'+ u);
        
        }
        system.assertEquals(4,mapp.size());
        
        revString.mapAccount();
        
        
        //*** to check occurence iteration in map  
        
        Map <String,Integer> mappOcc= new Map<String,Integer>(); 
        mappOcc=revString.occurence('anand');
        system.assertEquals(3,mappOcc.size());
        
        
          	
    	/*insertCon.InsertContact();
    	insertAcc.InsertAccount();
    	insertlead.InsertLead();
    	insertOpp.InsertOpp();
    	test.stopTest();*/
    	revString.helloWorld();
    	revString.show();
    	test.stopTest();
        // TO DO: implement unit test
    }
    
    
}
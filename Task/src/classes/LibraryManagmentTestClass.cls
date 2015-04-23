/*
    Test class for Library Management Controller class
    ========================================================================================================================
        Version   | Date        | Author        | Comments
    -------------------------------------------------------------------------------------------------------------------------
        1.0       | 20-03-2015  | Jatin Bedse   | 1. Created LibraryManagmentTestClass.
                  | 20-03-2015  | Jatin Bedse   | 2. Created searchBookTest() test method.
                  | 20-03-2015  | Jatin Bedse   | 3. Created searchMemberTest() method.
                  | 20-03-2015  | Jatin Bedse   | 4. Created issueBookTest() method.
    ========================================================================================================================
*/

@isTest
private class LibraryManagmentTestClass {
    static testMethod void searchBookTest() {

        // Creating Book test data
        Book__c bObj1 = new Book__c();
        bObj1.Name = 'Book 1';
        bObj1.No_Of_Copies__c = 10;
        insert bObj1;

        Book__c bObj2 = new Book__c();
        bObj2.Name = 'Book 2';
        bObj2.No_Of_Copies__c = 5;
        insert bObj2;

        Book__c bObj3 = new Book__c();
        bObj3.Name = 'Book 3';
        bObj3.No_Of_Copies__c = 4;
        insert bObj3;

        Book__c bObj4 = new Book__c();
        bObj4.Name = 'Book 4';
        bObj4.No_Of_Copies__c = 3;
        insert bObj4;


        Test.startTest();
        //Negative Test for search book
        //Creating LibraryManagment class object
        LibraryManagment lMangObj = new LibraryManagment();
        lMangObj.searchBookString = 'Test';
        //calling searchBook() method
        lMangObj.searchBook();
        
        system.assertEquals(0,lMangObj.bookList.size());
        system.assert(ApexPages.hasMessages());
        ApexPages.Message[] msg = ApexPages.getMessages();
        system.assertEquals('Book Not Found',msg[0].getSummary());


        //Setting Test.setFixedSearchResults() method
        Id [] fixedSearchResults= new Id[4];
        fixedSearchResults[0] = bObj1.Id;
        fixedSearchResults[1] = bObj2.Id;
        fixedSearchResults[2] = bObj3.Id;
        fixedSearchResults[3] = bObj4.Id;
        Test.setFixedSearchResults(fixedSearchResults);

        //Positive search 
        LibraryManagment lMangObj1 = new LibraryManagment();
        lMangObj1.searchBookString = 'Book';
        //Calling serachBook();
        lMangObj1.searchBook();
        
        system.assertEquals(4,lMangObj1.bookList.size());
        Test.stopTest();
    }

    static testMethod void searchMemberTest() {
        //Creating Library Member test data
        Library_Member__c lmObj1 = new Library_Member__c();
        lmObj1.Name = 'Member 1';
        lmObj1.Phone_No__c = '8888888888';
        insert lmObj1;

        Library_Member__c lmObj2 = new Library_Member__c();
        lmObj2.Name = 'Member 2';
        lmObj2.Phone_No__c = '9999999999';
        insert lmObj2;

        Library_Member__c lmObj3 = new Library_Member__c();
        lmObj3.Name = 'Member 3';
        lmObj3.Phone_No__c = '7777777777';
        insert lmObj3;


        Test.startTest();
        //Negative Test for search member
        //Creating LibraryManagment class object
        LibraryManagment lMangObj = new LibraryManagment();
        lMangObj.searchMemberString = 'Test';
        //calling searchMember() method
        lMangObj.searchMember();

        system.assertEquals(0,lMangObj.memberList.size());
        system.assert(ApexPages.hasMessages());
        ApexPages.Message[] msg = ApexPages.getMessages();
        system.assertEquals('Member Not Found',msg[0].getSummary());

        //Setting Test.setFixedSearchResults() method
        Id [] fixedSearchResults= new Id[3];
        fixedSearchResults[0] = lmObj1.Id;
        fixedSearchResults[1] = lmObj2.Id;
        fixedSearchResults[2] = lmObj3.Id;
        Test.setFixedSearchResults(fixedSearchResults);

        //Positive search 
        LibraryManagment lMangObj1 = new LibraryManagment();
        lMangObj1.searchBookString = 'Member';
        //Calling serachBook();
        lMangObj1.searchMember();
        
        system.assertEquals(3,lMangObj1.memberList.size());
        Test.stopTest();
    }
    
    static testMethod void issueBookTest() {
        // Creating Book test data
        Book__c bObj1 = new Book__c();
        bObj1.Name = 'Book 1';
        bObj1.No_Of_Copies__c = 10;
        insert bObj1;

        //Creating Library Member test data
        Library_Member__c lmObj1 = new Library_Member__c();
        lmObj1.Name = 'Member 1';
        lmObj1.Phone_No__c = '8888888888';
        insert lmObj1;


        Test.startTest();
        //Check weather book is issued
        LibraryManagment lMangObj = new LibraryManagment();
        lMangObj.libraryMemberObj.id = lmObj1.Id;
        lMangObj.bookObj.Id = bObj1.Id;
        lMangObj.bookObj.No_Of_Copies__c = bObj1.No_Of_Copies__c;
        
        lMangObj.issueBook();
        Book_Issued__c biObj = [Select Id, Name, Library_Member_Id__c, Issue_Date__c, Due_Date_For_Return__c, Date_Returned__c, Book_Id__c, Extra_Days__c, Amount_Of_Fine__c From Book_Issued__c WHERE Library_Member_Id__c = :lmObj1.Id AND Book_Id__c = :bObj1.Id];
        system.assertNotEquals(null,biObj.Id);

        //Check weather book count is reduced after issuning book.
        Book__c bObj = [Select Id, Name, No_Of_Copies__c FROM Book__c WHERE Id = :bObj1.Id];
        system.assertEquals(9,bObj.No_Of_Copies__c);

        //Check weather isssue date is Today()
        system.assertEquals(system.Today(),biObj.Issue_Date__c);

        //Check weather Due date for return is 7 days after issue date
        system.assertEquals(system.Today()+7,biObj.Due_Date_For_Return__c);

        //Check weather Date Returned is null
        system.assertEquals(NULL,biObj.Date_Returned__c);

        //Check weather Extra days is zero
        system.assertEquals(0,biObj.Extra_Days__c);

        //Check weather Amount of fine is zero 
        system.assertEquals(0,biObj.Amount_Of_Fine__c);
        Test.stopTest();
    }
}
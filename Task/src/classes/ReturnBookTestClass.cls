/*
    Test class for Return Book Controller class
    ========================================================================================================================
        Version   | Date        | Author        | Comments
    -------------------------------------------------------------------------------------------------------------------------
        1.0       | 20-03-2015  | Jatin Bedse   | 1. Created ReturnBookTestClass.
                  | 20-03-2015  | Jatin Bedse   | 2. Created searchBookTest() test method.
                  | 20-03-2015  | Jatin Bedse   | 3. Created searchMemberTest() test method.
                  | 20-03-2015  | Jatin Bedse   | 4. Created issueBookTest() test method.
    ========================================================================================================================
*/
@isTest
private class ReturnBookTestClass {

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
        ReturnBook rbObj = new ReturnBook();
        rbObj.searchMemberString = 'Test';
        //calling searchMember() method
        rbObj.searchMember();

        system.assertEquals(0,rbObj.memberList.size());
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
        ReturnBook rbObj1 = new ReturnBook();
        rbObj1.searchBookString = 'Member';
        //Calling serachBook();
        rbObj1.searchMember();
        
        system.assertEquals(3,rbObj1.memberList.size());
        Test.stopTest();
    }


    static testMethod void issuedBooksToMemberTest() {
        //Creating Book data
        Book__c bObj1 = new Book__c();
        bObj1.Name = 'Book 1';
        bObj1.No_Of_Copies__c = 10;
        insert bObj1;

        Book__c bObj2 = new Book__c();
        bObj2.Name = 'Book 2';
        bObj2.No_Of_Copies__c = 5;
        insert bObj2;

        //Creating Library Member test data
        Library_Member__c lmObj1 = new Library_Member__c();
        lmObj1.Name = 'Member 1';
        lmObj1.Phone_No__c = '8888888888';
        insert lmObj1;

        //Creating Book Issued test data by setting member Id and book Id
        Book_Issued__c biObj1 = new Book_Issued__c();
        biObj1.Library_Member_Id__c = lmObj1.Id;
        biObj1.Book_Id__c = bObj1.Id;
        insert biObj1;

        Book_Issued__c biObj2 = new Book_Issued__c();
        biObj2.Library_Member_Id__c = lmObj1.Id;
        biObj2.Book_Id__c = bObj2.Id;
        insert biObj2;


        Test.startTest();
        //Setting parameter to as Library Member Id
        ApexPages.currentPage().getParameters().put('memberId',lmObj1.Id);

        //Creating ReturnBook object and calling issuedBooksToMember() method.
        ReturnBook rbObj = new ReturnBook();
        rbObj.issuedBooksToMember();

        //Check weather 2 books are allocated to lmObj1 user
        system.assertEquals(2,rbObj.bookIssuedList.size());

        //Checking weather Fine is calculated
        Book_Issued__c biObj3 = new Book_Issued__c();
        biObj3.Library_Member_Id__c = lmObj1.Id;
        biObj3.Book_Id__c = bObj2.Id;
        biObj3.Issue_Date__c = Date.newInstance(2015, 2, 1);
        biObj3.Due_Date_For_Return__c = Date.newInstance(2015, 2, 7);
        biObj3.Date_Returned__c = Date.newInstance(2015, 3, 23);
        insert biObj3;

        Book_Issued__c biObj4 = [Select Id, Name, Library_Member_Id__c, Issue_Date__c, Due_Date_For_Return__c, Date_Returned__c, Book_Id__c, Extra_Days__c, Amount_Of_Fine__c From Book_Issued__c Where Id = :biObj3.Id];

        //Check weather Extra days are set
        system.assertEquals(44,biObj4.Extra_Days__c);
        //Check weather Fine is calculated
        system.assertEquals(440,biObj4.Amount_Of_Fine__c);
        Test.stopTest();
    }

    static testMethod void acceptReturnedBookTest() {
        Book__c bObj1 = new Book__c();
        bObj1.Name = 'Book 1';
        bObj1.No_Of_Copies__c = 10;
        insert bObj1;

        //Creating Library Member test data
        Library_Member__c lmObj1 = new Library_Member__c();
        lmObj1.Name = 'Member 1';
        lmObj1.Phone_No__c = '8888888888';
        insert lmObj1;

        //Creating Book Issued test data by setting member Id and book Id
        Book_Issued__c biObj1 = new Book_Issued__c();
        biObj1.Library_Member_Id__c = lmObj1.Id;
        biObj1.Book_Id__c = bObj1.Id;
        insert biObj1;


        Test.startTest();
        //Setting parameter to as Issued Book Id
        ApexPages.currentPage().getParameters().put('issueBookId',biObj1.Id);

        //Creating ReturnBook object and calling acceptReturnedBook() method.
        ReturnBook rbObj = new ReturnBook();
        rbObj.acceptReturnedBook();
        
        //Check weather Return Date is set
        Book_Issued__c biObj2 = [Select Id, Name, Library_Member_Id__c, Issue_Date__c, Due_Date_For_Return__c, Date_Returned__c, Book_Id__c, Extra_Days__c, Amount_Of_Fine__c From Book_Issued__c Where Id = :biObj1.Id];
        system.assertEquals(system.Today(),biObj2.Date_Returned__c);

        //Check weather No of copies of the book is incremented
        Book__c bObj2 = [Select Id, Name, No_Of_Copies__c FROM Book__c WHERE Id = :bObj1.Id];
        system.assertEquals(11,bObj2.No_Of_Copies__c);
        Test.stopTest();
    }

}
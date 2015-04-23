/*
    Handler class for ReturnBookPage in Library Managemnet Application
    ========================================================================================================================
        Version   | Date        | Author        | Comments
    -------------------------------------------------------------------------------------------------------------------------
        1.0       | 19-03-2015  | Jatin Bedse   | 1. Created ReturnBook Controller class.
                  | 19-03-2015  | Jatin Bedse   | 2. Created serachMember() method.
                  | 19-03-2015  | Jatin Bedse   | 3. Created issuedBooksToMember() method.
                  | 19-03-2015  | Jatin Bedse   | 4. Created calculateFine() method.
    ========================================================================================================================
*/

public with sharing class ReturnBook {

    public Book__c bookObj {get; set;}
    public Library_Member__c libraryMemberObj {get; set;}
    public Book_Issued__c bookIssuedObj {get; set;}
    public List<Book_Issued__c> bookIssuedList {get; set;}
    public String searchBookString {get; set;}
    public List<List<SObject>> searchBookResultList;
    public List<Book__c> bookList {get; set;}
    public String searchMemberString {get; set;}
    public List<List<SObject>> searchMemberResultList;
    public List<Library_Member__c> memberList {get; set;}
    public Boolean renderVar{get; set;}
    public Id selectedMemberId;
    public Id bookIssueId;


    public ReturnBook(){
        bookObj = new Book__c();
        libraryMemberObj = new Library_Member__c();
        bookIssuedObj = new Book_Issued__c();
        bookIssuedList = new List<Book_Issued__c>();
        searchBookString = '';
        searchBookResultList = new List<List<SObject>>();
        bookList = new List<Book__c>();
        searchMemberString = '';
        searchMemberResultList = new List<List<SObject>>();
        memberList = new List<Library_Member__c>();
        renderVar = true;
        selectedMemberId = null;
        bookIssueId = null;
    }

    // This method searches the member
    public void searchMember(){
        try{
            memberList.clear();
            bookIssuedList.clear();
            searchMemberString += '*';
            searchMemberResultList = [FIND :searchMemberString IN ALL FIELDS RETURNING Library_Member__c(Id, Library_Member_No__c, Name,Phone_No__c)];
            if(searchMemberResultList[0].size() != 0){
               memberList = searchMemberResultList[0];
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Member Not Found'));
            }
        }
        catch(Exception e){
            System.debug('Search Member Exception :' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Search term must be longer than one character'));
        }
    }

    public void issuedBooksToMember(){
        try{
            selectedMemberId = ApexPages.currentPage().getParameters().get('memberId');
            bookIssuedList = [Select Id, Name, Library_Member_Id__c, Issue_Date__c, Due_Date_For_Return__c, Date_Returned__c, Book_Id__c, Extra_Days__c, Amount_Of_Fine__c From Book_Issued__c Where Library_Member_Id__c = :selectedMemberId  ORDER BY Date_Returned__c DESC];
        }
        catch(Exception e){
            system.debug('Issued Books To Member Exception : '+e);
        }
    }
    
    public void acceptReturnedBook(){
        try{
            bookIssueId = ApexPages.currentPage().getParameters().get('issueBookId');
            bookIssuedObj = [Select Id, Name, Library_Member_Id__c, Issue_Date__c, Due_Date_For_Return__c, Date_Returned__c, Book_Id__c, Extra_Days__c, Amount_Of_Fine__c From Book_Issued__c Where Id = :bookIssueId];
            bookIssuedObj.Date_Returned__c = system.Today();
            update bookIssuedObj;
            bookObj = [Select Id, No_Of_Copies__c From Book__c Where Id = :bookIssuedObj.Book_Id__c];
            bookObj.No_Of_Copies__c ++;
            update bookObj;
            bookIssuedList = [Select Id, Name, Library_Member_Id__c, Issue_Date__c, Due_Date_For_Return__c, Date_Returned__c, Book_Id__c, Extra_Days__c, Amount_Of_Fine__c From Book_Issued__c Where Library_Member_Id__c = :selectedMemberId];
        }
        catch(Exception e){
            system.debug('Accept Returned Book Exception : '+e);
        }
    }
}
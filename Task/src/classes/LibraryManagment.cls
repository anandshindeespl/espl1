/*
    Handler class for Library Managemnet
    
    ========================================================================================================================
        Version   | Date        | Author        | Comments
    -------------------------------------------------------------------------------------------------------------------------
        1.0       | 18-03-2015  | Jatin Bedse   | 1. Created Library Managment Controller class.
                  | 18-03-2015  | Jatin Bedse   | 2. Created searchBook() method.
                  | 18-03-2015  | Jatin Bedse   | 3. Created serachMember() method.
                  | 18-03-2015  | Jatin Bedse   | 4. Created issueBook() method.
    ========================================================================================================================
*/

public class LibraryManagment {

    public Book__c bookObj {get; set;}
    public Library_Member__c libraryMemberObj {get; set;}
    public Book_Issued__c bookIssuedObj {get; set;}
    public String searchBookString {get; set;}
    public List<List<SObject>> searchBookResultList;
    public List<Book__c> bookList {get; set;}
    public String searchMemberString {get; set;}
    public List<List<SObject>> searchMemberResultList;
    public List<Library_Member__c> memberList {get; set;}


    public LibraryManagment(){
        bookObj = new Book__c();
        libraryMemberObj = new Library_Member__c();
        bookIssuedObj = new Book_Issued__c();
        searchBookString = '';
        searchBookResultList = new List<List<SObject>>();
        bookList = new List<Book__c>();
        searchMemberString = '';
        searchMemberResultList = new List<List<SObject>>();
        memberList = new List<Library_Member__c>();
    }

    // This method searches the book name
    public void searchBook(){
        try{
            bookList.clear();
            searchBookString += '*';
            system.debug('---------------------------------searchBookString : '+searchBookString);
            searchBookResultList = [FIND :searchBookString IN ALL FIELDS RETURNING Book__c(Id, Name, Book_No__c, No_Of_Copies__c)];
            if(searchBookResultList[0].size() != 0){
               bookList = searchBookResultList[0];
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Book Not Found'));
            }
        }
        catch(Exception e){
            System.debug('Search Book Exception :' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Search term must be longer than one character'));
        }
    }


    // This method searches the member
    public void searchMember(){
        try{
            memberList.clear();
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

    // This method creates a Book_Issued__c record.
    public void issueBook(){
        try{
            bookIssuedObj.Library_Member_Id__c = libraryMemberObj.Id;
            bookIssuedObj.Book_Id__c = bookObj.Id;
            insert bookIssuedObj;

            bookObj.No_Of_Copies__c--;
            update bookObj;
            searchBookString = '';
            bookList.clear();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, bookObj.Name+' successfully issued to '+libraryMemberObj.Name+'. The last date to return book is '+bookIssuedObj.Due_Date_For_Return__c));
        }
        catch(Exception e){
            system.debug('Book Issue Exception : '+e);
        }
    }
}
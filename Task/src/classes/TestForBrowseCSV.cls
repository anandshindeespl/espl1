/**
*      to check whether  will it read the uploaded file extract the rows and columns from csv file or not
        and to check whether will it fill the list and send back to vf page or not
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   3rd march 2015
 ===========================================================================================================================================
 **/
@isTest
private class TestForBrowseCSV {

    static testMethod void myUnitTest()
    {
        //creating object of pagereferene
        PageReference Pageref=Page.BrowseAndDisplayDatatable;
        System.test.setCurrentPageReference(Pageref);
        ReadCSVActivity readcsv=new ReadCSVActivity();
        
        //to check initial size of list
        system.assertEquals(readcsv.accountList.size(),0);
        
        readcsv.size=200;
        readcsv.readFile();
        //to check whether will it fill the list or not
        system.assertNotEquals(readcsv.accountList.size(),0);
        
        
        readcsv.size=1024*152;
        readcsv.readFile();
        system.assertEquals(readcsv.accountList.size(),0);
        
    }
}
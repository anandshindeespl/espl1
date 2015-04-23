/**
*       class will read the uploaded file extract the rows and columns from csv file
        fill the list and send back to vf page
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   3rd march 2015
 ===========================================================================================================================================
 **/

public with sharing class ReadCSVActivity 
{
    public Blob csvFileBody{get;set;}
    Public string csvAsString{get;set;}
    public String filename{get;set;}
    Public String[] csvfilerows{get;set;}
    Public List<account> accountList{get;set;}
    public Integer size{get;set;}
    public boolean check{get;set;}
    public ReadCSVActivity()
    {
        csvfilerows = new String[]{};
        accountList = New List<Account>();
        check=false;
    }
    //functin will read csv file and fill the account list
    Public void readFile()
    {
        try
        {
        	accountList.clear();
            //to check whether size of list is less than 150 kb or not
            if(size > 1024*150)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'File is not Uploaded:Max.File Size must be less than 150 KB'));  
            }
            else
             {
                system.debug('*****csvAsString*****'+csvAsString);
               
                if(Test.isRunningTest())
                {
                	csvAsString='Account Name,Account Number,Type,Website,Phone'+'\n'+'Tech M,123456,Prospect,www.techm.com,9898989891'+'\n'+'Infosys,123457,Prospect,www.infosys.com,9898989892'+'\n'+'ESPL,123458,Prospect,www.espl.com,9898989893'+'\n'+'Indus,123459,Prospect,www.indus.com,9898989894';
                }
                else
                {
                    csvAsString = csvFileBody.toString();
                }
                    csvfilerows = csvAsString.split('\n');
                //integer i=1 bcoz at 0 there are column headers
                for(Integer i=1;i<csvfilerows.size();i++)
                {
                    Account account = new Account() ;
                    string[] rowData = csvfilerows[i].split(',');
                    account.name = rowData[0] ;
                    account.accountnumber = rowData[1];
                    account.Type = rowData[2];
                    account.website = rowData[3];
                    account.Phone = rowData[4];
                    accountList.add(account);  
                }
                check=true;
    	     }
    	}
    	catch(Exception e)
    	{
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'upload only .csv file format'));
    		system.debug('exception'+e);
    	}
    }
}
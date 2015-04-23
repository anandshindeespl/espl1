public class ReverseString extends AbstarctDemo {
	
	public void main(){
		
		ReverseString obj = new ReverseString();
		
	    obj.reverse_String('anand');        // for reverse the String
	    
	    obj.stringOperation('Welcome to @pex Programming');      //to perform various string operations
	  
	    obj.fibonacci(10);                   //fibonacci series
	
	    Practice.staticDemo();               //it call the static metod from another class
	  
	    obj.helloWorld();                    //to print the hello world
	 
	    obj.show();                         // override method
	    
	    obj.occurence('anand');             // find the occurence of char in string 
	    
	    obj.queries();                      // All Contact records & add to the List and print that list.
	  
	    obj.queriesAccount();               // parent child relationship
	    
	    obj.printContact();                   // associated contact records of the Account
	  
	    
	    obj.mapUser();                      // User records where Active = true.
	}
	
	
	///  *** function for reverse the String*******	
	public String reverse_String(String str)
	{		
		String rev='';
		if(String.isBlank(str))
			{
		        System.debug('String is blank.');
		        return '';
		    }     
	   	else
		    {  
		        String s1= str.reverse();
		        System.debug('reverse string is'+ s1);
		        return s1;
			}
			return '';
	}

	public void stringOperation(String str)
	{				
		System.debug('String is '+str);
		
		//replacement for @ 
		String str1=Str.replace('@', 'A');      
		System.debug('new string is' + str1);
		
		// print the subString 
		System.debug('subString is '+ str1.substring(11) );    
		
		//split the string by space
	    String[] arr = str1.split(' ');
        for(String s:arr)
        {
        System.debug(s);
        }
          
	//remove the spaces 
		
		 String s2=str1.replaceAll( '\\s+', '');
		 System.debug('String without spaces is '+s2);
		
 
	// to uppercase
	String s4=str1.toUpperCase();
	System.debug('uppercase' + s4); 
	
	// to Lowercase
	//System.debug('Lowercase' + str1.toLowerCase());

	}
	
	// function to create fibonacci series
	public Integer fibonacci(integer n)
	{
		integer i,f0=1,f1=1,f2=0;  
	    for(i=0;i<=n;i++)  
	    {  
	      f2=f0+f1;  
	      f0=f1;  
	      f1=f2;  
	      f2=f0;  
	      System.debug('finacci series is '+ f2);  
    	}
    	
    	return f2;
	}
	
	//method to print hello world
	public void helloWorld()
		{
			System.debug('Hello World');
		}
	
	//override the method 
	public override void show()
	{
		System.debug('now method is overrided');
	}

	// function to count the occurence of string

	public Map<String,Integer> occurence(String source)
	{
     String[] chars = source.split('');
	 chars.remove(0);
     System.debug(chars);
     System.debug('-----'+chars[0]);

     Map <String, Integer> MyMap = new Map <String,Integer>();

     for(integer i=0; i<chars.size();i++)
       {
	       if(chars[i]!='')
	       {
	       if(MyMap.containsKey(chars[i]))
	            {   
	               MyMap.put(chars[i],(MyMap.get(chars[i]))+1);
	            }    
	       else
	            {
	               MyMap.put(chars[i],1);
	            }
       		}
   		}
            System.debug('------Map---'+MyMap);
            return myMap;
            
	}
	
	
	//queries section 
	
	// // Query on All Contact records & add to the List and print that list.
	
	public List<Contact> queries()
	{
		
	   List <Contact> abList=new List<Contact>();
	   abList=[select id,Title,Languages__c,Level__c from Contact  ];
	   
	   for(Contact a : abList)
	   System.debug(a);
	   //List<Contact> contactList = a.Contacts;
	   return abList;
	}
	

	//function which find all the associated contact records of the Account and Print it
	
	public list <Contact> printContact()
	{
	    List<Contact> cont= new List<Contact>();       
        cont =[SELECT Id, Name, Phone FROM CONTACT WHERE AccountID <> NULL];
        for(Contact c : cont)
        system.debug(c);
        return cont;
	}
	
	//parent child relationship
		public List <Account> queriesAccount()
	{
		System.debug('----------------debug');	
	    List <Account> abList2=new List<Account>();		
		abList2 =[SELECT Id, Name, (SELECT Id, FirstName, LastName FROM Contacts) FROM Account];
	    for(Account c : abList2)
	    {
		System.debug(c);
	    }
	    return abList2 ;
	   
	}
	
	// Write a SOQL query to retrieve/print the User records where Active = true. Prepare the
    //Map having User Id as key and User record as value

	public Map <Id ,User> mapUser()
	
	{
		Map <Id,User> mapp= new Map<Id,User>();	
		List <User> userList=new List<User>();
		userList=[select Id,Name,Username,Phone,Email,Address from User where IsActive=TRUE];
		for(User u : userList)
		mapp.put(u.Id ,u);
		System.debug('---------'+ mapp);
		
		return mapp;
		
	}
	
	 //Prepare the Following Map Structures :
    //a. AccountName as key and AccountId as Value
    //b. AccountId as key Entire Account object as Value
	public void mapAccount()
	{
		Map <String,Id> mapp1= new Map<String,Id>();	
		
		Map <Id,Account> mapp2= new Map<Id,Account>();	
	}
	
    public void parse()
    {
        String var='{"name" :"anand"}';
        Map<String, Object> mapp = (Map<String, Object>) JSON.deserializeUntyped(var);
        system.debug('-------------'+mapp);
    }
}
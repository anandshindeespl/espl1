public Class StrudentRegistration
{
    public Student__c student{get;set;}
   
    public Boolean varF{get;set;}
    public Boolean varT{get;set;}
    public String pickvalue{get;set;}
    public String lang {get;set;}

    public StrudentRegistration(ApexPages.StandardController controller)
        {
            lang='en';
            varF=false;
            varT=true;
           student =new Student__C();
        }
        public void saveStudent()
        {
             varF=true;
             varT=false;         
            insert student;
        
        }
	public void changeLanguage()
		{
			String currentuserId = UserInfo.getUserId();
	        User currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId()];
	        lang=pickvalue;
	        //currentUserInfo.LanguageLocaleKey = pickvalue;
	        update currentUserInfo;
		}
    
}
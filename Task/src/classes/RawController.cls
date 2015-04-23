public with sharing class RawController {
    public String name{get;set;}
    public PageReference Redirect()
    {
        system.debug('in code');
        name='Anand';
        PageReference pageRef = new PageReference('/apex/RawPage2');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void checkdemo(){system.debug('andy'+System.Label.Loading);} 
    
}
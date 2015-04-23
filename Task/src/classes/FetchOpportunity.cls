public with sharing class FetchOpportunity 
{
        public list <Opportunity> oppLst{get;set;}
        public FetchOpportunity(ApexPages.StandardController controller)
        {
            fetchOpp();
        }
        public void fetchOpp()
        {
            oppLst=[select Id, Name, Amount, StageName, CloseDate from Opportunity where OwnerId =:UserInfo.getUserId()] ;
            system.debug('******oppLst*****'+oppLst);
        }
}
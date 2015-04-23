/**
*   //if origin is Email or Web or Chat then Account Id will get filled in Case object

**/
public class HandlerCase {
	 
	 //if origin is Email or Web or Chat then Account Id will get filled in Case object
	public void checkCaseRecord(List<Case> caseList )
    {
		List<Account>accList=new List<Account>();
		Map<String,ID> mapEmailSet=new Map<String,ID>();
		accList=[select ID,Email_Id__c from Account];
    for (Account accobj : accLIst)
        {
            mapEmailSet.put(accobj.Email_Id__c,accobj.ID);
        }
    for(Case caseobj:caseList)
        {
            if(caseobj.Origin=='Email' || caseobj.Origin=='Web'||caseobj.Origin=='Chat')
                {
                    if(mapEmailSet.containsKey(caseobj.Email_Id__c))
                    {
                        caseobj.Account_ID__c=mapEmailSet.get(caseobj.Email_Id__c);
                    }   
                }
        }
}
}
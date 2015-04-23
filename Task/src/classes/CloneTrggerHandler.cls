/**
**  will create the clone of a record after insert or Update
*/
public class CloneTrggerHandler 
{
   //will create the clone of a record after insert or Update
   public void cloneHandler(List <Lead> leadList )
   {
   		Lead newlead;
	    //list<Lead> lstLead= new list<Lead>();
	    for(Lead leadobj : leadList)
	    {
		    if(RecursiveClass.flag == true)
		    {
			   RecursiveClass.flag = false;
			   newlead = leadobj.clone();
			   leadList.add(newlead);
			   system.debug('**************************Clone records'+leadList);
		  	}
	    }
	 		if(!leadList.isEmpty())
				{
					insert leadList;
				}
   		
   }
}
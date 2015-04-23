/**
*   trigger will create the clone of a record after insert or Update
t**/
trigger CloneOfLead on Lead (after insert,after update)
 {
     // trigger will create the clone of a record after insert or Update
      Lead newlead;
      list<Lead> lstLead= new list<Lead>();
      if(RecursiveClass.flag == true)
        {
            RecursiveClass.flag = false;
            for(Lead leadobj : Trigger.new)
            {
            Lead leadrec=new Lead();
            leadrec=[select ID from lead where Id =: leadobj.ID];
            newlead = leadobj.clone();
            newlead.Parent_Id__C=leadrec.ID;
            lstlead.add(newlead);
            system.debug('**************************Clone records'+lstlead);
         }
    if(!lstlead.isEmpty())
        {
                  insert lstlead;
        }    
  }
}
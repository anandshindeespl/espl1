public class InsertintoLead
{
    public void InsertLead()
    {
        List<Lead> leadList= new List<Lead>();
       /* Lead c=new Lead();        
        c.FirstName='amol';
        c.LastName='pawar'; 
        c.Company='ESPL';       
        cont.add(c);
        insert c;*/
        
        
        
         leadList=[select Id ,Email ,Phone from Lead where FirstName='amol' and LastName='pawar' ];
        if(leadList.size()!= null)
            {
                for(Lead l:leadList)
                {
                    l.Email='anand@anand.com';
                    l.Phone='1212121212';
                }
            update leadList;
    

}
}
}
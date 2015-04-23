public class InsertintoContact
{
    public void InsertContact()
    {
        List<Contact> cont= new List<Contact>();
        Contact c=new Contact();        
        c.FirstName='amol';
        c.LastName='pawar';
        c.Languages__c='english';
        cont.add(c);
        insert c;
    }

}
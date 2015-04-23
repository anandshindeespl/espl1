public class InsertintoOPP
{
    public void InsertOpp()
    {
  // Date dt=(Date)'1/14/2015' ;
        List<Opportunity> cont= new List<Opportunity>();
        Opportunity c=new Opportunity();        
        c.Name='indus';
        c.StageName='Qualification';
      
        c.CloseDate= system.today().addDays(+20);
            
        cont.add(c);
        insert c;
    }

}
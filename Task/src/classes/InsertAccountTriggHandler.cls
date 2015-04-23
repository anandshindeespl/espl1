public with sharing class InsertAccountTriggHandler {

    @future
    public static void InsertAccount1(list<Id> accList) {
    	system.debug('in account trigger'+accList);
        list<Account> AccountList=new List<Account>();
        list<Contact> Contactlst=new List<Contact>();
        List<Account> accts = [SELECT Name FROM Account WHERE Id IN :accList];
        system.debug('listt55'+accList);
        for(Account acc : accts){
            system.debug('acc---------'+acc);
            acc.Name= 'testESPL';
            acc.SLA__c = 'Gold';
            AccountList.add(acc);
        }
        system.debug('acc---------'+accts);
    }

    //execute before update
    public static void InsertAccount2(list<Account> accList) {
        system.debug('in account trigger'+accList);
        list<Account> AccountList1=new List<Account>();
        list<Contact> Contactlst=new List<Contact>();
        //List<Account> accts = [SELECT Name FROM Account WHERE Id IN :accList];
        for(Account acc : accList){
            system.debug('acc---------'+acc);
            acc.Name= 'testESPL';
            acc.SLA__c = 'Gold';
            AccountList1.add(acc);
        }
        system.debug('acc---------'+AccountList1);
    }
    
        //execute on before insert
	    public static void InsertAccount3(list<Account> accList) {
        system.debug('in account trigger'+accList);
        list<Account> AccountList=new List<Account>();
        for(Account acc : accList){
            acc.Name= 'testESPL';
            acc.SLA__c = 'Gold';
            AccountList.add(acc);
        }
        system.debug('acc---------'+AccountList);
    }
    

}
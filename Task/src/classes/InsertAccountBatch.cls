global class InsertAccountBatch implements Database.Batchable<sObject> {
	
	global Database.QueryLocator start(Database.BatchableContext bc) {
    
      return Database.getQueryLocator([SELECT Id, Name FROM Account WHERE Name ='Eternus Solutions']);
 
	} 
	
	 global void execute(Database.BatchableContext BC, List<Account> accountList){
	 	
	 	system.debug('in account trigger'+accountList);
        list<Account> AccntList=new List<Account>();
        for(Account acc : accountList){
            system.debug('acc---------'+acc);
            acc.Name= 'testESPL';
            acc.SLA__c = 'Gold';
            AccntList.add(acc);
        }
            update AccntList;
	 }
	 
	 global void finish(Database.BatchableContext BC){
	 	
	 }


}
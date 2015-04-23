trigger InsertAccountsRecords on Account (before update, before insert) {
    
    if(Trigger.isUpdate && Trigger.isBefore)
            {
            	system.debug('in account trigger');
               // InsertAccountTriggHandler insertAcc = new InsertAccountTriggHandler();
               List<Id> lstiD = new List<Id>();
               
                for(Account acc : Trigger.new){
                	
                	lstiD.ADD(acc.iD);
                }
                
                ///Database.executeBatch(new InsertAccountBatch(lstiD));
                InsertAccountTriggHandler.InsertAccount1(lstiD);
                //InsertAccountTriggHandler.InsertAccount2(Trigger.new);
            }
    if(Trigger.isInsert && Trigger.isBefore)
            {
                system.debug('in account trigger11111');
                // InsertAccountTriggHandler insertAcc = new InsertAccountTriggHandler();
                InsertAccountTriggHandler.InsertAccount3(trigger.new);
            }        
            
            
}
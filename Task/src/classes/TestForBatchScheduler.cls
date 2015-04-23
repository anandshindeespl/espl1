/**
 * Test for a code which schedule the next execution every minutes from now
 */
@isTest
private class TestForBatchScheduler {

    static testMethod void myUnitTest() {
    	
    	datetime nextScheduleTime = system.now().addMinutes(1);
        string minute = string.valueof(nextScheduleTime.minute());
        string second = string.valueof(nextScheduleTime.second ());
        string cronvalue = second+' '+minute+' * * * ?' ;
        string jobName = 'BatchSchedulerTest ' +
        nextScheduleTime.format('hh:mm');
        
        BatchScheduler bScheduler=new BatchScheduler();
        system.schedule(jobName, cronvalue , bScheduler);
        BatchProcessor batchob = new BatchProcessor();
        database.executebatch(batchob,10);
        // TO DO: implement unit test
    }
}
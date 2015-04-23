/**
 ===========================================================================================================================================
    version    |    Author          |    Date 
    1.0        |    Anand Shinde    |   18 Feb 2015
 ===========================================================================================================================================
 **/
@isTest
private class TestForSearchEngineScheduler {

    static testMethod void myUnitTest() {
        datetime nextScheduleTime = system.now().addMinutes(1);
        string minute = string.valueof(nextScheduleTime.minute());
        string second = string.valueof(nextScheduleTime.second ());
        string cronvalue = second+' '+minute+' * * * ?' ;
        string jobName = 'BatchScheduler ' +
        nextScheduleTime.format('hh:mm');
        
        system.schedule(jobName, cronvalue , new googleSearchScheduler());
        BatchEmailProcessor batchobj = new BatchEmailProcessor();
        database.executebatch(batchobj,10);
        
    }
}
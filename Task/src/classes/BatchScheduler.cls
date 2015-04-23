/**
**  This section of code will schedule the next execution every minutes from now
**/
global class BatchScheduler implements Schedulable
{
	
    global void execute(SchedulableContext sc)
    {
         // This section of code will schedule the next execution every minutes from now
       
        datetime nextScheduleTime = system.now().addMinutes(1);
        string minute = string.valueof(nextScheduleTime.minute());
        string second = string.valueof(nextScheduleTime.second ());
        string cronvalue = second+' '+minute+' * * * ?' ;
        string jobName = 'BatchScheduler ' +
        nextScheduleTime.format('hh:mm');
 
        system.schedule(jobName, cronvalue , new BatchScheduler());
        BatchProcessor batchobj = new BatchProcessor();
        database.executebatch(batchobj,10);
 
       // this section of code will abort the current schedule job
       //  system.abortJob(sc.getTriggerId());
 
    }
}
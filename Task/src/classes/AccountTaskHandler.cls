public  class AccountTaskHandler {
	
	
	public void createTask(List<Account> account)
	{
		
		System.debug('---------------in task');
		List<Task> newTasks = new List<Task>();
		for(Account accItr : account)
		{
			newTasks.add(new Task(
            ActivityDate = Date.today(),
            Status = 'Not Started',
            type = 'Other',
            Priority = 'Normal',
            Subject = 'Meeting with ' + accItr.Name         
            ));
		}
		
		if(!newTasks.isEmpty())
		{
			 insert newTasks;
		}
	}
}
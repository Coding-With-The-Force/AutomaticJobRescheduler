/**
 * @description An example of a continually rescheduling job.
 * @author Matt Gerry
 * @date 9/5/2020
 */

public with sharing class Repeating_Scheduler_Example implements Schedulable
{
	private final String JOB_NAME = 'Repeating Job';
	private final Integer ONE_MINUTE = 1;

	/**
    * @description The execute method fires each time the scheduler is run. Unless there is a constructor, this is always the first method to fire.
    * @param cont Schedulable context instantiated by the Schedulable implementation
    * @example System.schedule(JOB_NAME, cronExpression, new Repeating_Scheduler_Example());
    */
	public void execute(SchedulableContext cont)
	{
		new Repeating_Scheduler_Case_Insert().insertCase();
		findAndAbortJob(cont);
	}

	/**
	* @description Aborts the existing scheduled job. Then calls rescheduleJob to reschedule this job.
	* @param cont Schedulable context instantiated by the Schedulable implementation
	* @example finaAndAbortJob(cont);
	*/
	private void findAndAbortJob(SchedulableContext cont)
	{
		if (cont == null)
		{
			return;
		}

		//Need to query CronJobDetail to find our currently active scheduled job
		List<CronJobDetail> cronDetail = [SELECT Id FROM CronJobDetail WHERE Name= :JOB_NAME LIMIT 1];

		if (cronDetail.isEmpty())
		{
			return;
		}

		//Need to find the corresponding cron trigger to be able to abort the scheduled job
		List<CronTrigger> cronTriggers = [SELECT Id FROM CronTrigger WHERE CronJobDetailId = :cronDetail[0].Id];

		if(cronTriggers.isEmpty())
		{
			return;
		}

		try
		{
			//Aborts the job current setup for this scheduled class
			System.abortJob(cronTriggers[0].Id);
			rescheduleJob();
		}
		catch (Exception e)
		{
			System.debug('This was the error ::: ' + e.getMessage());
		}
	}

	/**
	* @description Reschedules this job for one minute in the future.
	* @example rescheduleJob();
	*/
	private void rescheduleJob()
	{
		Datetime sysTime = System.now().addMinutes(ONE_MINUTE);
		String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
		System.schedule(JOB_NAME, cronExpression, new Repeating_Scheduler_Example());
	}
}
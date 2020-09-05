/**
 * Created by gerry on 9/5/2020.
 */

public with sharing class Repeating_Scheduler_Case_Insert
{
	private final String NEW_STATUS = 'New';
	private final String PHONE_ORIGIN = 'Phone';

	public void insertCase()
	{
		Case caseToInsert = new Case();
		caseToInsert.Status = NEW_STATUS;
		caseToInsert.Origin = PHONE_ORIGIN;
		caseToInsert.Subject = 'Kewl Case Bruh ' + Datetime.now();
		Database.insert(caseToInsert);
	}
}
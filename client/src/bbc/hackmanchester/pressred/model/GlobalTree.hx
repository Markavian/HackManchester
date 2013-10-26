package bbc.hackmanchester.pressred.model;

/**
 * The global data tree
 * @author John Beech
 */
class GlobalTree extends BaseModel
{
	public var hackTimer:TimerModel;
	public var timetable:TimetableModel;

	public function new() 
	{
		super();
		
		hackTimer = new TimerModel();
		timetable = new TimetableModel();
	}
}
package testClasses
{
	import flash.events.Event;
	
	public class TestEvent extends Event
	{
		static public const TEST_EVENT_ONE:String = "testEventOne";
		static public const TEST_EVENT_TWO:String = "testEventTwo";
		
		public function TestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
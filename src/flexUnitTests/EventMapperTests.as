package flexUnitTests
{
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import ab.fl.utils.events.eventMapper.EventMapper;
	
	import spark.components.Button;
	
	import testClasses.TestEvent;

	public class EventMapperTests
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		
		[Test(order="1")]
		public function testInstantiation():void
		{
			const eventDispatcher:EventDispatcher = new EventDispatcher();
			
			const eventMappers:EventMapper = new EventMapper(eventDispatcher, TestEvent, testCallBack);
			
			assertTrue(eventMappers is EventMapper);
		}
		
		
		[Test(order="2")]
		public function testHasEventListener():void
		{
			const eventMapper:EventMapper = new EventMapper(new EventDispatcher(), TestEvent, testCallBack);
			
			const hasEvent:Boolean = eventMapper.hasEvent(TestEvent.TEST_EVENT_ONE);
			
			assertTrue(hasEvent);
		}
		
		
		[Test(order="3")]
		public function testEventDispatch():void
		{
			const dispatcher:EventDispatcher = new EventDispatcher();
			const eventMapper:EventMapper = new EventMapper(dispatcher, TestEvent, testCallBack);
			
			dispatcher.dispatchEvent(new TestEvent(TestEvent.TEST_EVENT_ONE));
			
			assertTrue(_testHeard);	
		}
		private var _testHeard:Boolean = false;
		protected function testCallBack(event:TestEvent):void
		{
			_testHeard = true;
		}
		
		
		[Test(order="4")]
		public function testDestruction():void
		{
			const dispatcher:EventDispatcher = new EventDispatcher();
			const eventMapper:EventMapper = new EventMapper(dispatcher, TestEvent, testCallBack);
			
			eventMapper.destroy();
			
			assertFalse(eventMapper.hasEvent(TestEvent.TEST_EVENT_ONE));
		}
		
		
		[Test(order="5")]
		public function testMapEvent():void
		{
			const dispatcher:EventDispatcher = new EventDispatcher();
			
			const eventMapper:EventMapper = new EventMapper(dispatcher, TestEvent, testCallBack);
			
			eventMapper.map(TestEvent.TEST_EVENT_TWO, _handleSecondEvent);
		}
		private var _secondEventHandled:Boolean = false;
		private function _handleSecondEvent(event:TestEvent):void
		{
			_secondEventHandled = true;
			assertTrue(_secondEventHandled);
		}
		
		
		[Test(order="6")]
		public function testOmitEvents():void
		{
			const dispatcher:EventDispatcher = new EventDispatcher();
			const eventMapper:EventMapper = new EventMapper(dispatcher, TestEvent, omitTestCallBack);
			eventMapper.omit(TestEvent.TEST_EVENT_ONE);
			
			_dispatchBothTestEvents(dispatcher);
			
			_assertOnlyTestEventTwoWasHeard();
		}
		private var _omitTestEventsHeard:Array = [];
		private function omitTestCallBack(event:TestEvent):void
		{
			_omitTestEventsHeard.push(event.type);
		}
		private function _assertOnlyTestEventTwoWasHeard():void
		{
			trace("_omitTestEventsHeard = " + _omitTestEventsHeard.toString());
			assertTrue("Heard more than one event.", _omitTestEventsHeard.length == 1);
			assertTrue("Event type heard is not the TEST_EVENT_TWO event string.", _omitTestEventsHeard.toString() == TestEvent.TEST_EVENT_TWO);
		}
		
		
		[Test(order="7")]
		public function testClearOmissions():void
		{
			const dispatcher:EventDispatcher = new EventDispatcher();
			const eventMapper:EventMapper = new EventMapper(dispatcher, TestEvent, omitTestCallBack);
			eventMapper.omit(TestEvent.TEST_EVENT_ONE);
			
			_dispatchBothTestEvents(dispatcher);
			
			_assertOnlyTestEventTwoWasHeard();
			
			
			
			while (_omitTestEventsHeard.length)
				_omitTestEventsHeard.pop();
			
			
			
			eventMapper.clearOmissions();
			
			_dispatchBothTestEvents(dispatcher);
			
			_assertBothEventsWereHeard();
		}
		private function _assertBothEventsWereHeard():void
		{
			assertTrue("Didn't hear two events.", _omitTestEventsHeard.length == 2);
			assertTrue("Did not hear both events in expected order.", _omitTestEventsHeard.toString() == TestEvent.TEST_EVENT_ONE+","+TestEvent.TEST_EVENT_TWO);
		}
		
		private function _dispatchBothTestEvents(dispatcher:EventDispatcher):void
		{
			dispatcher.dispatchEvent(new TestEvent(TestEvent.TEST_EVENT_ONE));
			dispatcher.dispatchEvent(new TestEvent(TestEvent.TEST_EVENT_TWO));
		}
	}
}
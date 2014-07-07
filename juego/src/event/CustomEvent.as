package event
{
	import flash.events.Event;
	
	public class CustomEvent extends Event
	{
		private var _data:Object;
		
		public function CustomEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

	}
}
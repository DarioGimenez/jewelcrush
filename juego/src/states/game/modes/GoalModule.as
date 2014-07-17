package states.game.modes
{
	import flash.display.MovieClip;

	public class GoalModule
	{
		private var _type:String;
		private var _source:MovieClip;
		private var _goal:int;
		private var _current:int;
		
		private var _enable:Boolean;
		
		public function GoalModule()
		{
		}
		
		public function get enable():Boolean
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void
		{
			_enable = value;
			_source.alpha = (_enable) ? 1 : 0.2;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get source():MovieClip
		{
			return _source;
		}

		public function set source(value:MovieClip):void
		{
			_source = value;
		}

		public function get goal():int
		{
			return _goal;
		}

		public function set goal(value:int):void
		{
			_goal = value;
		}

		public function get current():int
		{
			return _current;
		}

		public function set current(value:int):void
		{
			_current = value;
		}

	}
}
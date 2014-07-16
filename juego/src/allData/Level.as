package allData
{
	public class Level
	{
		public static const GAME_MODE_CLASSIC:String = "classic";
		public static const GAME_MODE_QUEST:String = "quest";
		public static const GAME_MODE_BOSS:String = "boss";
		
		private var _levelConfig:XML;
		private var _gameMode:String;
		private var _initialLines:int;
		private var _newLineTimer:int;
		private var _chanceWeightBall:int;
		private var _chanceColorBall:int;
		private var _goal:Object;
		
		public function Level(levelConfig:XML)
		{
			_levelConfig = levelConfig;
			
			_gameMode = String(levelConfig.@mode);
			_initialLines = int(levelConfig.@initialLines);
			_newLineTimer = int(levelConfig.@newLineTimer);
			_chanceWeightBall = int(levelConfig.@weightBallProb);
			_chanceColorBall = int(levelConfig.@colorBallProb);
			_goal = String(levelConfig.@goal);
			
			
		}
		
		public function get levelConfig():XML
		{
			return _levelConfig;
		}
			

		public function get gameMode():String
		{
			return _gameMode;
		}
		
		public function get initialLines():int
		{
			return _initialLines;
		}
		
		public function get newLineTimer():int
		{
			return _newLineTimer;
		}
		
		public function get chanceWeightBall():int
		{
			return _chanceWeightBall;
		}

		public function get chanceColorBall():int
		{
			return _chanceColorBall;
		}
		
		public function get goal():Object
		{
			return _goal;
		}

	}
}
package allData
{
	public class Level
	{
		public static const GAME_MODE_CLASSIC:int = 0;
		public static const GAME_MODE_QUEST:int = 1;
		public static const GAME_MODE_BOSS:int = 2;
		
		private var _gameMode:String;
		private var _initialLines:int;
		private var _newLineTimer:int;
		private var _chanceWeightBall:int;
		private var _chanceColorBall:int;
		private var _target:Object;
		
		public function Level(levelConfig:XML)
		{
			_gameMode = String(levelConfig.@mode);
			_initialLines = int(levelConfig.@initialLines);
			_newLineTimer = int(levelConfig.@newLineTimer);
			_chanceWeightBall = int(levelConfig.@weightBallProb);
			_chanceColorBall = int(levelConfig.@colorBallProb);
			_target = String(levelConfig.@target);
			
			
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
		
		public function get target():Object
		{
			return _target;
		}

	}
}
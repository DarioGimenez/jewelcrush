package allData
{
	import states.game.Ball;
	import states.game.Jewel;

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
		private var _chanceCountDown:int;
		private var _maxBalls:int;
		private var _goal:Object;
		private var _jewels:Vector.<String>;
		private var _balls:Vector.<String>;
		
		public function Level(levelConfig:XML)
		{
			_levelConfig = levelConfig;
			
			_gameMode = String(levelConfig.@mode);
			_initialLines = int(levelConfig.@initialLines);
			_newLineTimer = int(levelConfig.@newLineTimer);
			_chanceWeightBall = int(levelConfig.@weightBallProb);
			_chanceColorBall = int(levelConfig.@colorBallProb);
			_chanceCountDown = int(levelConfig.@rockProb);
			_maxBalls = int(levelConfig.@maxBalls);
			_goal = String(levelConfig.@goal);
			
			var jewelsStr:String = String(levelConfig.@jewels);
			var jewelsArr:Array = jewelsStr.split(",");
			_jewels = new Vector.<String>();
			_balls = new Vector.<String>();
			for(var i:int = 0; i < jewelsArr.length; i++)
			{
				switch(jewelsArr[i])
				{
					case "r":
						_jewels.push(Jewel.TYPE_RED);
						_balls.push(Ball.TYPE_RED);
						break;
					case "o":
						_jewels.push(Jewel.TYPE_ORANGE);
						_balls.push(Ball.TYPE_ORANGE);
						break;
					case "y":
						_jewels.push(Jewel.TYPE_YELLOW);
						_balls.push(Ball.TYPE_YELLOW);
						break;
					case "g":
						_jewels.push(Jewel.TYPE_GREEN);
						_balls.push(Ball.TYPE_GREEN);
						break;
					case "b":
						_jewels.push(Jewel.TYPE_BLUE);
						_balls.push(Ball.TYPE_BLUE);
						break;
					case "v":
						_jewels.push(Jewel.TYPE_VIOLET);
						_balls.push(Ball.TYPE_VIOLET);
						break;
				}
			}
			
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
		
		public function get chanceCountDown():int
		{
			return _chanceCountDown;
		}
		
		public function get maxBalls():int
		{
			return _maxBalls;
		}
				
		public function get jewels():Vector.<String>
		{
			var jewels:Vector.<String> = _jewels.slice();
			return jewels;
		}
		
		public function get balls():Vector.<String>
		{
			var balls:Vector.<String> = _balls.slice();
			return balls;
		}
	}
}
package allData
{
	public class GameData
	{
		/**
		 * 
		 * SINGLETON 
		 * 
		 **/
		
		private static var _instance:GameData;
		
		public function GameData()
		{
			gameMode = GAME_MODE_CLASSIC;
		}
		
		public static function get instance():GameData
		{
			if(_instance == null)
			{
				_instance = new GameData();
			}
			
			return _instance;
		}
		
		/**
		 * 
		 * CLASS
		 * 
		 **/
		
		public static const GAME_SCORE_BASE:int = 2;
		
		public static const GAME_MODE_ENDLESS:int = 0;
		public static const GAME_MODE_CLASSIC:int = 1;
		public static const GAME_MODE_COLOR:int = 2;
		
		public static const RESIZE_FACTOR:int = 0.33;
		
		public var gameMode:int;
		public var currentLevel:int;
		public var musicActive:Boolean = true;
		
		public function getCurrentLevel():Level
		{
			var level:Level = new Level(Levels.LEVELS.level[currentLevel])
			return level;
		}
		
		public function getGameModeLevels():Vector.<Level>
		{
			var levels:Vector.<Level> = Levels.LEVELS.level;
			return levels;
		}
	}
}
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
		public static const GAME_SCORE_VASE:int = 10;
		public static const MAX_COUNTDOWN_ONBOARD:int = 3;
		public static const MAX_VASES_ONBOARD:int = 2;
		
		public var currentLevel:int;
		public var musicActive:Boolean = true;
		
		public function getCurrentLevel():Level
		{
			var level:Level = new Level(Levels.LEVELS.level[currentLevel])
			return level;
		}
		
		public function getLevels():XML
		{
			return Levels.LEVELS;
		}
	}
}
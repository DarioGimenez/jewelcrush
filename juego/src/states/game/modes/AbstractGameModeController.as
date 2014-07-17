package states.game.modes
{
	import allData.Level;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	public class AbstractGameModeController extends EventDispatcher
	{	
		public static const EVENT_LEVEL_COMPLETE:String = "level_complete";
		
		protected var _container:Sprite;
		protected var _levelConfig:XML;
		protected var _goals:Vector.<GoalModule>;
		
		public static function getGameModeController(type:String):AbstractGameModeController
		{
			switch(type)
			{
				case Level.GAME_MODE_CLASSIC:
					return new GameModeClassicController();
					
				case Level.GAME_MODE_BOSS:
					return new GameModeBossController();
			}
			
			return null;
		}
		
		public function AbstractGameModeController()
		{
			
		}
		
		public function destroy():void
		{
			
		}
		
		public function init(container:Sprite, levelConfig:XML):void
		{
			_container = container;
			_levelConfig = levelConfig;
			
			build();
		}
		
		public function addJewels(q:int, type:String):void
		{
			
		}
		
		protected function build():void
		{
			
		}
		
		protected function createGoalModule(type:String, goal:int):void
		{
			
		}
		
		protected function getModuleByType(type:String):GoalModule
		{
			return null;
		}
		
		protected function updateScore(type:String):void
		{
			
		}
		
		protected function checkComeplete():void
		{
			
		}
		
	}
}
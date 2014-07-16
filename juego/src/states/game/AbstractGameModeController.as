package states.game
{
	import allData.Level;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	public class AbstractGameModeController extends EventDispatcher
	{	
		protected var _container:Sprite;
		protected var _levelConfig:XML;
		
		public static function getGameModeController(type:String):AbstractGameModeController
		{
			switch(type)
			{
				case Level.GAME_MODE_CLASSIC:
					return new GameModeClassicController();
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
		
		public function addJewels(q:int, type:int):void
		{
			
		}
		
		protected function build():void
		{
			
		}
		
	}
}
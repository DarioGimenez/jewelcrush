package states.game
{
	import allData.Level;
	
	import flash.display.Sprite;

	public class GameModeClassicController extends AbstractGameModeController
	{
		protected var _container:Sprite;
		
		public static function getGameModeController(type:String):AbstractGameModeController
		{
			switch(type)
			{
				case Level.GAME_MODE_CLASSIC:
					return new GameModeClassicController();
					break;
			}
		}
		
		public function GameModeClassicController()
		{
			
		}
		
		public function addJewels(q:int, type:int):void
		{
			
		}
		
		protected function build():void
		{
			
		}
	}
}
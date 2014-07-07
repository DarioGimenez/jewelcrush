package core
{
	import org.j2dm.core.J2DM_AbstractGameLoop;
	
	import states.StateGame;
	import states.StateMenu;
	
	public class GameLoop extends J2DM_AbstractGameLoop
	{
		public function GameLoop(valueFrameRate:int=24)
		{
			super(valueFrameRate);
		}
		
		protected override function create():void
		{
			super.create();
			
			changeState(StateMenu);
		}
	}
}
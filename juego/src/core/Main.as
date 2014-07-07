package core
{
	import core.GameLoop;
	
	import org.j2dm.core.J2DM_AbstractGameLoop;
	import org.j2dm.core.J2DM_AbstractMain;
	
	[SWF(width="600", height="900", frameRate="30")]
	public class Main extends J2DM_AbstractMain
	{
		public function Main()
		{
			super(new GameLoop(30), 600, 900);
		} 
	}
}
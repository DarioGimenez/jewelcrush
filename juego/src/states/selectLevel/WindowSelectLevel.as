package states.selectLevel
{
	import allData.GameData;
	import allData.Level;
	import allData.Levels;
	
	import event.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.j2dm.display.ui.J2DM_AbstractWindow;
	import org.j2dm.display.ui.components.J2DM_GenericButton;
	import org.j2dm.display.ui.components.J2DM_GenericButtonWithText;
	
	public class WindowSelectLevel extends J2DM_AbstractWindow
	{
		public static const EVENT_WINDOW_OK:String = "window_ok"; 
		
		private var _tfLevel:TextField;
		private var _tfTitle:TextField;
		private var _tfGoal:TextField;
		private var _btnPlay:J2DM_GenericButtonWithText;
		
		public function WindowSelectLevel()
		{
			super("selectLevel", new A_WindowSelectLevel());
		}
		
		public override function destroy():void
		{
			super.destroy();
			
			_btnPlay.destroy();
		}
		
		protected override function create():void
		{
			super.create();
			
			_tfLevel = _source.getChildByName("tfLevel") as TextField;
			_tfGoal= _source.getChildByName("tfGoal") as TextField;
			_tfTitle= _source.getChildByName("tfTitle") as TextField;
			
			var clip:MovieClip = _source.getChildByName("btnPlay") as MovieClip;
			_btnPlay = new J2DM_GenericButtonWithText("btnPlay", clip, "Start", buttonEvent);
		}
		
		public function loadLevel(level:Level):void
		{
			_tfLevel.text = "Level " + (GameData.instance.currentLevel + 1);
			
			var goal:String = "";
			var title:String = "";
			switch(level.gameMode)
			{
				case Level.GAME_MODE_CLASSIC:
					title = "CLASSIC";
					goal = "Collect the colors in any order";
					
					break;
				case Level.GAME_MODE_QUEST:
					title = "QUEST";
					goal = "Collect the vases taking them to the bottom of the board";
					
					break;
				case Level.GAME_MODE_BOSS:
					title = "BOSS";
					goal = "Collect the rainbow colors in an orderly";
					
					break;
			}
			_tfTitle.text = title;
			_tfGoal.text = goal;
			
			show();
		}
		
		private function playLevel():void
		{
			hide();
			
			var e:CustomEvent = new CustomEvent(EVENT_WINDOW_OK);
			dispatchEvent(e);
		}
		
		private function buttonEvent(type:String, button:J2DM_GenericButton):void
		{
			switch(type)
			{
				case MouseEvent.MOUSE_DOWN:
					switch(button)
					{
						case _btnPlay:
							playLevel();
							
							break;
					}
					
					break;
			}
		}
	}
}
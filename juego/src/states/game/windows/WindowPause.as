package states.game.windows
{
	import allData.SoundController;
	
	import event.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.j2dm.display.ui.J2DM_AbstractWindow;
	import org.j2dm.display.ui.components.J2DM_GenericButton;
	import org.j2dm.display.ui.components.J2DM_GenericButtonWithText;
	import org.j2dm.display.ui.components.J2DM_GenericCheckBox;
	
	public class WindowPause extends J2DM_AbstractWindow
	{
		public static const EVENT_WINDOW_CONTINUE:String = "window_continue";
		public static const EVENT_WINDOW_QUIT:String = "window_quit";
		
		private var _tfTitle:TextField;
		private var _btnContinue:J2DM_GenericButtonWithText;
		private var _btnQuit:J2DM_GenericButtonWithText;
		private var _btnMusic:J2DM_GenericCheckBox;
		private var _btnSound:J2DM_GenericCheckBox;
		
		public function WindowPause()
		{
			super("pause", new A_WindowPause());
		}
		
		public override function destroy():void
		{
			super.destroy();
			
			_btnContinue.destroy();
			_btnQuit.destroy();
			_btnMusic.destroy();
			_btnSound.destroy();
		}
		
		protected override function create():void
		{
			super.create();
			
			_tfTitle = _source.getChildByName("tfTitle") as TextField;
			
			var clip:MovieClip;
			
			clip = _source.getChildByName("btnContinue") as MovieClip; 
			_btnContinue = new J2DM_GenericButtonWithText("continue", clip, "Continue", buttonEvent);
			
			clip = _source.getChildByName("btnQuit") as MovieClip; 
			_btnQuit= new J2DM_GenericButtonWithText("quit", clip, "Quit", buttonEvent);
			
			clip = _source.getChildByName("btnMusic") as MovieClip; 
			_btnMusic = new J2DM_GenericCheckBox("music", clip, "y", buttonEvent);
			_btnMusic.checked = SoundController.instance.musicActive;
			
			clip = _source.getChildByName("btnSound") as MovieClip; 
			_btnSound= new J2DM_GenericCheckBox("sound", clip, "y", buttonEvent);
			_btnSound.checked = SoundController.instance.soundFxActive;
		}
		
		private function buttonEvent(type:String, button:J2DM_GenericButton):void
		{
			var e:CustomEvent;
			
			switch(type)
			{
				case MouseEvent.MOUSE_DOWN:
					switch(button)
					{
						case _btnContinue:
							hide();
							
							e = new CustomEvent(EVENT_WINDOW_CONTINUE);
							dispatchEvent(e);
							
							break;
						case _btnQuit:
							hide();
							
							e = new CustomEvent(EVENT_WINDOW_QUIT);
							dispatchEvent(e);
							
							break;
						case _btnMusic:
							SoundController.instance.musicActive = _btnMusic.checked;
							
							break;
						case _btnSound:
							SoundController.instance.soundFxActive = _btnSound.checked;
							
							break;
					}
					
					break;
			}
		
		}
	}
}
package states.game.windows
{
	import event.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.j2dm.display.ui.J2DM_AbstractWindow;
	import org.j2dm.display.ui.components.J2DM_GenericButton;
	import org.j2dm.display.ui.components.J2DM_GenericButtonWithText;
	
	public class WindowContinuePlaying extends J2DM_AbstractWindow
	{
		public static const EVENT_WINDOW_PLAY:String = "window_play";
		public static const EVENT_WINDOW_CANCEL:String = "window_cancel";
		
		private var _tfTitle:TextField;
		private var _tfText:TextField;
		private var _btnPlay:J2DM_GenericButtonWithText;
		private var _btnCancel:J2DM_GenericButtonWithText;
		
		public function WindowContinuePlaying()
		{
			super("continuePlaying", new A_WindowContinuePlaying());
		}
		
		public override function destroy():void
		{
			super.destroy();
			
			_btnPlay.destroy();
			_btnCancel.destroy();
		}
		
		protected override function create():void
		{
			super.create();
			
			_tfTitle = _source.getChildByName("tfTitle") as TextField;
			_tfText = _source.getChildByName("tfText") as TextField;
			
			var clip:MovieClip;
			
			clip = _source.getChildByName("btnPlay") as MovieClip; 
			_btnPlay = new J2DM_GenericButtonWithText("continue", clip, "Continue", buttonEvent);
			
			clip = _source.getChildByName("btnCancel") as MovieClip; 
			_btnCancel = new J2DM_GenericButtonWithText("cance", clip, "Cancel", buttonEvent);
			
		}
		
		private function buttonEvent(type:String, button:J2DM_GenericButton):void
		{
			var e:CustomEvent;
			
			switch(type)
			{
				case MouseEvent.MOUSE_DOWN:
					switch(button)
					{
						case _btnPlay:
							hide();
							
							e = new CustomEvent(EVENT_WINDOW_PLAY);
							dispatchEvent(e);
							
							break;
						case _btnCancel:
							hide();
							
							e = new CustomEvent(EVENT_WINDOW_CANCEL);
							dispatchEvent(e);
							
							break;
					}
					
					break;
			}
			
		}
	}
}
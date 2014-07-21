package ui
{
	import event.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextDisplayMode;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import org.j2dm.display.ui.J2DM_AbstractWindow;
	import org.j2dm.display.ui.components.J2DM_GenericButton;
	import org.j2dm.display.ui.components.J2DM_GenericButtonWithText;
	import org.j2dm.stage.J2DM_Stage;
	
	public class GenericWindow extends J2DM_AbstractWindow
	{
		public static const EVENT_WINDOW_ACTION:String = "window_action";
		
		private var _btn:J2DM_GenericButtonWithText;
		private var _tf:GenericTextfield;
		
		public function GenericWindow()
		{
			super("window", new MovieClip());
		}
		
		protected override function create():void
		{
			super.create();
			
			//bg
			graphics.lineStyle(0);
			graphics.beginFill(0x000000, 0.8);
			graphics.drawRect(0, 0, J2DM_Stage.getInstance().realStage.stageWidth, J2DM_Stage.getInstance().realStage.stageHeight);
			graphics.endFill();
			
			//tf
			_tf = new GenericTextfield(new A_Font1().fontName, 0xFFFFFF, TextFieldAutoSize.CENTER, 80);
			_tf.text = "";
			_tf.x = (J2DM_Stage.getInstance().realStage.stageWidth / 2) - (_tf.width / 2);
			_tf.y = 100;
			addChild(_tf);
			
			//btn
			var clip:MovieClip = new A_GenericButton();
			clip.x = (J2DM_Stage.getInstance().realStage.stageWidth / 2) - (clip.width / 2);
			clip.y = (J2DM_Stage.getInstance().realStage.stageHeight / 3) * 2; 
			_btn = new J2DM_GenericButtonWithText("next", clip, "", buttonCallback);
			
			addChild(_btn.source);
		}
		
		public function setText(text:String):void
		{
			_tf.text = text;
		}
		
		public function setButtonText(text:String):void
		{
			_btn.text = text;
		}
		
		private function buttonCallback(type:String, button:J2DM_GenericButton):void
		{
			switch(type)
			{
				case MouseEvent.MOUSE_DOWN:
				{
					switch(button)
					{
						case _btn:
							hide();
							
							var e:CustomEvent = new CustomEvent(EVENT_WINDOW_ACTION);
							dispatchEvent(e);
							
							break;
					}
					
					break;
				}
			}
		}
	}
}
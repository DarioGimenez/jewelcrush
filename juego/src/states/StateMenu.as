package states
{
	import allData.GameData;
	import allData.SoundController;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import org.j2dm.core.J2DM_AbstractState;
	import org.j2dm.core.J2DM_AbstractStateParameters;
	import org.j2dm.display.ui.components.J2DM_GenericButton;
	import org.j2dm.display.ui.components.J2DM_GenericButtonWithText;
	import org.j2dm.display.ui.components.J2DM_GenericCheckBox;
	import org.j2dm.stage.J2DM_Stage;
	import org.j2dm.stage.J2DM_StageLayerTypes;
	
	public class StateMenu extends J2DM_AbstractState
	{
		private var _container:Sprite;
		private var _btnEndlessMode:J2DM_GenericButtonWithText;
		private var _btnMusic:J2DM_GenericCheckBox;
		private var _btnSound:J2DM_GenericCheckBox;
		
		public function StateMenu(params:J2DM_AbstractStateParameters)
		{
			super(params);
		}
		
		public override function destroy():void
		{
			super.destroy();
			
			J2DM_Stage.getInstance().removeElement(_container, J2DM_StageLayerTypes.INTERFACE);
			
			_btnEndlessMode.destroy(); 
			_btnMusic.destroy();
			_btnSound.destroy();
		}
		
		protected override function create():void
		{
			_container = new Sprite();
			
			var bg:MovieClip = new A_MenuBackground();
			_container.addChild(bg);
			
			var logo:MovieClip = new A_Logo();
			logo.x = (J2DM_Stage.getInstance().realStage.stageWidth / 2);
			logo.y = (J2DM_Stage.getInstance().realStage.stageWidth / 3);
			_container.addChild(logo);
			
			var clip:MovieClip;
			
			//endless
			clip = new A_GenericButton();
			clip.x = (J2DM_Stage.getInstance().realStage.stageWidth / 2) - (clip.width / 2);
			clip.y = (J2DM_Stage.getInstance().realStage.stageWidth / 3) * 3;
			_container.addChild(clip);
			_btnEndlessMode = new J2DM_GenericButtonWithText("endless", clip, "PLAY", buttonCallback);
			
			//music
			clip = new A_MusicButton();
			clip.x = 10;
			clip.y = 10;
			_container.addChild(clip);
			_btnMusic = new J2DM_GenericCheckBox("music", clip, "y", buttonCallback);
			_btnMusic.checked = SoundController.instance.musicActive;
			
			//sound
			clip = new A_SoundButton();
			clip.x = _btnMusic.source.x + _btnMusic.source.width + 10;
			clip.y = 10;
			_container.addChild(clip);
			_btnSound = new J2DM_GenericCheckBox("sound", clip, "y", buttonCallback);
			_btnSound.checked = SoundController.instance.soundFxActive;
			
			SoundController.instance.playMusic(SoundController.MUSIC_MENU);
			
			J2DM_Stage.getInstance().addElement(_container, J2DM_StageLayerTypes.INTERFACE, true);
		}
		
		
		private function buttonCallback(type:String, button:J2DM_GenericButton):void
		{
			switch(type)
			{
				case MouseEvent.MOUSE_DOWN:
					switch(button)
					{
						case _btnEndlessMode:
							_gameLoop.changeState(StateSelectLevel);
							
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
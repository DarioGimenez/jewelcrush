package states
{
	import allData.GameData;
	
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
		private var _btnSound:J2DM_GenericCheckBox;
		
		private var _music:Sound;
		private var _musicChannel:SoundChannel;
		
		public function StateMenu(params:J2DM_AbstractStateParameters)
		{
			super(params);
		}
		
		public override function destroy():void
		{
			super.destroy();
			
			J2DM_Stage.getInstance().removeElement(_container, J2DM_StageLayerTypes.INTERFACE);
			
			_btnEndlessMode.destroy(); 
			_btnSound.destroy();
			
			stopMusic();
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

			//sound
			clip = new A_SoundButton();
			clip.x = 10;
			clip.y = 10;
			_container.addChild(clip);
			_btnSound = new J2DM_GenericCheckBox("sound", clip, "y", buttonCallback);
			_btnSound.checked = GameData.instance.musicActive;
			
			playMusic();
			
			J2DM_Stage.getInstance().addElement(_container, J2DM_StageLayerTypes.INTERFACE, true);
		}
		
		
		private function playMusic():void
		{
			if(!GameData.instance.musicActive)
			{
				return;
			}
			
			_music = new A_MenuMusic();
			_musicChannel = _music.play(0, 99);
		}
		
		private function stopMusic():void
		{
			if(_music == null)
			{
				return;
			}
			
			_musicChannel.stop();
			_music = null;
			_musicChannel = null;
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
						case _btnSound:
							GameData.instance.musicActive = _btnSound.checked;
							if(GameData.instance.musicActive)
							{
								playMusic();
							}else
							{
								stopMusic();
							}
							
							
							break;
					}
					
					
					break;
			}
		}
	}
}
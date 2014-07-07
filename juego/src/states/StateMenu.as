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
		private var _btnClassicMode:J2DM_GenericButtonWithText;
		private var _btnColorMode:J2DM_GenericButtonWithText;
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
			
			_btnClassicMode.destroy();
			_btnColorMode.destroy();
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
			
			//endless
			clip = new A_GenericButton();
			clip.x = (J2DM_Stage.getInstance().realStage.stageWidth / 2) - (clip.width / 2);
			clip.y = (J2DM_Stage.getInstance().realStage.stageWidth / 3) * 3;
			_container.addChild(clip);
			_btnEndlessMode = new J2DM_GenericButtonWithText("endless", clip, "ENDLESS", buttonCallback);

			//classic
			var clip:MovieClip = new A_GenericButton();
			clip.x = _btnEndlessMode.source.x
			clip.y = _btnEndlessMode.source.y + clip.height + 10;
			_container.addChild(clip);
			_btnClassicMode = new J2DM_GenericButtonWithText("classic", clip, "CLASSIC", buttonCallback);
			_btnClassicMode.hide();
			
			//color
			clip = new A_GenericButton();
			clip.x = _btnClassicMode.source.x
			clip.y = _btnClassicMode.source.y + clip.height + 10;
			_container.addChild(clip);
			_btnColorMode = new J2DM_GenericButtonWithText("color", clip, "COLOR", buttonCallback);
			_btnColorMode.hide();
			
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
						case _btnClassicMode:
							GameData.instance.gameMode = GameData.GAME_MODE_CLASSIC;
							_gameLoop.changeState(StateSelectLevel);
							
							break;
						case _btnColorMode:
							GameData.instance.gameMode = GameData.GAME_MODE_COLOR;
							_gameLoop.changeState(StateSelectLevel);
							
							break;
						case _btnEndlessMode:
							GameData.instance.gameMode = GameData.GAME_MODE_ENDLESS;
							_gameLoop.changeState(StateGame);
							
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
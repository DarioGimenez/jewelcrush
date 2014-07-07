package states
{
	import allData.GameData;
	import allData.Level;
	import allData.Levels;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextDisplayMode;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import org.j2dm.core.J2DM_AbstractState;
	import org.j2dm.core.J2DM_AbstractStateParameters;
	import org.j2dm.display.ui.components.J2DM_GenericButton;
	import org.j2dm.display.ui.components.J2DM_GenericButtonWithText;
	import org.j2dm.stage.J2DM_Stage;
	import org.j2dm.stage.J2DM_StageLayerTypes;
	
	import ui.GenericTextfield;
	
	public class StateSelectLevel extends J2DM_AbstractState
	{
		public static const MAX_BUTTONS:int = 5;
		public static const BUTTON_POS_OFFSET:int = 10;
		
		private var _container:Sprite;
		private var _btnBack:J2DM_GenericButtonWithText;
		private var _buttons:Vector.<J2DM_GenericButtonWithText>;
		
		private var _music:Sound;
		private var _musicChannel:SoundChannel;
		
		public function StateSelectLevel(params:J2DM_AbstractStateParameters)
		{
			super(params);
		}
		
		public override function destroy():void
		{
			super.destroy();
			
			J2DM_Stage.getInstance().removeElement(_container, J2DM_StageLayerTypes.INTERFACE);
			
			stopMusic();
			
			_btnBack.destroy();
			
			for each(var button:J2DM_GenericButtonWithText in _buttons)
			{
				button.destroy();
			}
			
			_buttons.length = 0;
		}
		
		protected override function create():void
		{
			buildScreen();
		}
		
		private function buildScreen():void
		{
			_container = new Sprite();
			
			_buttons = new Vector.<J2DM_GenericButtonWithText>();
			
			var bg:MovieClip = new A_MenuBackground();
			_container.addChild(bg);
			
			//level buttons
			var containerLevels:Sprite = new Sprite();
			var clip:MovieClip;
			var btn:J2DM_GenericButtonWithText;
			var yy:int = 0;
			var xx:int = 0;
			for(var i:int = 0; i < GameData.instance.geGameModeLevels().length; i++)
			{
				yy = i / MAX_BUTTONS;
				
				clip = new A_LevelButton();
				clip.x = xx * clip.width + (xx * BUTTON_POS_OFFSET);
				clip. y = yy * clip.height + (yy * BUTTON_POS_OFFSET);
				
				containerLevels.addChild(clip);
				
				btn = new J2DM_GenericButtonWithText("btn_" + i, clip, String(i + 1), buttonCallback);
				_buttons.push(btn);
				
				xx++;
				if(xx >= MAX_BUTTONS)
				{
					xx = 0;
				}
			}
			
			containerLevels.x = J2DM_Stage.getInstance().realStage.stageWidth / 2 - containerLevels.width / 2;
			containerLevels.y = 100;
			_container.addChild(containerLevels);
			
			//button 
			var btnSource:MovieClip = new A_GenericButton();
			btnSource.scaleX = 0.75;
			btnSource.scaleY = 0.75;
			btnSource.x = containerLevels.x;
			btnSource.y = containerLevels.y - btnSource.height - 10;
			_btnBack = new J2DM_GenericButtonWithText("back", btnSource, "Back", buttonCallback);
			_container.addChild(btnSource);
			
			//tf
			var tfGameMode:GenericTextfield = new GenericTextfield(new A_Font1().fontName, 0xFFFFFF, TextAlign.RIGHT, 40);
			switch(GameData.instance.gameMode)
			{
				case GameData.GAME_MODE_CLASSIC:
					tfGameMode.text = "CLASSIC MODE";
					
					break;
				case GameData.GAME_MODE_COLOR:
					tfGameMode.text = "COLOR MODE";
					
					break;
			}
			tfGameMode.x = containerLevels.x + containerLevels.width - tfGameMode.width;
			tfGameMode.y = _btnBack.source.y + 10;
			
			_container.addChild(tfGameMode);
			
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
						case _btnBack:
							_gameLoop.changeState(StateMenu);
							
							break;
						default:
							var lvl:int = button.id.split("_")[1];
							GameData.instance.currentLevel = lvl;
							_gameLoop.changeState(StateGame);
							
							break;
					}
					
					break;
			}
			
		}
	
	}
}
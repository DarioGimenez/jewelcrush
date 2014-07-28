package allData
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	
	public class SoundController
	{
		/**
		 * 
		 * SINGLETON 
		 * 
		 **/
		
		private static var _instance:SoundController;
		
		public function SoundController()
		{
			_collection = new Dictionary();
			_collection[MUSIC_MENU] = new A_MenuMusic();
			_collection[MUSIC_GAME] = new A_GameMusic();
			_collection[FX_HIT_CELL] = new A_HitCellFx();
			_collection[FX_RELEASE_BALL] = new A_ReleaseBallFx();
			
			musicActive = true;
			soundFxActive = true;
		}
		
		public static function get instance():SoundController
		{
			if(_instance == null)
			{
				_instance = new SoundController();
			}
			
			return _instance;
		}
		
		/**
		 * 
		 * CLASS
		 * 
		 **/
		
		public static const MUSIC_MENU:String = "music_menu";
		public static const MUSIC_GAME:String = "music_game";
		public static const FX_HIT_CELL:String = "fx_hit_cell";
		public static const FX_RELEASE_BALL:String = "fx_release_ball";
		
		private var _collection:Dictionary;
		
		private var _musicActive:Boolean;
		private var _soundFxActive:Boolean;
		
		private var _currentMusic:Sound;
		private var _currentMusicType:String;
		private var _currentChannel:SoundChannel;
		private var _currentSoundFx:Sound;
		
		public function set musicActive(value:Boolean):void
		{
			_musicActive = value;
			if(!_musicActive)
			{
				stopMusic();
			}else
			{
				playMusic(_currentMusicType);
			}
		}
		
		public function get musicActive():Boolean
		{
			return _musicActive;
		}
		
		public function set soundFxActive(value:Boolean):void
		{
			_soundFxActive = value;
		}
		
		public function get soundFxActive():Boolean
		{
			return _soundFxActive;
		}
		
		public function playMusic(music:String):void
		{
			if(!_musicActive || _collection[music] == null || (music == _currentMusicType && _currentChannel != null))
			{
				return;
			}
			
			stopMusic();
			
			_currentMusicType = music;
			_currentMusic = _collection[_currentMusicType] as Sound;
			_currentChannel = _currentMusic.play(0, 999);
		}
		
		public function playSoundFx(sound:String):void
		{
			if(!_soundFxActive || _collection[sound] == null)
			{
				return;
			}
			
			_currentSoundFx = _collection[sound] as Sound;
			_currentSoundFx.play();
		}
		
		public function stopMusic():void
		{
			if(_currentChannel != null)
			{
				_currentChannel.stop();
				_currentChannel = null;
				_currentMusic = null;
			}
		}
	}
}
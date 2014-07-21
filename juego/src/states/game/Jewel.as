package states.game
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	
	import event.CustomEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import org.j2dm.core.ICommonBehaviour;
	import org.j2dm.core.J2DM_AbstractGameLoop;
	import org.j2dm.stage.J2DM_Stage;
	import org.j2dm.utils.J2DM_SpriteTools;
	import org.osmf.events.TimeEvent;
	
	public class Jewel extends Sprite implements ICommonBehaviour
	{
		public static const EVENT_CRASH_COMPLETE:String = "crash_complete";
		
		public static const TYPE_RED:String = "A_JewelRed";
		public static const TYPE_ORANGE:String = "A_JewelOrange";
		public static const TYPE_YELLOW:String = "A_JewelYellow";
		public static const TYPE_GREEN:String = "A_JewelGreen";
		public static const TYPE_BLUE:String = "A_JewelBlue";
		public static const TYPE_VIOLET:String = "A_JewelViolet";
		
		public static const TYPE_COUNT_DOWN:String = "A_JewelCountDown";
		public static const TYPE_ROCK:String = "A_JewelRock";
		public static const TYPE_VASE:String = "A_JewelVase";
		
		private static const COUNT_DOWN:int = 9000;
		
		private var _source:MovieClip;
		private var _jewelType:String;
		
		private var _animIn:TweenLite;
		private var _animOut:TweenLite;
		private var _jewelFx:TimelineLite;
		
		private var _timer:Timer;
		private var _tfText:TextField;
		private var _currentTimer:int;
		
		public function Jewel(type:String)
		{
			jewelType = type;
		}
		
		public function destroy():void
		{
			TweenLite.killTweensOf(this, false);
		}
		
		public function update():void
		{
			if(jewelType == TYPE_COUNT_DOWN)
			{
				if(_currentTimer <= 0)
				{
					jewelType = TYPE_ROCK;
					_tfText = null;
					
					return;
				}
				
				_currentTimer -= 1000/J2DM_Stage.getInstance().realStage.frameRate;
				_tfText.text = String(int(_currentTimer / 1000));
			}
		}
		
		public function set jewelType(type:String):void
		{
			_jewelType = type;
			
			if(_timer != null)
			{
				_timer.stop();
			}
			
			build();
		}
		
		public function get jewelType():String
		{
			return _jewelType;
		}
		
		public function crashJewel():void
		{
			if(jewelType == TYPE_VASE)
			{
				TweenLite.to(this, 0.5, { y:y + height, alpha:0, onComplete:crashComplete });	
			}else
			{
				TweenLite.to(this, 0.2, { scaleX:0, scaleY:0, alpha:0, onComplete:crashComplete });
			}
		}
		
		private function initCountDown():void
		{
			_currentTimer = COUNT_DOWN;
			
			_tfText = _source.getChildByName("tfText") as TextField;
			_tfText.text = String(_currentTimer);
		}
		
		private function crashComplete():void
		{
			var e:CustomEvent = new CustomEvent(EVENT_CRASH_COMPLETE);
			e.data = { jewel:this };
			
			dispatchEvent(e);
		}
		
		private function build():void
		{
			J2DM_SpriteTools.cleanChildsMovieclip(this);
			
			switch(_jewelType)
			{
				case TYPE_RED:
					_source = new A_JewelRed();
					
					break;
				case TYPE_BLUE:
					_source = new A_JewelBlue();
					
					break;
				case TYPE_GREEN:
					_source = new A_JewelGreen();
					
					break;
				case TYPE_VIOLET:
					_source = new A_JewelViolet();
					
					break;
				case TYPE_ORANGE:
					_source = new A_JewelOrange();
					
					break;
				case TYPE_YELLOW:
					_source = new A_JewelYellow();
					
					break;
				case TYPE_COUNT_DOWN:
					_source = new A_JewelCountDown();
					
					break;
				case TYPE_ROCK:
					_source = new A_JewelRock();
					
					break;
				case TYPE_VASE:
					_source = new A_JewelVase();
					
					break;

			}
			
			if(_source != null)
			{
				addChild(_source);
			}
			
			if(jewelType == TYPE_COUNT_DOWN)
			{
				initCountDown();
			}
		}
	}
}
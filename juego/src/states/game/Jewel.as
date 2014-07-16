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
	
	import org.j2dm.utils.J2DM_SpriteTools;
	
	public class Jewel extends Sprite
	{
		public static const EVENT_CRASH_COMPLETE:String = "crash_complete";
		
		public static const TYPE_RED:String = "A_JewelRed";
		public static const TYPE_ORANGE:String = "A_JewelOrange";
		public static const TYPE_YELLOW:String = "A_JewelYellow";
		public static const TYPE_GREEN:String = "A_JewelGreen";
		public static const TYPE_BLUE:String = "A_JewelBlue";
		public static const TYPE_VIOLET:String = "A_JewelViolet";
		
		private var _source:MovieClip;
		private var _jewelType:String;
		
		private var _animIn:TweenLite;
		private var _animOut:TweenLite;
		private var _jewelFx:TimelineLite;
		
		public function Jewel(type:String)
		{
			jewelType = type;
		}
		
		public function destroy():void
		{
			TweenLite.killTweensOf(this, false);
		}
		
		public function set jewelType(type:String):void
		{
			_jewelType = type;
			build();
		}
		
		public function get jewelType():String
		{
			return _jewelType;
		}
		
		public function crashJewel():void
		{
			TweenLite.to(this, 0.2, { scaleX:0, scaleY:0, alpha:0, onComplete:crashComplete });
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
			}
			
			if(_source != null)
			{
				addChild(_source);
			}
		}
		
	}
}
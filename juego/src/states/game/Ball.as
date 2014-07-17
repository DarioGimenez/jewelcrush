package states.game
{
	import event.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.j2dm.display.ui.components.J2DM_GenericButton;
	import org.j2dm.display.ui.components.J2DM_GenericDragButton;
	import org.j2dm.system.input.IMouseStage;
	import org.j2dm.system.input.J2DM_InputMouse;
	import org.j2dm.utils.J2DM_SpriteTools;
	
	public class Ball extends MovieClip implements IMouseStage
	{
		public static const EVENT_TRAIL_BALL:String = "trail_ball";
		public static const EVENT_RELEASE_BALL:String = "release_ball";
		
		public static const TYPE_LIGHTER:String = "A_BallLighter";
		public static const TYPE_CLASSIC:String = "A_BallClassic";
		public static const TYPE_HEAVY:String = "A_BallHeavy";
		public static const TYPE_RED:String = "A_BallRed";
		public static const TYPE_BLUE:String = "A_BallBlue";
		public static const TYPE_GREEN:String = "A_BallGreen";
		public static const TYPE_VIOLET:String = "A_BallViolet";
		public static const TYPE_ORANGE:String = "A_BallOrange";
		public static const TYPE_YELLOW:String = "A_BallYellow";
		
		public static const TYPE_BOMB:String = "A_BallBomb";
		public static const TYPE_LINE_CLEANER:String = "A_BallLineCleaner";
		public static const TYPE_COLOUR_CLEANER:String = "A_BallColourCleaner";
		public static const TYPE_CHANGE_TYPE:String = "A_BallChangeType";
		public static const TYPE_POINTER:String = "A_BallPointer";
		
		private var _ballType:String;

		private var _btnBall:J2DM_GenericDragButton;
		
		private var _pressed:Boolean;
		
		private var _initX:int;
		private var _initY:int;
		
		public function Ball(type:String, rect:Rectangle)
		{
			ballType = type; 
			
			_btnBall = new J2DM_GenericDragButton("ball", this, rect, buttonCallback);
			_btnBall.disabledAlpha = 1;
			
			J2DM_InputMouse.getInstance().suscribeStage(this);
		}
		
		public function destroy():void
		{
			_btnBall.destroy();
		}
		
		public function mouseDownStage(position:Point):void
		{
			
		}
		
		public function mouseUpStage(position:Point):void
		{
			if(!_pressed){
				return;
			}
			
			releaseBall();
		}
		
		public function set dragEnable(value:Boolean):void
		{
			_btnBall.enabled = value;
		}
		
		public function get dragEnable():Boolean
		{
			return _btnBall.enabled;
		}
		
		public function set ballType(type:String):void
		{
			J2DM_SpriteTools.cleanChildsMovieclip(this);
			
			var source:MovieClip;
			
			_ballType = type;
			switch(_ballType)
			{
				case TYPE_LIGHTER:
					source = new A_BallLighter();
					
					break;
				case TYPE_HEAVY:
					source = new A_BallHeavy();
					
					break;
				case TYPE_RED:
					source = new A_BallRed();
					
					break;
				case TYPE_BLUE:
					source = new A_BallBlue();
					
					break;
				case TYPE_GREEN:
					source = new A_BallGreen();
					
					break;
				case TYPE_VIOLET:
					source = new A_BallViolet();
					
					break;
				case TYPE_ORANGE:
					source = new A_BallOrange();
					
					break;
				case TYPE_YELLOW:
					source = new A_BallYellow();
					
					break;
				default:
					source = new A_BallClassic();
					
					break;
			}
			
			addChild(source);
		}
		
		public function get ballType():String
		{
			return _ballType;
		}
		
		public function set initialPos(pos:Point):void
		{
			_initX = pos.x;
			_initY = pos.y;
			
			x = _initX;
			y = _initY;
		}
		
		public function get initialPos():Point
		{
			return new Point(_initX, _initY);
		}
		
		public function reset():void
		{
			x = _initX;
			y = _initY;
			scaleX = 1;
			scaleY = 1;
		}
		
		private function updateBallTrail():void
		{
			dispatchEvent(new CustomEvent(EVENT_TRAIL_BALL));
		}
		
		private function releaseBall():void
		{
			dispatchEvent(new CustomEvent(EVENT_RELEASE_BALL));
			_pressed = false;
		}
		
		private function buttonCallback(type:String, button:J2DM_GenericButton):void
		{
			switch(type)
			{
				case J2DM_GenericDragButton.MOUSE_DRAG:
					updateBallTrail();
					
					break;
				case MouseEvent.MOUSE_DOWN:
					_pressed = true;
					
					break;
				case MouseEvent.MOUSE_UP:
					releaseBall();
					
					break;
			}
		}
	}
}
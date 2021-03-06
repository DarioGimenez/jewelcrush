package states
{
	import allData.GameData;
	import allData.Level;
	import allData.Levels;
	import allData.SoundController;
	
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	
	import event.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextDisplayMode;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import flashx.textLayout.formats.TextAlign;
	
	import org.j2dm.core.J2DM_AbstractState;
	import org.j2dm.core.J2DM_AbstractStateParameters;
	import org.j2dm.display.ui.components.J2DM_GenericButton;
	import org.j2dm.display.ui.components.J2DM_GenericButtonWithText;
	import org.j2dm.display.ui.components.J2DM_GenericCheckBoxWithText;
	import org.j2dm.media.J2DM_SoundMusic;
	import org.j2dm.stage.J2DM_Stage;
	import org.j2dm.stage.J2DM_StageLayerTypes;
	import org.j2dm.system.input.IMouseStage;
	import org.j2dm.system.input.J2DM_InputMouse;
	
	import states.game.Ball;
	import states.game.Board;
	import states.game.Jewel;
	import states.game.modes.AbstractGameModeController;
	import states.game.windows.WindowContinuePlaying;
	import states.game.windows.WindowPause;
	
	import ui.GenericTextfield;
	import ui.GenericWindow;
	
	public class StateGame extends J2DM_AbstractState implements IMouseStage
	{		
		public static const ACTION_TYPE_PAUSE:int = 0;
		public static const ACTION_TYPE_GAME_OVER:int = 1;
		public static const ACTION_TYPE_LEVEL_COMPLETE:int = 2;
		
		private var _source:MovieClip;
		private var _trailCanvas:Sprite;
		private var _jewelContainer:Sprite;
		private var _board:Board;
		private var _ball:Ball;
		
		private var _btnBoosterLineCleaner:J2DM_GenericCheckBoxWithText;
		private var _btnBoosterBomb:J2DM_GenericCheckBoxWithText;
		private var _btnBoosterColor:J2DM_GenericCheckBoxWithText;
		private var _btnBoosterChangeType:J2DM_GenericCheckBoxWithText;
		private var _btnBoosterPointer:J2DM_GenericCheckBoxWithText;
		
		private var _btnPause:J2DM_GenericButtonWithText;
		
		private var _ballFx:TimelineLite;
		private var _moveBallFx:TweenLite;
		private var _scaleBallFx:TweenLite;
		
		private var _timeBar:Sprite;
		
		private var _flyingScoreCont:MovieClip;
		private var _flyingScore:TextField;

		private var _tfScore:TextField;
		
		private var _tfQBalls:TextField;
		private var _currentBalls:int;
		
		private var _score:int;
		private var _leftTimer:int;
		private var _lastTimer:int;
		
		private var _window:GenericWindow;
		private var _pauseWindow:WindowPause;
		private var _continueWindow:WindowContinuePlaying;
		
		private var _isPlaying:Boolean;
		private var _currentLevel:Level;
		
		private var _actionType:int;
		private var _activePointer:Boolean;
		private var _pointer:MovieClip;
		
		private var _gameModeController:AbstractGameModeController;
		
		public function StateGame(params:J2DM_AbstractStateParameters)
		{
			super(params);
		}
		
		public override function destroy():void
		{
			J2DM_Stage.getInstance().removeElement(_source, J2DM_StageLayerTypes.INTERFACE);
			J2DM_InputMouse.getInstance().unsuscribeStage(this);
			
			_gameModeController.destroy();
			_gameModeController.removeEventListener(AbstractGameModeController.EVENT_LEVEL_COMPLETE, onGameControllerEvent);
			
			_board.removeEventListener(Board.EVENT_BOARD_IS_FULL, onBoardEvent);
			
			_ball.removeEventListener(Ball.EVENT_RELEASE_BALL, onBallEvents);
			_ball.removeEventListener(Ball.EVENT_TRAIL_BALL, onBallEvents);
			
			_continueWindow.destroy();
			_continueWindow.removeEventListener(WindowContinuePlaying.EVENT_WINDOW_PLAY, windowContinueEvent);
			_continueWindow.removeEventListener(WindowContinuePlaying.EVENT_WINDOW_CANCEL, windowContinueEvent);
			
			_pauseWindow.removeEventListener(WindowPause.EVENT_WINDOW_CONTINUE, windowPauseEvent);
			_pauseWindow.removeEventListener(WindowPause.EVENT_WINDOW_QUIT, windowPauseEvent);
			_pauseWindow.destroy();
			
			_window.removeEventListener(GenericWindow.EVENT_WINDOW_ACTION, windowButtonEvent);
			_window.destroy();
			
			_ball.destroy();
			_board.destroy();
			
			if(_ballFx != null)_ballFx.kill();
			if(_moveBallFx != null)_moveBallFx.kill();
			if(_scaleBallFx != null)_scaleBallFx.kill();
			
			_btnBoosterBomb.destroy();
			_btnBoosterChangeType.destroy();
			_btnBoosterColor.destroy();
			_btnBoosterLineCleaner.destroy();
			_btnBoosterPointer.destroy();
			_btnPause.destroy();
			
			TweenLite.killDelayedCallsTo(gameOver);
			TweenLite.killDelayedCallsTo(levelComplete);
		}
		
		public override function update():void
		{
			if(!_isPlaying)
			{
				return;
			}	
			
			if(_currentLevel.gameMode != Level.GAME_MODE_QUEST)
			{
				//timer
				_leftTimer -= getTimer() - _lastTimer;
				_lastTimer = getTimer();
				
				_timeBar.scaleX = (_leftTimer * 100 / _currentLevel.newLineTimer) / 100;
				
				if(_leftTimer <= 0)
				{
					_leftTimer = _currentLevel.newLineTimer;
					addlines();
				}				
			}
			
			_board.update();
		}
		
		public function mouseDownStage(position:Point):void
		{
			if(!_board)
			{
				return;
			}
			
			//_board.hitCell(position);
		}
		
		public function mouseUpStage(position:Point):void
		{
			
		}
		
		protected override function create():void
		{
			buildScreen();
			init();
			
			J2DM_InputMouse.getInstance().suscribeStage(this);
		}
		
		private function buildScreen():void
		{
			_source = new A_ScreenGame();
			J2DM_Stage.getInstance().addElement(_source, J2DM_StageLayerTypes.INTERFACE, true);

			//current level
			_currentLevel = GameData.instance.getCurrentLevel();
			
			var frame:MovieClip = _source.getChildByName("mcFrame") as MovieClip;
			
			_jewelContainer = new Sprite();
			_jewelContainer.x = frame.x;
			_jewelContainer.y = frame.y;
			_source.addChild(_jewelContainer);
			
			_board = new Board(_jewelContainer, _currentLevel);
			_board.addEventListener(Board.EVENT_BOARD_IS_FULL, onBoardEvent);
			_board.addEventListener(Board.EVENT_UPDATE_SCORE, onBoardEvent);
			_board.addEventListener(Board.EVENT_BOARD_READY, onBoardEvent);
			
			var rect:Rectangle = new Rectangle(frame.x + 10, frame.y + frame.height + 50, frame.width - 10, 200);
			var ballx:int = frame.width / 2 + frame.x;
			var bally:int = frame.y + frame.height + 50;
			_ball = new Ball(Ball.TYPE_CLASSIC, rect);
			_ball.addEventListener(Ball.EVENT_TRAIL_BALL, onBallEvents);
			_ball.addEventListener(Ball.EVENT_RELEASE_BALL, onBallEvents);
			_ball.initialPos = new Point(ballx, bally);
			_source.addChild(_ball);
			
			_trailCanvas = new Sprite();
			_source.addChild(_trailCanvas);
			
			var timeBarBg:MovieClip= _source.getChildByName("mcTimeBar") as MovieClip;
			_timeBar = timeBarBg.getChildByName("mcTimeBar") as MovieClip;
			if(_currentLevel.gameMode == Level.GAME_MODE_QUEST)
			{
				_timeBar.visible = false;
				timeBarBg.visible = false;
			}
			
			//game mode controller
			var gameModeContainer:Sprite = new Sprite();
			gameModeContainer.x = 5;
			gameModeContainer.y = 100;
			_source.addChild(gameModeContainer);
			
			_gameModeController = AbstractGameModeController.getGameModeController(_currentLevel.gameMode);
			_gameModeController.init(gameModeContainer, _currentLevel.levelConfig);
			_gameModeController.addEventListener(AbstractGameModeController.EVENT_LEVEL_COMPLETE, onGameControllerEvent);
			
			//score tf
			_tfScore = _source.getChildByName("tfScore") as TextField;
			
			//Q balls
			_currentBalls = _currentLevel.maxBalls;
			_tfQBalls = _source.getChildByName("tfQBalls") as TextField;
			_tfQBalls.visible = _currentLevel.gameMode == Level.GAME_MODE_QUEST;
			_tfQBalls.text = String(_currentBalls);
			_tfQBalls.mouseEnabled = false;
			_tfQBalls.x = _ball.initialPos.x + 30;
			_tfQBalls.y = _ball.initialPos.y + 30;
			
			//flying score
			_flyingScoreCont = _source.getChildByName("mcFlyingScore") as MovieClip;
			_flyingScore = _flyingScoreCont.getChildByName("tfFlyingScore") as TextField;
			_flyingScoreCont.alpha = 0;
			_flyingScoreCont.mouseEnabled = false;
			_flyingScoreCont.mouseChildren = false;
			
			//buttons
			var clip:MovieClip;
			
			//pause
			clip = _source.getChildByName("btnPause") as MovieClip;
			_btnPause = new J2DM_GenericButtonWithText("pause", clip, "||", pauseButtonEvent);
			
			//booster line cleaner
			clip = _source.getChildByName("btnBoosterLineCleaner") as MovieClip;
			_btnBoosterLineCleaner = new J2DM_GenericCheckBoxWithText("bLineCleaner", clip, "1", "", boosterCallback);
			_btnBoosterLineCleaner.disabledAlpha = 1;
			
			//booster bomb
			clip = _source.getChildByName("btnBoosterBomb") as MovieClip;
			_btnBoosterBomb = new J2DM_GenericCheckBoxWithText("bbomb", clip, "2", "", boosterCallback);
			_btnBoosterBomb.disabledAlpha = 1;
			
			//booster color
			clip = _source.getChildByName("btnBoosterColorCleaner") as MovieClip;
			_btnBoosterColor = new J2DM_GenericCheckBoxWithText("bcolor", clip, "3", "", boosterCallback);
			_btnBoosterColor.disabledAlpha = 1;
			
			//booster change type
			clip = _source.getChildByName("btnBoosterChangeType") as MovieClip;
			_btnBoosterChangeType = new J2DM_GenericCheckBoxWithText("btype", clip, "4", "", boosterCallback);
			_btnBoosterChangeType.disabledAlpha = 1;
			
			//booster pointer
			clip = _source.getChildByName("btnBoosterPointer") as MovieClip;
			_btnBoosterPointer = new J2DM_GenericCheckBoxWithText("bpointer", clip, "5", "", boosterCallback);
			_btnBoosterPointer.disabledAlpha = 1;
			
			//pointer
			_pointer = new A_Pointer();
			_pointer.visible = false;
			_source.addChild(_pointer);
			
			//window
			_window = new GenericWindow();
			_window.addEventListener(GenericWindow.EVENT_WINDOW_ACTION, windowButtonEvent);
			
			_continueWindow = new WindowContinuePlaying();
			_continueWindow.addEventListener(WindowContinuePlaying.EVENT_WINDOW_PLAY, windowContinueEvent);
			_continueWindow.addEventListener(WindowContinuePlaying.EVENT_WINDOW_CANCEL, windowContinueEvent);
			
			_pauseWindow = new WindowPause();
			_pauseWindow.addEventListener(WindowPause.EVENT_WINDOW_CONTINUE, windowPauseEvent);
			_pauseWindow.addEventListener(WindowPause.EVENT_WINDOW_QUIT, windowPauseEvent);
			
			//music
			SoundController.instance.playMusic(SoundController.MUSIC_GAME);
			
			_source.setChildIndex(_ball, _source.numChildren - 2);
			_source.setChildIndex(_flyingScoreCont, _source.numChildren - 1);
		}
		
		private function createBar(w:int, h:int, color:int, alpha:Number):Sprite
		{
			var bar:Sprite = new Sprite();
			bar.graphics.lineStyle(0, 0, 0);
			bar.graphics.beginFill(color, alpha);
			bar.graphics.drawRect(0, 0, w, h);
			bar.graphics.endFill();
			
			return bar;
		}
		
		private function init():void
		{
			_lastTimer = getTimer();
			
			_ball.ballType = getRandomBallType();
			_leftTimer = _currentLevel.newLineTimer;
			
			_isPlaying = true;
		}
		
		private function getRandomBallType():String
		{
			var colorBalls:Vector.<String> = _currentLevel.balls;
			var rnd:int = Math.random() * colorBalls.length;
			var chance:int = Math.random() * 100;
			if(chance <= GameData.instance.getCurrentLevel().chanceColorBall)
			{
				return colorBalls[rnd];
			}
			
			var weightBalls:Array = new Array(Ball.TYPE_CLASSIC, Ball.TYPE_HEAVY, Ball.TYPE_LIGHTER);
			rnd = Math.random() * weightBalls.length;
			chance = Math.random() * 100;
			if(chance <= GameData.instance.getCurrentLevel().chanceWeightBall)
			{
				return weightBalls[rnd];
			}
			
			return Ball.TYPE_CLASSIC;
		}
		
		private function addlines():void
		{
			_board.addNewLines(1);
		}
		
		private function trailBall():void
		{
			_trailCanvas.graphics.clear();
			_trailCanvas.graphics.moveTo(_ball.initialPos.x, (_ball.initialPos.y - 50));
			_trailCanvas.graphics.lineStyle(2);
			_trailCanvas.graphics.lineTo(_ball.x, _ball.y);
			
			updatePointer();
		}
		
		private function updatePointer():void
		{
			_pointer.visible = _activePointer;
			
			var data:Object = getFinalPosition();
			_pointer.x = _ball.initialPos.x + data.offsetX;
			_pointer.y = _ball.initialPos.y - data.offsetY;
		}
		
		private function releaseBall():void
		{
			_pointer.visible = false;
			_trailCanvas.graphics.clear();
			
			var data:Object = getFinalPosition();
			
			_moveBallFx = new TweenLite(_ball, data.time, { x:_ball.initialPos.x + data.offsetX, y:_ball.initialPos.y - data.offsetY, onComplete:ballHitCell } );
			_scaleBallFx = new TweenLite(_ball, data.time/2, { scaleX:2, scaleY:2, onComplete:function():void{ _scaleBallFx.reverse(); } })
			
			_ballFx = new TimelineLite();
			_ballFx.insertMultiple([_moveBallFx, _scaleBallFx], 0);
			
			_ball.dragEnable = false;
			
			if(_currentLevel.gameMode == Level.GAME_MODE_QUEST)
			{
				_currentBalls--;
				_tfQBalls.text = String(_currentBalls);	
			}
			
			SoundController.instance.playSoundFx(SoundController.FX_RELEASE_BALL);
			
		}
		private function getFinalPosition():Object
		{
			var offsetX:int = (_ball.x - _ball.initialPos.x) * -1;
			if(_ball.ballType == Ball.TYPE_HEAVY)
			{
				offsetX *= 0.5;
			}
			if(_ball.ballType == Ball.TYPE_LIGHTER)
			{
				offsetX *= 1.5;
			}
			
			var offsetY:int = (_ball.y - _ball.initialPos.y) * 2;
			if(_ball.ballType == Ball.TYPE_HEAVY)
			{
				offsetY *= 0.5;
			}
			if(_ball.ballType == Ball.TYPE_LIGHTER)
			{
				offsetY *= 1.5;
			}
			if((_ball.initialPos.y - offsetY) >= _ball.initialPos.y - 60){
				offsetY = 60;
			}
			
			var time:Number = 1;
			if(_ball.ballType == Ball.TYPE_HEAVY)
			{
				time *= 1.25;
			}
			if(_ball.ballType == Ball.TYPE_LIGHTER)
			{
				time *= 0.75;
			}
			
			var data:Object = new Object();
			data.offsetX = offsetX;
			data.offsetY = offsetY;
			data.time = time;
			
			return data;
		}
		
		private function showFlyingScore(score:int):void
		{
			if(score > 0)
			{
				_flyingScore.text = String(score);
				_flyingScore.x = -_flyingScore.width / 2;
				_flyingScore.y = -_flyingScore.height / 2;
				
				_flyingScoreCont.x = _ball.x;
				_flyingScoreCont.y = _ball.y;
				
				TweenLite.killTweensOf(_flyingScoreCont, false);
				
				_flyingScoreCont.scaleX = 0;
				_flyingScoreCont.scaleY = 0;
				_flyingScoreCont.alpha = 0;
				TweenLite.to(_flyingScoreCont, 0.5, { scaleX:1, scaleY:1, alpha:1, onComplete:function():void{
					TweenLite.to(_flyingScoreCont, 0.25, { scaleX:2, scaleY:2, alpha:0 });
				} });
			}
		}
		
		private function ballHitCell():void
		{
			var hitPoint:Point = new Point(_ball.x, _ball.y);
			_board.hitCell(hitPoint, _ball.ballType);
			
			
			_ball.reset();
			_ball.ballType = getRandomBallType();
			
			if(_currentLevel.gameMode == Level.GAME_MODE_QUEST)
			{
				_ball.dragEnable = _currentBalls > 0;
			}else
			{
				_ball.dragEnable = true;
			}
				
			
			_ballFx.kill();
			_moveBallFx.kill();
			_scaleBallFx.kill();
			
			resetBoosters();
		}
		
		private function levelComplete():void
		{
			_isPlaying = false;
			
			_actionType = ACTION_TYPE_LEVEL_COMPLETE;
			_window.setText("Level\nComplete");
			_window.setButtonText("Next");
			_window.show();
		}
		
		private function gameOver():void
		{
			_isPlaying = false;
			_continueWindow.show();
		}
		
		private function boardRady():void
		{
			if(!_isPlaying)
			{
				return;
			}
			
			if(_currentBalls == 0)
			{
				gameOver();
			}
		}	
		
		
		private function pauseGame():void
		{
			_isPlaying = false;
			_pauseWindow.show();
		}
		
		private function continueGame():void
		{
			_isPlaying = true;
			_lastTimer = getTimer();
		}
		
		private function continuePlaying():void
		{
			continueGame();
			
			switch(_currentLevel.gameMode)
			{
				case Level.GAME_MODE_CLASSIC:
				case Level.GAME_MODE_BOSS:
					_board.clearLinesFromTop(5);
					
					break;
				case Level.GAME_MODE_QUEST:
					_currentBalls = 5;
					_tfQBalls.text = String(_currentBalls);
					_ball.dragEnable = true;
					
					break;
			}
		}
		
		private function activateBooster(type:String):void
		{
			disableBoosters();
			
			switch(type)
			{
				case Ball.TYPE_LINE_CLEANER:
				case Ball.TYPE_BOMB:
				case Ball.TYPE_COLOUR_CLEANER:
				case Ball.TYPE_CHANGE_TYPE:
					_ball.ballType = type;
					
					break;
				case Ball.TYPE_POINTER:
					_activePointer = true;
					
					break;
			}
		}
		
		private function disableBoosters():void
		{
			_btnBoosterLineCleaner.enabled = false;
			_btnBoosterBomb.enabled = false;
			_btnBoosterColor.enabled = false;
			_btnBoosterChangeType.enabled = false;
			_btnBoosterPointer.enabled = false;
		}
		
		private function resetBoosters():void
		{
			_btnBoosterLineCleaner.enabled = true;
			_btnBoosterLineCleaner.checked = false;
			
			_btnBoosterBomb.enabled = true;
			_btnBoosterBomb.checked = false;
			
			_btnBoosterColor.enabled = true;
			_btnBoosterColor.checked = false;
			
			_btnBoosterChangeType.enabled = true;
			_btnBoosterChangeType.checked = false;
			
			_btnBoosterPointer.enabled = true;
			_btnBoosterPointer.checked = false;
			
			_activePointer = false;
		}
		
		private function onGameControllerEvent(e:CustomEvent):void
		{
			levelComplete();
		}
		
		private function windowContinueEvent(e:CustomEvent):void
		{
			switch(e.type)
			{
				case WindowContinuePlaying.EVENT_WINDOW_PLAY:
					continuePlaying();
					
					break;
				case WindowContinuePlaying.EVENT_WINDOW_CANCEL:
					_gameLoop.changeState(StateMenu);
					
					break;
			}
		}
		
		private function windowPauseEvent(e:CustomEvent):void
		{
			switch(e.type)
			{
				case WindowPause.EVENT_WINDOW_CONTINUE:
					continueGame();
					
					break;
				case WindowPause.EVENT_WINDOW_QUIT:
					_gameLoop.changeState(StateMenu);
					
					break;
			}
		}
		
		private function windowButtonEvent(event:Event):void
		{
			switch(_actionType)
			{
				case ACTION_TYPE_GAME_OVER:
					_gameLoop.changeState(StateMenu);
					
					break;
				case ACTION_TYPE_LEVEL_COMPLETE:
					_gameLoop.changeState(StateMenu);
					
					break;
			}
			
		}
		
		private function onBoardEvent(e:CustomEvent):void
		{
			switch(e.type)
			{
				case Board.EVENT_BOARD_IS_FULL:
					gameOver();
					
					break;
				case Board.EVENT_UPDATE_SCORE:
					_score = e.data.score;
					_tfScore.text = String(_score);
					
					if(_ball.ballType != Ball.TYPE_BOMB && _ball.ballType != Ball.TYPE_LINE_CLEANER)
					{
						_gameModeController.addJewels(e.data.q, e.data.jewelType);
						showFlyingScore(e.data.lastScore);
					}
					
					break;
				case Board.EVENT_BOARD_READY:
					boardRady();
					
					break;
			}
			
		}
		
		private function onBallEvents(e:Event):void
		{
			switch(e.type)
			{
				case Ball.EVENT_TRAIL_BALL:
					trailBall();
					
					break;
				
				case Ball.EVENT_RELEASE_BALL:
					releaseBall();
					
					break;
			}
		}
			
		private function pauseButtonEvent(type:String, button:J2DM_GenericButton):void
		{
			switch(type)
			{
				case MouseEvent.MOUSE_DOWN:
					switch(button)
					{
						case _btnPause:
							pauseGame();
							
							break;
					}
					
					
					break;
			}
		}
		
		private function boosterCallback(type:String, button:J2DM_GenericButton):void
		{
			switch(type)
			{
				case MouseEvent.MOUSE_DOWN:
					switch(button)
					{
						case _btnBoosterLineCleaner:
							activateBooster(Ball.TYPE_LINE_CLEANER);
							
							break;
						case _btnBoosterBomb:
							activateBooster(Ball.TYPE_BOMB);
							
							break;
						case _btnBoosterColor:
							activateBooster(Ball.TYPE_COLOUR_CLEANER);
							
							break;
						case _btnBoosterChangeType:
							activateBooster(Ball.TYPE_CHANGE_TYPE);
							
							break;
						case _btnBoosterPointer:
							activateBooster(Ball.TYPE_POINTER);
							
							break;
					}
					
					break;
			}
		}
			
		
	}
}
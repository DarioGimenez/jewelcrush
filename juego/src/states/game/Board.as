package states.game
{
	import allData.GameData;
	import allData.Level;
	import allData.Levels;
	import allData.SoundController;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import event.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.media.Sound;
	
	import org.j2dm.core.ICommonBehaviour;
	
	import states.StateGame;

	public class Board extends EventDispatcher implements ICommonBehaviour
	{
		public static const EVENT_BOARD_IS_FULL:String = "board_is_full";
		public static const EVENT_UPDATE_SCORE:String = "update_score";
		public static const EVENT_BOARD_READY:String = "board_ready";
		
		public static const BOARD_MAX_W:int = 9;
		public static const BOARD_MAX_H:int = 10;
		
		public static const BOARD_CELL_W:int = 50;
		public static const BOARD_CELL_H:int = 50;
		
		private var _container:Sprite;
		private var _currentLevel:Level;
		
		private var _cells:Vector.<Vector.<BoardCell>>;
		private var _selectedCells:Vector.<BoardCell>;
		
		private var _animateCount:int;
		
		private var _score:int;
		private var _lastScore:int;
		
		private var _catchVases:Boolean;
		
		public function Board(container:Sprite, currentLevel:Level)
		{
			_container = container;
			_currentLevel = currentLevel;
			build();
		}
		
		public function destroy():void
		{
			var jewel:Jewel;
			while(_container.numChildren > 0)
			{
				jewel = _container.getChildAt(0) as Jewel;
				jewel.destroy();
				_container.removeChildAt(0);
			}
			
			_cells.length = 0;
			_selectedCells.length = 0;
			
			TweenLite.killDelayedCallsTo(animateLines);
		}
		
		public function update():void
		{
			var row:Vector.<BoardCell>;
			var auxCell:BoardCell;
			var jewel:Jewel;
			for(var yy:int = 0; yy < _cells.length; yy++)
			{
				row = _cells[yy];
				for(var xx:int = 0; xx < row.length; xx++)
				{
					auxCell = row[xx];
					if(auxCell.jewel != null)
					{
						auxCell.jewel.update();
					}
				}
			}
		}
		
		public function addNewLines(linesY:int):void
		{
			if(_currentLevel.gameMode != Level.GAME_MODE_QUEST && boardIsFull())
			{
				dispatchEvent(new CustomEvent(EVENT_BOARD_IS_FULL));
				return;
			}
			
			var jewel:Jewel;
			var cell:BoardCell;
			for(var i:int = 0; i < linesY; i++)
			{
				for(var j:int = 0; j < BOARD_MAX_W; j++)
				{
					//creo y posiciono el item
					jewel = getRandomJewel();
					jewel.addEventListener(Jewel.EVENT_CRASH_COMPLETE, jewelCrashComplete);
					jewel.x = j * jewel.width + jewel.width / 2;
					jewel.y = i * jewel.height + jewel.height / 2;
					_container.addChild(jewel);
					
					//asigno el item a la celda
					cell = _cells[i][j]; 
					cell.jewel = jewel; 
				}
			}
			
			_animateCount = _cells.length;
			animateLines();
		}
		
		public function refillBoard():void
		{
			var row:Vector.<BoardCell>;
			var auxCell:BoardCell;
			var jewel:Jewel;
			for(var yy:int = 0; yy < _cells.length; yy++)
			{
				row = _cells[yy];
				for(var xx:int = 0; xx < row.length; xx++)
				{
					auxCell = row[xx];
					if(auxCell.jewel == null)
					{
						jewel = getRandomJewel(true);
						jewel.x = xx * jewel.width + jewel.width / 2;
						jewel.y = yy * jewel.height + jewel.height / 2; 
						_container.addChild(jewel);
						
						auxCell.jewel = jewel;
						
						
					}
				}
			}
		}
		
		private function checkVeses():void
		{
			_selectedCells.length = 0;
			
			var row:Vector.<BoardCell> = _cells[BOARD_MAX_H - 1];
			var cell:BoardCell;
			for(var i:int = 0; i < row.length; i++)
			{
				cell = row[i];
				if(cell.jewel != null && cell.jewel.jewelType == Jewel.TYPE_VASE)
				{
					_selectedCells.push(cell);
				}
			}
			
			if(_selectedCells.length > 0)
			{
				calcScoreVase();  
				
				var e:CustomEvent = new CustomEvent(EVENT_UPDATE_SCORE);
				e.data = { score:_score, lastScore:_lastScore, q:_selectedCells.length, jewelType:Jewel.TYPE_VASE };
				dispatchEvent(e);
				
				_catchVases = true;
				
				clearSelectedCells();
				TweenLite.delayedCall(0.2, animateLines);
			}else
			{
				_catchVases = false;	
			}
			
		}
		
		private function boardReady():void
		{
			var e:CustomEvent = new CustomEvent(EVENT_BOARD_READY);
			dispatchEvent(e);
		}
		
		public function clearLinesFromTop(q:int):void
		{
			var row:Vector.<BoardCell>;
			var cell:BoardCell;
			for(var yy:int = 0; yy < q; yy++)
			{
				row = _cells[yy];
				for(var xx:int = 0; xx < row.length; xx++)
				{
					cell = row[xx];
					if(cell.jewel != null)
					{
						_selectedCells.push(cell);
					}
				}
			}
			
			clearSelectedCells();
		}
		
		public function hitCell(hitPos:Point, ballType:String):void
		{
			var cellPos:Point = convertGlobalPosition(hitPos);
			var cell:BoardCell = getCell(cellPos);
			
			if(cell && cell.jewel && cell.jewel.jewelType == Jewel.TYPE_COUNT_DOWN && ballType != Ball.TYPE_BOMB)
			{
				changeCommonType(cell);
				SoundController.instance.playSoundFx(SoundController.FX_HIT_CELL);
				return;
			}
			
			if(!cell || !cell.jewel || !checkMachBallType(cell.jewel.jewelType, ballType))
			{
				_lastScore = 0;
				return;
			}
			
			if(cell.jewel.jewelType == Jewel.TYPE_ROCK && ballType != Ball.TYPE_BOMB)
			{
				_lastScore = 0;
				return;
			}
			
			_selectedCells.length = 0;
			
			if(checkBooster(ballType))
			{
				applyBooster(ballType, cell);
			}else
			{
				checkAdjacentCells(cell, cell.jewel.jewelType);
			}
			
			calcScore();
			
			if(cell.jewel.jewelType != Jewel.TYPE_VASE)
			{
				var e:CustomEvent = new CustomEvent(EVENT_UPDATE_SCORE);
				e.data = { score:_score, lastScore:_lastScore, q:_selectedCells.length, jewelType:cell.jewel.jewelType };
				dispatchEvent(e);				
			}
			
			clearSelectedCells();
			TweenLite.delayedCall(0.2, animateLines);
			
			SoundController.instance.playSoundFx(SoundController.FX_HIT_CELL);
		}
				
		private function build():void
		{
			_cells = new Vector.<Vector.<BoardCell>>();
			_selectedCells = new Vector.<BoardCell>();
			
			var cell:BoardCell;
			var row:Vector.<BoardCell>;
			for(var i:int = 0; i < BOARD_MAX_H; i++)
			{
				row = new Vector.<BoardCell>();
				
				for(var j:int = 0; j < BOARD_MAX_W; j++)
				{
					cell = new BoardCell();
					cell.posX = j;
					cell.posY = i;
					row.push(cell);
				}
				
				_cells.push(row);
			}
			
			_score = 0;
			_catchVases = false;
			
			if(_currentLevel.gameMode == Level.GAME_MODE_QUEST)
			{
				addNewLines(BOARD_MAX_H);
			}else
			{
				addNewLines(_currentLevel.initialLines);
			}
			
		}
		
		private function checkMachBallType(jewelType:String, ballType:String):Boolean
		{
			if(jewelType == Jewel.TYPE_VASE)
			{
				return true;
			}
			
			switch(ballType)
			{
				case Ball.TYPE_CLASSIC:
				case Ball.TYPE_LIGHTER:
				case Ball.TYPE_HEAVY:
				case Ball.TYPE_BOMB:
				case Ball.TYPE_COLOUR_CLEANER:
				case Ball.TYPE_LINE_CLEANER:
				case Ball.TYPE_CHANGE_TYPE:
					return true;
				case Ball.TYPE_RED:
					return  jewelType == Jewel.TYPE_RED;
				case Ball.TYPE_BLUE:
					return  jewelType == Jewel.TYPE_BLUE;
				case Ball.TYPE_GREEN:
					return  jewelType == Jewel.TYPE_GREEN;
				case Ball.TYPE_VIOLET:
					return  jewelType == Jewel.TYPE_VIOLET;
				case Ball.TYPE_ORANGE:
					return  jewelType == Jewel.TYPE_ORANGE;
				case Ball.TYPE_YELLOW:
					return  jewelType == Jewel.TYPE_YELLOW;
			}
			
			return false;
		}
		
		private function checkIfSelected(cell:BoardCell):Boolean
		{
			for(var i:int = 0; i < _selectedCells.length; i++)
			{
				if(_selectedCells[i] == cell)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function changeCommonType(cell:BoardCell):void
		{
			var auxJewel:Jewel = getRandomJewel();
			while(auxJewel.jewelType == Jewel.TYPE_COUNT_DOWN || auxJewel.jewelType == Jewel.TYPE_ROCK)
			{
				auxJewel = getRandomJewel();
			}
			cell.jewel.jewelType = auxJewel.jewelType;
		}
		
		private function checkBooster(ballType:String):Boolean
		{
			return (
				ballType == Ball.TYPE_BOMB || 
				ballType == Ball.TYPE_COLOUR_CLEANER ||
				ballType == Ball.TYPE_LINE_CLEANER ||
				ballType == Ball.TYPE_CHANGE_TYPE
			);
		}
		
		private function applyBooster(ballType:String, cell:BoardCell):void
		{
			switch(ballType)
			{
				case Ball.TYPE_LINE_CLEANER:
					applyBoosterLineCleaner(cell);
					
					break;
				case Ball.TYPE_BOMB:
					applyBoosterBomb(cell);
					
					break;
				case Ball.TYPE_COLOUR_CLEANER:
					applyBoosterColor(cell);
					
					break;
				case Ball.TYPE_CHANGE_TYPE:
					applyBoosterChangeType(cell);
					
					break;
			}
		}
		
		private function applyBoosterLineCleaner(cell:BoardCell):void
		{
			var row:Vector.<BoardCell> = _cells[cell.posY];
			var auxCell:BoardCell;
			for(var xx:int = 0; xx < row.length; xx++)
			{
				auxCell = row[xx];
				if(	auxCell.jewel && 
					auxCell.jewel.jewelType == Jewel.TYPE_COUNT_DOWN &&
					!checkIfSelected(auxCell))
				{
					changeCommonType(auxCell);
					continue;
				}
				
				if(	auxCell.jewel &&  
					auxCell.jewel.jewelType != Jewel.TYPE_ROCK && 
					!checkIfSelected(auxCell))
				{
					_selectedCells.push(auxCell);
				}
			}
		}
		
		private function applyBoosterBomb(cell:BoardCell):void
		{
			_selectedCells = getAdyacentCells(cell, 1);
		}
		
		private function applyBoosterColor(cell:BoardCell):void
		{
			var auxCells:Vector.<BoardCell> = new Vector.<BoardCell>();
			var row:Vector.<BoardCell>;
			var auxCell:BoardCell;
			for(var yy:int = 0; yy < _cells.length; yy++)
			{
				row = _cells[yy];
				for(var xx:int = 0; xx < row.length; xx++)
				{
					auxCell = row[xx];
					if(auxCell.jewel != null && auxCell.jewel.jewelType == cell.jewel.jewelType)
					{
						_selectedCells.push(auxCell);
					}
				}
			}
			
		}
		
		private function applyBoosterChangeType(cell:BoardCell):void
		{
			var auxCells:Vector.<BoardCell> = getAdyacentCells(cell, 1);
			for each(var auxCell:BoardCell in auxCells)
			{
				if(auxCell.jewel != null)
				{
					auxCell.jewel.jewelType = cell.jewel.jewelType;
				}
				
			}
		}
		
		private function getAdyacentCells(cell:BoardCell, level:int = 1):Vector.<BoardCell>
		{
			var auxY1:int = cell.posY - level;
			if(auxY1 < 0) auxY1 = 0;
			
			var auxY2:int = cell.posY + level;
			if(auxY2 > _cells.length - 1) auxY2 = _cells.length - 1;
			
			var auxX1:int = cell.posX - level;
			if(auxX1 < 0) auxX1 = 0;
			
			var auxX2:int = cell.posX + level;
			if(auxX2 > _cells[0].length - 1) auxX2 = _cells[0].length - 1;
			
			var cells:Vector.<BoardCell> = new Vector.<BoardCell>();
			var row:Vector.<BoardCell>;
			var auxCell:BoardCell;
			for(var yy:int = auxY1; yy <= auxY2; yy++)
			{
				row = _cells[yy];
				for(var xx:int = auxX1; xx <= auxX2; xx++)
				{
					auxCell = row[xx];
					if(auxCell.jewel != null)
					{
						cells.push(auxCell);
					}
				}
			}
			
			return cells;
		}
		
		private function checkAdjacentCells(cell:BoardCell, jewelType:String):void
		{
			if(!cell.jewel || cell.jewel.jewelType != jewelType || checkIfSelected(cell))
			{
				return;
			}
			
			_selectedCells.push(cell);
			
			if(jewelType == Jewel.TYPE_VASE)
			{
				return;
			}
			
			var nextCellPos:Point;
			var nextCell:BoardCell;
			//check up cell
			nextCellPos = new Point(cell.posX, cell.posY - 1);
			nextCell = getCell(nextCellPos);
			if(nextCell != null)
			{
				checkAdjacentCells(nextCell, jewelType);
			}
			
			//check down cell
			nextCellPos = new Point(cell.posX, cell.posY + 1);
			nextCell = getCell(nextCellPos);
			if(nextCell != null)
			{
				checkAdjacentCells(nextCell, jewelType);
			}
			
			//check right cell
			nextCellPos = new Point(cell.posX + 1, cell.posY);
			nextCell = getCell(nextCellPos);
			if(nextCell != null)
			{
				checkAdjacentCells(nextCell, jewelType);
			}
			
			//check left cell
			nextCellPos = new Point(cell.posX - 1, cell.posY);
			nextCell = getCell(nextCellPos);
			if(nextCell != null)
			{
				checkAdjacentCells(nextCell, jewelType);
			}
		}
		
		private function calcScore():void
		{
			_lastScore = Math.pow(GameData.GAME_SCORE_BASE, _selectedCells.length);
			_score += _lastScore;
		}
		
		private function calcScoreVase():void
		{
			_lastScore = Math.pow(GameData.GAME_SCORE_VASE, _selectedCells.length);
			_score += _lastScore;
		}
		
		private function clearSelectedCells():void
		{
			var cell:BoardCell;
			for(var i:int = 0; i < _selectedCells.length; i++)
			{
				cell = _selectedCells[i];
				cell.jewel.crashJewel();
				cell.jewel = null;
			}
		}
		
		private function removeJewel(jewel:Jewel):void
		{
			jewel.removeEventListener(Jewel.EVENT_CRASH_COMPLETE, jewelCrashComplete);
			_container.removeChild(jewel);
		}
		
		private function convertGlobalPosition(pos:Point):Point
		{
			var xx:int = _container.globalToLocal(pos).x / BOARD_CELL_W;
			var yy:int = _container.globalToLocal(pos).y / BOARD_CELL_H;
			
			var cellPos:Point = new Point(xx, yy);
			return cellPos;
		}
		
		private function getCell(cellPos:Point):BoardCell
		{
			if(! _cells)
			{
				_cells = new Vector.<Vector.<BoardCell>>();
			}
			
			if(cellPos.y >= 0 && _cells.length > cellPos.y && cellPos.x >= 0 && _cells[cellPos.y].length > cellPos.x)
			{
				return _cells[cellPos.y][cellPos.x];
			}else
			{
				return null;
			}
		}
		
		private function boardIsFull():Boolean
		{
			var firstLine:Vector.<BoardCell> = _cells[0];
			var cell:BoardCell;
			for(var i:int = 0; i < firstLine.length; i++)
			{
				cell = firstLine[i];
				if(cell.jewel != null)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function getRandomJewel(isRefill:Boolean = false):Jewel
		{
			var allJewels:Vector.<String> = _currentLevel.jewels;
			if(isRefill)
			{
				allJewels.push(Jewel.TYPE_VASE);
			}
			
			//countdown
			var prob:int = Math.random() * 100;
			if(prob <= _currentLevel.chanceCountDown && getCountJewelsByType(Jewel.TYPE_COUNT_DOWN) < GameData.MAX_COUNTDOWN_ONBOARD)
			{
				return new Jewel(Jewel.TYPE_COUNT_DOWN);
			}
			
			var rnd:int = Math.random() * allJewels.length;
			if(allJewels[rnd] == Jewel.TYPE_VASE && getCountJewelsByType(Jewel.TYPE_VASE) >= GameData.MAX_VASES_ONBOARD)
			{
				allJewels.pop();
				rnd = Math.random() * allJewels.length;
			}

			return new Jewel(allJewels[rnd]);
		}
		
		private function getCountJewelsByType(jewelType:String):int
		{
			var row:Vector.<BoardCell>;
			var auxCell:BoardCell;
			var q:int = 0;
			for(var yy:int = 0; yy < _cells.length; yy++)
			{
				row = _cells[yy];
				for(var xx:int = 0; xx < row.length; xx++)
				{
					auxCell = row[xx];
					if(auxCell.jewel != null && auxCell.jewel.jewelType == jewelType)
					{
						q++;
					}
				}
			}
			
			return q;
		}
		
		private function animateLines():void
		{
			var row:Vector.<BoardCell>;
			var cell:BoardCell;
			var bottomCell:BoardCell;
			for(var i:int = _cells.length - 1; i >= 0; i--)
			{
				//obtengo la celda y compruebo que tenga un item
				row = _cells[i];
				for(var j:int = row.length - 1; j >= 0; j--)
				{
					cell = row[j];
					if(cell.jewel != null)
					{
						//compruebo que haya una celda debajo
						if(i < BOARD_MAX_H - 1)
						{
							bottomCell = _cells[i + 1][j];
							
							//compruebo que no tenga un item
							if(bottomCell.jewel == null)
							{
								//sino tiene un item, le asigno el de la celda superior
								bottomCell.jewel = cell.jewel;
								cell.jewel = null;
								
								//animo el item hacia abajo
								var newY:int = (i + 1) * bottomCell.jewel.height + bottomCell.jewel.height / 2;
								TweenLite.to(bottomCell.jewel, 0.1,  {y:newY, ease:Linear.easeNone });
							}
						}
						
					}
				}
			}
			
			_animateCount--;
			
			if(_animateCount > 0)
			{
				TweenLite.delayedCall(0.1, animateLines);
			}else
			{
				_animateCount = BOARD_MAX_H;
				
				if(_currentLevel.gameMode == Level.GAME_MODE_QUEST)
				{
					checkVeses();
					if(!_catchVases)
					{
						refillBoard();
						_catchVases = false;
						
						boardReady();
					}
				}
			}
		}
		
		private function jewelCrashComplete(e:CustomEvent):void
		{
			removeJewel(e.data.jewel as Jewel);
		}

	}
}
package states.game.modes
{
	import allData.Level;
	
	import event.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import states.game.Jewel;
	
	public class GameModeBossController extends AbstractGameModeController
	{
		private var _currentGoal:String;
		private var _mcRect:MovieClip;
		
		public function GameModeBossController()
		{
			
		}
		
		public override function destroy():void
		{
			
		}
		
		public override function addJewels(q:int, type:String):void
		{
			if(_currentGoal != type)
			{
				return;
			}
			
			var module:GoalModule = getModuleByType(type);
			if(module == null)
			{
				return;
			}
			
			module.current += q;
			updateScore(type);
			
			if(module.current >= module.goal)
			{
				var ind:int = getModuleIndexByType(type);
				if(ind < _goals.length - 1)
				{
					_currentGoal = _goals[ind + 1].type;
				}
				
				updateCurrentGoal();
			}
			
			checkComeplete();
		}
		
		protected override function build():void
		{
			_goals = new Vector.<GoalModule>();
			
			//r:10,o:0,y:0,g:15,b:20,v:5
			var auxGoals:String = _levelConfig.@goal;
			var singleGoals:Array = auxGoals.split(",");
			var auxGoal:Array;
			var clip:MovieClip;
			var cant:int = 0;
			
			for(var i:int = 0; i < singleGoals.length; i++)
			{
				auxGoal = singleGoals[i].split(":");
				switch(auxGoal[0])
				{
					case "r":
						if(int(auxGoal[1]) > 0){
							createGoalModule(Jewel.TYPE_RED, auxGoal[1]);
						}
						
						break;
					case "o":
						if(int(auxGoal[1]) > 0){
							createGoalModule(Jewel.TYPE_ORANGE, auxGoal[1]);
						}
						
						break;
					case "y":
						if(int(auxGoal[1]) > 0){
							createGoalModule(Jewel.TYPE_YELLOW, auxGoal[1]);
						}
						
						break;
					case "g":
						if(int(auxGoal[1]) > 0){
							createGoalModule(Jewel.TYPE_GREEN, auxGoal[1]);
						}
						
						break;
					case "b":
						if(int(auxGoal[1]) > 0){
							createGoalModule(Jewel.TYPE_BLUE, auxGoal[1]);
						}
						
						break;
					case "v":
						if(int(auxGoal[1]) > 0){
							createGoalModule(Jewel.TYPE_VIOLET, auxGoal[1]);
						}
						break;
				}
			}
			
			if(_goals.length > 0)
			{
				_currentGoal = _goals[0].type;
			}
			
			_mcRect = new A_RowColorRect();
			_container.addChild(_mcRect);
			
			updateCurrentGoal();
		}
		
		protected override function createGoalModule(type:String, goal:int):void
		{
			var module:GoalModule = new GoalModule();
			module.type = type;
			
			var rowColor:MovieClip;
			switch(type)
			{
				case Jewel.TYPE_RED:
					rowColor = new A_RowRed();
					
					break;
				case Jewel.TYPE_BLUE:
					rowColor = new A_RowBlue();
					
					break;
				case Jewel.TYPE_GREEN:
					rowColor = new A_RowGreen();
					
					break;
				case Jewel.TYPE_VIOLET:
					rowColor = new A_RowViolet();
					
					break;
				case Jewel.TYPE_ORANGE:
					rowColor = new A_RowOrange();
					
					break;
				case Jewel.TYPE_YELLOW:
					rowColor = new A_RowYellow();
					
					break;
			}
			
			rowColor.y = rowColor.height * _goals.length;
			_container.addChild(rowColor);
			
			module.source = rowColor;
			
			//goal
			module.goal = goal;
			
			//current
			module.current = 0;
			
			//store
			_goals.push(module);
			
			//update
			updateScore(type);
			updateCurrentGoal();
		}
		
		protected override function getModuleByType(type:String):GoalModule
		{
			for(var i:int = 0; i < _goals.length; i++)
			{
				if(_goals[i].type == type)
				{
					return _goals[i];
				}
			}
			
			return null;
		}
		
		private function getModuleIndexByType(type:String):int
		{
			for(var i:int = 0; i < _goals.length; i++)
			{
				if(_goals[i].type == type)
				{
					return i;
				}
			}
			
			return -1;
		}
		
		private function updateCurrentGoal():void
		{
			for(var i:int = 0; i < _goals.length; i++)
			{
				if(_currentGoal == _goals[i].type)
				{
					_mcRect.y = _goals[i].source.y;
				}
			}
		}
		
		protected override function updateScore(type:String):void
		{
			var module:GoalModule = getModuleByType(type);
			var clip:MovieClip = module.source;
			var bg:MovieClip = clip.getChildByName("mcBg") as MovieClip;
			var current:int = module.current;
			var total:int = module.goal;
			
			var percent:Number = (current * 100 / total) / 100;
			if(percent > 1)
			{
				percent = 1;
			}
			bg.scaleX = percent;
			
			var tf:TextField = clip.getChildByName("tfText") as TextField;
			tf.text = current + "/" +total;
		}
		
		protected override function checkComeplete():void
		{
			var isComplete:Boolean = true;
			
			var module:GoalModule;
			for(var i:int = 0; i < _goals.length; i++)
			{
				module = _goals[i];
				if(module.current < module.goal)
				{
					isComplete = false;
				}
			}
			
			if(isComplete)
			{
				dispatchEvent(new CustomEvent(EVENT_LEVEL_COMPLETE));
			}
		}
	}
}
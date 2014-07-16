package states.game
{
	import allData.Level;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;

	public class GameModeClassicController extends AbstractGameModeController
	{		
		private var _goals:Array;
		private var _current:Array;
		private var _modules:Array;
		private var _qModules:int;
		
		public function GameModeClassicController()
		{
			
		}
		
		public override function addJewels(q:int, type:int):void
		{
			
		}
		
		protected override function build():void
		{
			_goals = new Array();
			_current = new Array();
			_modules = new Array();
			_qModules = 0;
			
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
							_goals[Jewel.TYPE_RED] = int(auxGoal[1]);
							_current[Jewel.TYPE_RED] = 0;
							createGoalModule(Jewel.TYPE_RED);
						}
						
						break;
					case "o":
						if(int(auxGoal[1]) > 0){
							_goals[Jewel.TYPE_ORANGE] = int(auxGoal[1]);
							_current[Jewel.TYPE_ORANGE] = 0;
							createGoalModule(Jewel.TYPE_ORANGE);
						}
						
						break;
					case "y":
						if(int(auxGoal[1]) > 0){
							_goals[Jewel.TYPE_YELLOW] = int(auxGoal[1]);
							_current[Jewel.TYPE_YELLOW] = 0;
							createGoalModule(Jewel.TYPE_YELLOW);
						}
						
						break;
					case "g":
						if(int(auxGoal[1]) > 0){
							_goals[Jewel.TYPE_GREEN] = int(auxGoal[1]);
							_current[Jewel.TYPE_GREEN] = 0;
							createGoalModule(Jewel.TYPE_GREEN);
						}
						
						break;
					case "b":
						if(int(auxGoal[1]) > 0){
							_goals[Jewel.TYPE_BLUE] = int(auxGoal[1]);
							_current[Jewel.TYPE_BLUE] = 0;
							createGoalModule(Jewel.TYPE_BLUE);
						}
						
						break;
					case "v":
						if(int(auxGoal[1]) > 0){
							_goals[Jewel.TYPE_VIOLET] = int(auxGoal[1]);
							_current[Jewel.TYPE_VIOLET] = 0;
							createGoalModule(Jewel.TYPE_VIOLET);
						}
						
						break;
				}
				
			}
			
		}
		
		private function createGoalModule(type:String):void
		{	
			var module:MovieClip = new A_CounterClassic();
			module.y = module.height * _qModules;
			_container.addChild(module);
			
			var JewelTypeClass:Class = getDefinitionByName(type) as Class;
			var jewel:MovieClip = new JewelTypeClass();
			jewel.scaleX = 0.5;
			jewel.scaleY = 0.5;
			jewel.x = jewel.width / 2;
			jewel.y = module.height / 2;
			module.addChild(jewel);
			
			_modules[type] = module;
			_qModules++;
		}
	}
}
package states.game.modes
{
	import allData.Level;
	
	import event.CustomEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import states.game.Jewel;
	
	public class GameModeQuestController extends AbstractGameModeController
	{
		public function GameModeQuestController()
		{
			
		}
		
		public override function destroy():void
		{
			
		}
		
		public override function addJewels(q:int, type:String):void
		{
			var module:GoalModule = getModuleByType(type);
			if(module == null)
			{
				return;
			}
			
			module.current += q;
			updateScore(type);
			checkComeplete();
		}
		
		protected override function build():void
		{
			_goals = new Vector.<GoalModule>();
			
			var goal:int = int(_levelConfig.@goal);
			createGoalModule(Jewel.TYPE_VASE, goal);
		}
		
		protected override function createGoalModule(type:String, goal:int):void
		{
			var module:GoalModule = new GoalModule();
			module.type = type;
			
			//clip
			var clip:MovieClip = new A_CounterClassic();
			clip.y = clip.height * _goals.length;
			_container.addChild(clip);
			
			var jewel:MovieClip = new A_JewelVase();
			jewel.scaleX = 0.5;
			jewel.scaleY = 0.5;
			jewel.x = jewel.width / 2;
			jewel.y = clip.height / 2;
			clip.addChild(jewel);
			module.source = clip;
			
			//goal
			module.goal = goal;
			
			//current
			module.current = 0;
			
			//store
			_goals.push(module);
			
			//update text
			updateScore(type);
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
		
		protected override function updateScore(type:String):void
		{
			var module:GoalModule = getModuleByType(type);
			var clip:MovieClip = module.source;
			var tf:TextField = clip.getChildByName("tfText") as TextField;
			var current:int = module.current;
			var total:int = module.goal;
			
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
package allData
{
	public class Levels
	{
		/*
		gameMode: classic, quest, boss
		initialLines: int
		newLineTimer: int (ms)
		colorBallProb: int (%)
		weightBallProb: int (%)
		target: depends of game mode.
			classic: r:int,o:int,y:int,g:int,b:int,v:int (how many jewels each you need to collect)
			quest: int (how many vessels you need to collect)
			boss: int (how many jewels each you need to collect, the same number for each jewel)
		*/
		public static const LEVELS:XML = new XML(<levels>
			<level mode="classic" initialLines="4" newLineTimer="10000" colorBallProb="30" weightBallProb="30" goal="r:10,o:0,y:0,g:15,b:20,v:5" />
		</levels>)
	}
}

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
		rockProb: int (%)
		maxBalls:int (0 is infinity)
		target: depends of game mode.
			classic: r:int,o:int,y:int,g:int,b:int,v:int (how many jewels each you need to collect)
			quest: int (how many vessels you have to collect)
			boss: r:int,o:int,y:int,g:int,b:int,v:int (same the classic mode, but in order)
		*/
		public static const LEVELS:XML = new XML(<levels>
			<level mode="classic" initialLines="3" newLineTimer="10000" colorBallProb="30" weightBallProb="30" rockProb="5" maxBalls="0" goal="r:10,o:0,y:0,g:10,b:10,v:10" />
			<level mode="quest" colorBallProb="60" weightBallProb="50" rockProb="5" goal="3"  maxBalls="10" />
			<level mode="boss" initialLines="4" newLineTimer="10000" colorBallProb="20" weightBallProb="50" rockProb="5" maxBalls="0" goal="r:10,o:10,y:10,g:10,b:10,v:10" />
		</levels>)
	}
}

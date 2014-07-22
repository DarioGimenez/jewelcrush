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
		jewels: r,o,y,g,b,v (what jewels can appear)
		*/
		public static const LEVELS:XML = new XML(<levels>
			<level mode="classic" initialLines="3" newLineTimer="10000" colorBallProb="10" weightBallProb="20" rockProb="0" maxBalls="0" goal="r:5,y:5,b:10,v:7" jewels="r,y,b,v" />
			<level mode="classic" initialLines="3" newLineTimer="10000" colorBallProb="10" weightBallProb="20" rockProb="0" maxBalls="0" goal="r:0,o:4,y:8,g:10,b:0,v:12" jewels="o,y,g,v" />
			<level mode="quest" colorBallProb="20" weightBallProb="20" rockProb="1" goal="1"  maxBalls="15" jewels="r,o,b,v" />			
			<level mode="classic" initialLines="3" newLineTimer="10000" colorBallProb="10" weightBallProb="20" rockProb="1" maxBalls="0" goal="r:7,o:3,y:9,b:10" jewels="r,o,y,b" />			
			<level mode="classic" initialLines="3" newLineTimer="10000" colorBallProb="10" weightBallProb="20" rockProb="1" maxBalls="0" goal="r:8,o:5,y:5,v:6" jewels="r,o,y,v" />
			<level mode="quest" colorBallProb="20" weightBallProb="20" rockProb="1" goal="2"  maxBalls="20" jewels="r,g,b,v" />
			<level mode="classic" initialLines="3" newLineTimer="10000" colorBallProb="10" weightBallProb="20" rockProb="1" maxBalls="0" goal="r:10,g:10,b:10,v:10" jewels="r,g,b,v" />
			<level mode="classic" initialLines="3" newLineTimer="10000" colorBallProb="10" weightBallProb="20" rockProb="1" maxBalls="0" goal="r:10,o:10,y:5,v:12" jewels="r,o,y,v" />
			<level mode="quest" colorBallProb="20" weightBallProb="20" rockProb="1" goal="3"  maxBalls="30" jewels="o,y,b,v" />
			<level mode="boss" initialLines="4" newLineTimer="10000" colorBallProb="10" weightBallProb="20" rockProb="2" maxBalls="0" goal="r:5,o:7,y:4,b:8," jewels="r,o,y,b" />
		</levels>)
	}
}
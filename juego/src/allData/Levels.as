package allData
{
	public class Levels
	{
		public static const LEVELS_ENDLESS:Vector.<Level> = Vector.<Level>(	[
			new Level(3, 9000, 200, 50, 50) 
		]);
		
		public static const LEVELS_CLASSIC:Vector.<Level> = Vector.<Level>(	[
			new Level(3, 10000, 200, 20, 0),
			new Level(3, 10000, 250, 20, 0),
			new Level(3, 10000, 300, 20, 0),
			new Level(3, 10000, 350, 20, 0),
			new Level(3, 10000, 400, 20, 0),
			new Level(3, 10000, 450, 20, 0),
			new Level(3, 9000, 500, 40, 15),
			new Level(3, 9000, 550, 40, 15),
			new Level(3, 9000, 600, 40, 15),
			new Level(3, 9000, 650, 40, 15),
			new Level(3, 9000, 700, 40, 15),
			new Level(3, 9000, 750, 40, 15),
			new Level(4, 9000, 800, 40, 15),
			new Level(4, 9000, 850, 50, 30),
			new Level(4, 9000, 900, 50, 30),
			new Level(4, 9000, 950, 50, 30),
			new Level(4, 9000, 1000, 50, 30),
			new Level(4, 9000, 1100, 50, 30),
			new Level(4, 8000, 1200, 50, 30),
			new Level(4, 8000, 1300, 50, 30)
		]);
		
		public static const LEVELS_COLOR:Vector.<Level> = Vector.<Level>(	[
			new Level(3, 12000, 200, 0, 100),
			new Level(3, 12000, 250, 0, 100),
			new Level(3, 12000, 300, 0, 100),
			new Level(3, 12000, 350, 0, 100),
			new Level(3, 12000, 400, 0, 100),
			new Level(3, 12000, 450, 0, 100),
			new Level(3, 11000, 500, 0, 100),
			new Level(3, 11000, 550, 0, 100),
			new Level(3, 11000, 600, 0, 100),
			new Level(3, 11000, 650, 0, 100),
			new Level(3, 11000, 700, 0, 100),
			new Level(3, 11000, 750, 0, 100),
			new Level(4, 11000, 800, 0, 100),
			new Level(4, 11000, 850, 0, 100),
			new Level(4, 11000, 900, 0, 100),
			new Level(4, 11000, 950, 0, 100),
			new Level(4, 10000, 1000, 0, 100),
			new Level(4, 10000, 1100, 0, 100),
			new Level(4, 10000, 1200, 0, 100),
			new Level(4, 10000, 1300, 0, 100)
		]);
		
		public static const ALL_LEVELS:Vector.<Vector.<Level>> = Vector.<Vector.<Level>>([LEVELS_ENDLESS, LEVELS_CLASSIC, LEVELS_COLOR]);
	}
}
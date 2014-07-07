package allData
{
	public class Level
	{
		private var _initialLines:int;
		private var _newLineTimer:int;
		private var _goalScore:int;
		private var _chanceWeightBall:int;
		private var _chanceColorBall:int;
		
		public function Level(initialLines:int, newLineTimer:int, goalScore:int, chanceWeightBall:int, chanceColorBall:int)
		{
			_initialLines = initialLines;
			_newLineTimer = newLineTimer;
			_goalScore = goalScore;
			_chanceWeightBall = chanceWeightBall;
			_chanceColorBall = chanceColorBall;
		}

		public function get initialLines():int
		{
			return _initialLines;
		}

		public function get newLineTimer():int
		{
			return _newLineTimer;
		}

		public function get goalScore():int
		{
			return _goalScore;
		}

		public function get chanceWeightBall():int
		{
			return _chanceWeightBall;
		}

		public function get chanceColorBall():int
		{
			return _chanceColorBall;
		}

	}
}
package states.game
{
	public class BoardCell
	{
		private var _jewel:Jewel;
		private var _posX:int;
		private var _posY:int;
		
		public function BoardCell()
		{
		}
		
		public function clearCell():void
		{
			
		}
		
		public function get posY():int
		{
			return _posY;
		}

		public function set posY(value:int):void
		{
			_posY = value;
		}

		public function get posX():int
		{
			return _posX;
		}

		public function set posX(value:int):void
		{
			_posX = value;
		}

		public function set jewel(j:Jewel):void
		{
			_jewel = j;
		}
		
		public function get jewel():Jewel
		{
			return _jewel;
		}
		
	}
}
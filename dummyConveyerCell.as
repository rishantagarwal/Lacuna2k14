package  
{
	/**
	 * ...
	 * @author 
	 */
	public class dummyConveyerCell 
	{
		private var key:int;
		private var nextDir:int;
		private var dir:int;
		private var isDest:Boolean, isRoundabout:Boolean;
		
		public function dummyConveyerCell(nextDir:int, key:int, dir:int, isDest:Boolean, isRoundabout:Boolean) 
		{
			this.dir = dir;
			this.key = key;
			this.isDest = isDest;
			this.isRoundabout = isRoundabout;
			this.nextDir = nextDir;
		}
		
	}

}
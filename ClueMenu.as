package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class ClueMenu extends Sprite
	{
		private var allClues:Vector.<ClueSymbol>;
		private var curLevel:int;
		private var numClues:int;
		
		public function ClueMenu(numClues:int, curLevel:int) 
		{
			this.numClues = numClues;
			this.curLevel = curLevel;
			var i:int = 0;
			allClues = new Vector.<ClueSymbol>();
		}
		
		public function addClue(link:String, qNo:int, state:int) {
			
			var cl:ClueSymbol = new ClueSymbol(link, qNo, curLevel);
			var px:int = (allClues.length * cl.width ) % 400;
			var py:int = (allClues.length * cl.width ) / 400;
			
			allClues.push(cl);
			this.addChild(cl);
			cl.x = px;
			cl.y = py;
		}
		
	}

}
package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class Grid extends Sprite
	{
		static private const CELLHEIGHT:int = 50;
		static public const CELLWIDTH:int = 50;
		private var allCells:Vector.<GridCell>;
		private var wid:int;
		private var hei:int;
		private var disp:Point;
		
		public function Grid(wid:int, hei:int) 
		{
			//var backSp:Sprite = new ;
			
			allCells = new Vector.<GridCell>(wid * hei, true);
			var c:int = 0;
			while (c < (wid * hei)-1) {
				allCells[c] = new GridCell(c);
				allCells[c].addEventListener(MouseEvent.CLICK, moveCell);
				c++;
			}
		}
		
		private function moveCell(e:MouseEvent):void 
		{
			var cell:GridCell = GridCell(e.target);
			var pos:Point = cell.getPos();
			var px:int = pos.x, py:int = pos.y;
			
			// RIGHT CELL EMPTY
			if ((index + 1) % wid != 0) {
				if (allCells[index+1] == null) {
					allCells[index + 1] = allCells[index];
					allCells[index] = null;
				}
			}
			
			// LEFT CELL EMPTY
			if ((index) % wid != 0) {
				if (allCells[index - 1] == null) {
					allCells[index - 1] = allCells[index];
					allCells[index] = null;
				}
			}
			
			// TOP CELL EMPTY
			if (pos.y != 0) {
				if (allCells[index - wid] == null) {
					allCells[index - wid] = allCells[index];
					allCells[index] = null;
				}
			}
			
			// BOTTOM CELL EMPTY
			if (pos.y != hei) {
				if (allCells[index + wid] == null) {
					allCells[index + wid] = allCells[index];
					allCells[index] = null;
				}
			}
		}
		
		public function reOrder(keys:Array):void {
			var temp:Vector.<GridCell> = new Vector.<GridCell>(wid*hei, true);
			var c:int = 0;
			
			while (c < wid * hei) {
				if (keys[c] != -1) {
					temp[c] = allCells[keys[c]];
				}
				else {
					temp[c] = null;
				}
				c++;
			}
			
			c = 0;
			while (c < wid * hei) {
				allCells[c] = temp[c];
				c++;
			}
		}
		
		public function generateBoardSprite():void {
			var i:int = 0;
			var px:Number = pos.x;
			var py:Number = pos.y;
			
			while (i < wid*hei) {
				if (allCells[i] != null) {
					allCells[i].x = px;
					allCells[i].y = py;
				}
				if ((i + 1) % wid == 0) {
					py += CELLHEIGHT;
					px = pos.x;
				}
				else {
					px += CELLWIDTH;
				}
				i++;
			}
		}
		
		public function getState():Array {
			var arr:Array = new Array();
			var i:int = 0;
			
			while (i < wid * hei) {
				arr.push(allCells[i].getId());
				i++;
			}
			return arr;
		}
	}
}
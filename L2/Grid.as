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
		static public const CELLHEIGHT:int = 160;
		static public const CELLWIDTH:int = 240;
		private var allCells:Vector.<GridCell>;
		private var wid:int;
		private var hei:int;
		private var disp:Point;
		
		public function Grid(wid:int, hei:int, xml:XML) 
		{
			//var backSp:Sprite = new ;
			var bk:Sprite = new bkSprite();
			this.addChild(bk);
			
			trace("w", wid, "h", hei);
			allCells = new Vector.<GridCell>(wid * hei, true);
			var c:int = 0;
			while (c < (wid * hei)-1) {
				allCells[c] = new GridCell(c, c%wid, c/wid, xml);
				allCells[c].addEventListener(MouseEvent.CLICK, moveCell);
				allCells[c].mouseChildren = false;
				allCells[c].buttonMode = true;
				this.addChild(allCells[c]);
				c++;
			}
			
			generateBoardSprite();
			var manPointer:manDot = new manDot();
			this.addChild(manPointer);
			manPointer.x = (GenConstants.LacunaInstance.getManInstance().getBody().GetPosition().x * GenConstants.RATIO/ GenConstants.getLevelWidth()) * (Grid.CELLWIDTH * 3);
			manPointer.x += 100;
			manPointer.y = (GenConstants.LacunaInstance.getManInstance().getBody().GetPosition().y * GenConstants.RATIO/ GenConstants.getLevelHeight()) * (Grid.CELLHEIGHT * 3);
			manPointer.y += 100;
			
			// Add the submit button
			var sb:submitBt = new submitBt();
			this.addChild(sb);
			sb.buttonMode = true;
			sb.addEventListener(MouseEvent.CLICK, submit);
			sb.x = 800;
			sb.y = 500;
			
			this.wid = wid;
			this.hei = hei;
		}
		
		private function moveCell(e:MouseEvent):void 
		{
			var cell:GridCell = GridCell(e.target);
			var pos:Point = cell.getPos();
			var px:int = pos.x, py:int = pos.y;
			var index:int = allCells.indexOf(cell);
			trace("before:");
			trace("index:", index, allCells, pos.x, pos.y);
			
			// RIGHT CELL EMPTY
			if (pos.x != wid-1) {
				if (allCells[index + 1] == null) {
					allCells[index + 1] = allCells[index];
					allCells[index] = null;
					cell.setPos(new Point(pos.x+1, pos.y));
				}
			}
			
			// LEFT CELL EMPTY
			if (pos.x != 0) {
				if (allCells[index - 1] == null) {
					allCells[index - 1] = allCells[index];
					allCells[index] = null;
					cell.setPos(new Point(pos.x-1, pos.y));
				}
			}
			
			// TOP CELL EMPTY
			if (pos.y != 0) {
				if (allCells[index - wid] == null) {
					allCells[index - wid] = allCells[index];
					allCells[index] = null;
					cell.setPos(new Point(pos.x, pos.y-1));
				}
			}
			
			// BOTTOM CELL EMPTY
			if (pos.y != hei-1) {
				if (allCells[index + wid] == null) {
					allCells[index + wid] = allCells[index];
					allCells[index] = null;
					cell.setPos(new Point(pos.x, pos.y+1));
				}
			}
			
			trace("after:");
			trace("index:", index, allCells, pos.x, pos.y);
			generateBoardSprite();
		}
		
		public function reOrder(keys:Array):void {
			trace("keys received: ", keys);
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
				if (allCells[c] != null) {
					allCells[c].setPos(new Point(c % wid, int(c / wid)));
				}
				c++;
			}
			trace("reordering");
			trace("keys", keys);
			trace("allcells", allCells);
			generateBoardSprite();
		}
		
		public function generateBoardSprite():void {
			var i:int = 0;
			var pos:Point = new Point(100, 100);
			var px:Number = pos.x;
			var py:Number = pos.y;
			//trace("gen board");
			while (i < wid * hei) {
				//trace("inside");
				if (allCells[i] != null) {
					allCells[i].x = px;
					allCells[i].y = py;
					//trace("pos", px, py);
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
		
		private function submit(ev:MouseEvent):void {
			var temp:Array = new Array();
			var i:int = 0;
			while (i < allCells.length) {
				if (allCells[i] != null) {
					temp.push(allCells[i].getId());
				}
				else {
					temp.push( -1);
				}
				i++;
			}
			trace("sending array", temp);
			Lacuna.STAGE.removeChild(this);
			GenConstants.LacunaInstance.rearrangeWorld(temp);
		}
	}
}
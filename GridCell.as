package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ST
	 */
	public class GridCell extends Sprite
	{
		private var id:int;
		private var pos:Point;
		
		public function GridCell(id:int, xp:int, yp:int) {
			this.id = id;
			pos = new Point(xp, yp);
		}
		
		public function getId():int {
			return id;
		}
		
		public function getPos():void {
			return pos;
		}
		
		public function moveCell(dir:int) {
			switch (dir) {
				case GenConstants.LEFT:
					pos.x--;
					break;
				case GenConstants.UP:
					pos.y--;
					break;
				case GenConstants.RIGHT:
					pos.x++;
					break;
				case GenConstants.DOWN:
					pos.y++;
					break;
			}
		}
	}
}
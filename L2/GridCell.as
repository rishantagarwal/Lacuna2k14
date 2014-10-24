package  
{
	import flash.accessibility.AccessibilityProperties;
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
		
		public function GridCell(id:int, xp:int, yp:int, xml:XML) {
			this.id = id;
			trace("id", id);
			pos = new Point(xp, yp);
			makeSprite(xml);
		}
		
		private function makeSprite(xml:XML):void {
			var objs:Object;
			
			switch (id) {
				case 0:
					objs = xml.boxes.box0;
					break;
				case 1:
					objs = xml.boxes.box1;
					break;
				case 2:
					objs = xml.boxes.box2;
					break;
				case 3:
					objs = xml.boxes.box3;
					break;
				case 4:
					objs = xml.boxes.box4;
					break;
				case 5:
					objs = xml.boxes.box5;
					break;
				case 6:
					objs = xml.boxes.box6;
					break;
				case 7:
					objs = xml.boxes.box7;
					break;
				case 8:
					objs = xml.boxes.box8;
					break;
				case 9:
					objs = xml.boxes.box9;
					break;
			}
			
			var blankRect:Sprite = new Sprite();
			blankRect.graphics.beginFill(0, 0);
			blankRect.graphics.drawRect(0, 0, Grid.CELLWIDTH, Grid.CELLHEIGHT);
			blankRect.graphics.endFill();
			this.addChild(blankRect);
			
			var cellSp:Sprite = new Sprite();
			
			for each(var spec in objs) {
				if (spec.@type == "wall")
				{
					var sp:Sprite = new WallSkin(parseInt(spec.@length), parseInt(spec.@height), (parseInt(spec.@isGrassy) == 1 ? true : false));
					this.addChild(sp);
					sp.x = parseInt(spec.@x) * GenConstants.unitToPixels;
					sp.y = parseInt(spec.@y) * GenConstants.unitToPixels;
					
					cellSp.addChild(sp);
					//trace("making wall.", dispX, dispY);
					//allwalls[id].push(new Wall(this, new Point(dispX + parseInt(spec.@x), dispY +parseInt(spec.@y)), parseInt(spec.@length), parseInt(spec.@height), (parseInt(spec.@isGrassy) == 1 ? true:false), parseInt(spec.@friction), parseInt(spec.@restitution)));
					//trace("wallPos:", id, dispX + parseInt(spec.@x), dispY + parseInt(spec.@y));
				}
			}
			cellSp.scaleX = Grid.CELLWIDTH / cellSp.width;
			cellSp.scaleY = Grid.CELLHEIGHT / cellSp.height;
			this.addChild(cellSp);
			
			/*var sp:Sprite;
			switch(id) {
				case 0:
					sp = new cell0Sp();
					break;
				case 1:
					sp = new cell1Sp();
					break;
				case 2:
					sp = new cell2Sp();
					break;
				case 3:
					sp = new cell3Sp();
					break;
				case 4:
					sp = new cell4Sp();
					break;
				case 5:
					sp = new cell5Sp();
					break;
				case 6:
					sp = new cell6Sp();
					break;
				case 7:
					sp = new cell7Sp();
					break;
				case 8:
					sp = new cell8Sp();
					break;
				case 9:
					sp = new cell9Sp();
					break;
			}*/
			//this.addChild(sp);
		}
		
		public function getId():int {
			return id;
		}
		
		public function getPos():Point {
			return pos;
		}
		
		public function setPos(pt:Point):void {
			pos = pt;
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
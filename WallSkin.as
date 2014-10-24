package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class WallSkin extends Sprite
	{
		private var _skin:Sprite;
		private var dir:int;
		private var isGrassy:Boolean;
		
		public function WallSkin(length:int, hgt:int, isGrassy:Boolean, dir:int) 
		{
			this.isGrassy = isGrassy;
			if (length == 1) {
				_skin = new doubleCurveWall();
			}
			else {
					if (isGrassy) {		
					_skin = new Sprite();
					var c:int = 0, px:int, py:int;
					var temp:Sprite;
					
					if (isGrassy) {
						temp = new leftRoundWall();
					}
					else {
						temp = new blankWall();
					}
					
					// center registration of the image
					temp.x = (( -length / 2) * GenConstants.unitToPixels) + (GenConstants.unitToPixels / 2);
					temp.y = GenConstants.unitToPixels / 2;
					_skin.addChild(temp);
					px = temp.x;
					py = temp.y;
					c++;
					
					while (c < length - 1) {
						if (isGrassy) {
							temp = new middleHorizWall();
						}
						else {
							temp = new blankWall();
						}
						temp.x = px + GenConstants.unitToPixels;
						temp.y = py;
						_skin.addChild(temp);
						px = temp.x;
						c++;
					}
					
					if (isGrassy) {
						temp = new leftRoundWall();
						temp.rotationY = 180;
					}
					else {
						temp = new blankWall();
					}
					temp.x = px + GenConstants.unitToPixels;
					temp.y = py;
					_skin.addChild(temp);
					px = temp.x;
				}
				else if (dir == GenConstants.VERTICAL) {								// VERTICAL WALL SPRITE CONSTRUCTION
					_skin = new Sprite();
					var c:int = 0, px:int, py:int;
					
					var temp:Sprite = new topWall();
					temp.y = ((-length / 2) * GenConstants.unitToPixels) + (GenConstants.unitToPixels / 2);
					temp.x = GenConstants.unitToPixels / 2;
					_skin.addChild(temp);
					px = temp.x;
					py = temp.y;
					c++;
					
					while (c < length-1) {
						if (isGrassy) {
							temp = new middleVertiWall();
						}
						else {
							temp = new blankWall();
						}
						temp.y = py + GenConstants.unitToPixels;
						temp.x = px;
						_skin.addChild(temp);
						py = temp.y;
						c++;
					}
					
					temp = new bottomWall();
					temp.y = py + GenConstants.unitToPixels;
					temp.x = px;
					_skin.addChild(temp);
					py = temp.y;
				}
			}
			this.addChild(_skin);
			
		}
		
	}

}
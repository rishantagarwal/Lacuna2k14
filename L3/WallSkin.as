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
		public function WallSkin(length:int, hgt:int, isGrassy:Boolean) 
		{
			var wallSp:Sprite = new Sprite();
			
			if (length == 1 && hgt == 1) {
				if (isGrassy) {
					wallSp = new doubleGrassyWall();
				}
				else {
					wallSp = new doubleCurveBlankWall();
				}
				this.addChild(wallSp);
				wallSp.x = wallSp.width / 2;
				wallSp.y = wallSp.height / 2;
			}
			else {
				var i:int = 0, py:int = 0;
				while (i < hgt) {
					if (i==0)
						wallSp = makeSgWall(length, isGrassy, false);
					else if (i == hgt - 1)
						wallSp = makeSgWall(length, false, true);
					else 
						wallSp = makeSgWall(length, false, false);
					this.addChild(wallSp);
					wallSp.x = wallSp.width / 2;
					wallSp.y = py;// + wallSp.height / 2;
					py += wallSp.height;
					
					i++;
				}
			}	
			//this.addChild(_skin);
		}
		
		private function makeSgWall(length:int, isGrassy:Boolean, isBottom:Boolean):Sprite {
			// center registration of the image
			var _skin:Sprite = new Sprite();
			var px:Number, py:Number, c:int = 0;
			
			var temp:Sprite;
			if (length == 1) {
				if (isGrassy) {
					temp = new doubleGrassyWall();
				}
				else if (isBottom){
					temp = new doubleCurveBlankWall();
				}
				else {
					temp = new doubleMidWall();
				}
				_skin.addChild(temp);
				//temp.x = GenConstants.unitToPixels / 2;
				temp.y = GenConstants.unitToPixels / 2;
				return _skin;
			}
			
			if (isGrassy) {
				temp = new grassyLeftWall();
			}
			else if (isBottom) {
				temp = new blankBottomLeftWall();
			} 
			else {
				temp = new blankLeftWall();
			}
			temp.x = (( -length / 2) * GenConstants.unitToPixels) + (GenConstants.unitToPixels / 2);
			temp.y = GenConstants.unitToPixels / 2;
			_skin.addChild(temp);
			px = temp.x;
			py = temp.y;
			c++;
			
			while (c < length - 1) {
				if (isGrassy) {
					temp = new grassyMidWall();
				}
				else if (isBottom) {
					temp = new blankBottomMidWall();
				}
				else {
					temp = new blankMidWall();
				}
				temp.x = px + GenConstants.unitToPixels;
				temp.y = py;
				_skin.addChild(temp);
				px = temp.x;
				c++;
			}
			
			if (isGrassy) {
				temp = new grassyLeftWall();
			}
			else if (isBottom) {
				temp = new blankBottomLeftWall();
			}
			else {
				temp = new blankLeftWall();
			}
			temp.rotationY = 180;
			temp.x = px + GenConstants.unitToPixels;
			temp.y = py;
			_skin.addChild(temp);
			px = temp.x;
			
			return _skin;
		}
	}
}
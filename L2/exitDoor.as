package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class exitDoor extends HelperRayCasts
	{
		
		public function exitDoor(par:Sprite, loc:Point) 
		{
			this.par = par;
			sp2 = new exitMc();
			par.addChild(sp2);
			
			sp2.x = (loc.x * GenConstants.unitToPixels) + sp2.width / 2;
			sp2.y = (loc.y * GenConstants.unitToPixels) + sp2.height / 2;
			
			super(par, HelperRayCasts.EXIT, loc, loc, new Point(loc.x + 1, loc.y + 1));
		}
		
		public function destruct():void {
			par.removeChild(sp2);
			//ClueSymbol(sp).removeAnsBox();
		}
		
	}

}
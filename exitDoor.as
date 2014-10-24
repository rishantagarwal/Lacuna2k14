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
		
		public function exitDoor(par:Sprite, location:Point) 
		{
			
			super(par, HelperRayCasts.EXIT, location, location, new Point(location.x + 1, location.y + 1));
		}
		
	}

}
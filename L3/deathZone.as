package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class deathZone extends KillerRayCasts
	{
		
		public function deathZone(par:Sprite, pos:Point) 
		{
			
			super(par, KillerRayCasts.DEATH_ZONE, pos, pos, new Point(pos.x + 1, pos.y + 1));
		}
		
	}

}
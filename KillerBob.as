package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class KillerBob extends killer
	{
		
		public function KillerBob(par:Sprite, pos:Point, ) 
		{
			
			super(par, pos, length, dir, killer.BOB);
		}
		
	}

}
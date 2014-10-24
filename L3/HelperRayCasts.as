package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class HelperRayCasts extends RayCastObjects
	{
		protected var par:Sprite;
		public static const SWITCH:int = 1;
		public static const CLUE:int = 2;
		static public const EXIT:int = 3;
		
		protected var type:int;
		protected var sp:ClueSymbol;
		protected var sp2:Sprite;
		
		public function HelperRayCasts(par:Sprite, type:int, location:Point, _startPoint:Point, _endPoint:Point) 
		{
			this.par = par;
			this.type = type;
			
			super(par, _startPoint, _endPoint);
		}
		
		// returns the type of HelperRayCast
		public function getType():int {
			return type;
		}
		
		override protected function doAction():void {
			if (this is Clue) {
				Clue(this).activateClue();
			}
			else if (this is exitDoor) {
				if (GenConstants.LacunaInstance.canExit()) {
					//trace("kar le exit.");
					GenConstants.LacunaInstance.changeLevel();
				}
			}
		}
	}
}
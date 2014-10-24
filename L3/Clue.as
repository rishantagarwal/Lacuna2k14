package  
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class Clue extends HelperRayCasts
	{
		private var btArr:Vector.<BitmapData>;
		
		public function Clue(par:Sprite, loc:Point, qNo:int, level:int, btArr:Vector.<BitmapData>) 
		{
			this.par = par;
			sp = new ClueSymbol(btArr, qNo, level, GenConstants.LacunaInstance1.getClueState(qNo));
			par.addChild(sp);
			
			sp.x = (loc.x * GenConstants.unitToPixels) + sp.width / 2;
			sp.y = (loc.y * GenConstants.unitToPixels) + sp.height / 2;
			
			super(par, HelperRayCasts.CLUE, loc, loc, new Point(loc.x + 1, loc.y + 1));
		}
		
		public function activateClue():void {
			//if (ClueSymbol(sp).isActive == false) {
				ClueSymbol(sp).activate();
				trace("should activate");
			//}
		}
		
		public function destruct():void {
			par.removeChild(sp);
			ClueSymbol(sp).removeAnsBox();
		}
		
		public function markAnswered():void 
		{
			ClueSymbol(sp).markAnswered();
		}
	}
}
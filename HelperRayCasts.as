package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class HelperRayCasts extends RayCastObjects
	{
		public static const SWITCH:int = 1;
		
		protected var type:int;
		protected var sp:Sprite;
		
		public function HelperRayCasts(par:Sprite, type:int, location:Point, _startPoint:Point, _endPoint:Point) 
		{
			this.type = type;
			var helperSprite:Sprite = createSprite(type, _startPoint, _endPoint);
			helperSprite.x = location.x + (helperSprite.width / 2);
			helperSprite.y = location.y + (helperSprite.height / 2);
			par.addChild(helperSprite);
			
			helperSprite.x = (location.x * GenConstants.unitToPixels) + helperSprite.width / 2;
			helperSprite.y = (location.y * GenConstants.unitToPixels) + helperSprite.height / 2;
			
			sp = helperSprite;
			
			super(par, _startPoint, _endPoint);
		}
		
		private function createSprite(Sptype:uint, stPoint:Point, endPoint:Point):Sprite
		{
			var helperSprite:Sprite;
			trace("type of switch:", Switch(this).getTypeOfSwitch());
			switch(Sptype) {
				case SWITCH:
					if (Switch(this).getTypeOfSwitch() == Switch.GATE_SWITCH) {
						helperSprite = new switchMc();
					}
					else if (Switch(this).getTypeOfSwitch() == Switch.FLIP_SWITCH) {
						helperSprite = new switchMc2();
					}
					break;
			}
			
			return helperSprite;
		}
		
		// returns the type of HelperRayCast
		public function getType():int {
			return type;
		}
		
		override protected function doAction():void {
			if (this is Switch) {
			//if (type == SWITCH) {
				if (GenConstants.LacunaInstance.getManInstance().canOpenSwitch() == true) {
					Switch(this).toggle();
					GenConstants.LacunaInstance.getManInstance().allowSwitchOpen(false);
				}
			}
			//trace("done action");
		}
	}
}
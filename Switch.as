package  
{
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class Switch extends HelperRayCasts
	{
		static public const GATE_SWITCH:int = 0;
		static public const FLIP_SWITCH:int = 1;
		
		private var id:int;
		private var isOn:Boolean;
		private var typeOfSwitch:int;
		private var gates:Array;
		private var canFlip:Boolean;
		
		public function Switch(par:Sprite, id:int, location:Point, type:int, gateIds:String) 
		{
			this.typeOfSwitch = type;
			isOn = false;
			this.id = id;
			canFlip = true;
			
			if (gateIds != null) {
				var temp:Array = gateIds.split(",");
				
				var i:int = 0;
				gates = new Array();
				while (i < temp.length) {
					gates.push(parseInt(temp[i]));
					trace("gate:", temp[i]);
					i++;
				}
			}
			
			super(par, HelperRayCasts.SWITCH, location, location, new Point(location.x+1, location.y+1));
		}
		
		public function toggle():Boolean {
			trace("toggling switch:", id);
			
			if (isOn) {
				// MovieClip(sp).gotoAndStop(2);
			}
			else {
				GenConstants.LacunaInstance.toggleSwitch(id);
				// MovieClip(sp).gotoAndStop(1);
			}
			
			if (typeOfSwitch == GATE_SWITCH && !isOn) {
				var i:int = 0;
				while (i < gates.length) {
					GenConstants.LacunaInstance.toggleGate(gates[i]);
					i++;
				}
			}
			else if (typeOfSwitch == FLIP_SWITCH) {
				// anants please place your code here
				// GenConstants.LacunaInstance ==> YOU CAN ACCESS LACUNA INSTANCE LIKE THIS
				
				if (canFlip) {
					GenConstants.LacunaInstance.togglePipes(id);
					canFlip = false;
					TweenLite.delayedCall(2, allowFlip);
				}
			}
			
			isOn = !isOn;
			return isOn;
		}
		
		private function allowFlip():void 
		{
			canFlip = true;
		}
		
		public function getId():int {
			return id;
		}
		
		public function getTypeOfSwitch():int {
			return typeOfSwitch;
		}
	}
}
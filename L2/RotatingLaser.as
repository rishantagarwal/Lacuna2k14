package  
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class RotatingLaser extends KillerRayCasts
	{
		private var length:Number;
		private var end_angle:Number;
		private var min_angle:Number;
		private var supportBody:Sprite;
		private var toggleState:Boolean;
		private var autoRotate:Boolean;
		private var delay:int;
		
		public function RotatingLaser(par:Sprite, start_pos:Point, end_pos:Point, min_angle:Number, end_angle:Number, autoRot:int, delay:int) 
		{
			this.delay = delay;
			this.min_angle = min_angle;
			this.end_angle = end_angle;
			
			length = Math.sqrt(Math.pow(end_pos.y - start_pos.y, 2) + Math.pow(end_pos.x - start_pos.x, 2));
			supportBody = new inviSprite();
			supportBody.visible = false;
			par.addChild(supportBody);
			supportBody.rotation = min_angle;
			
			toggleState = true;
			autoRotate = false;
			trace("angles", min_angle, end_angle);
			
			if (autoRot == 1) {
				autoRotate = true;
			}
			toggleRotation();
			
			super(par, KillerRayCasts.ROTATING_LASER, start_pos, start_pos, end_pos);
		}
		
		private function toggleRotation():void {
			if (autoRotate) {
			trace("rotate ");
				if (toggleState) {
					rotateToAngle(min_angle);
				}
				else {
					trace("to end angle");
					rotateToAngle(end_angle);
				}
				
				toggleState = !toggleState;
				TweenLite.delayedCall(delay*2, toggleRotation);
			}
		}
		
		public function rotateToAngle(ang:Number):void {
			TweenLite.to(supportBody, delay, { rotation:ang, ease:Cubic.easeInOut} );
		}
		
		override public function createRayCast():void 
		{
			endPoint.x = startPoint.x + (length * Math.sin(supportBody.rotation * Math.PI / 180));
			endPoint.y = startPoint.x + (length * Math.cos(supportBody.rotation * Math.PI / 180));
			
			//trace("rot:", supportBody.rotation, endPoint.x, endPoint.y);
			super.createRayCast();
		}
		
		public function setAutoRotate(val:Boolean):void {
			autoRotate = val;
		}
	}
}
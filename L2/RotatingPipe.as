package 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class RotatingPipe extends Pipe
	{
		private var orientation:String;
		private var pipeNumber:uint;
		
		public function RotatingPipe(parent:Sprite, orientation:String, location:Point, pipeNumber:uint) {
			super(parent, LacunaConstants.PIPE_ROTATABLE, location, null);
			this.orientation = orientation;
			this.pipeNumber = pipeNumber;
		}
		
		public function rotate():void {
			TweenLite.to(super, LacunaConstants.ROTATION_DURATION, { rotation:super.rotation + 90, ease:Linear.easeNone } );
			if (this.orientation == LacunaConstants.PIPE_LEFT_RIGHT)
				this.orientation = LacunaConstants.PIPE_UP_DOWN;
			else
				this.orientation = LacunaConstants.PIPE_LEFT_RIGHT;
		}
		
		public function get Orientation():String {
			return this.orientation;
		}
	}
}
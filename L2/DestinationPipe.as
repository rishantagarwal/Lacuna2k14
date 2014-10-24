package 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class DestinationPipe extends Pipe
	{
		private var expectedShape:String;
		
		public function DestinationPipe(parent:Sprite, location:Point, expectedShape:String) {
			super(parent, LacunaConstants.PIPE_DESTINATION, location, null);
			this.expectedShape = expectedShape;
			if (expectedShape == LacunaConstants.STAR)
				super.addChild(new StarDestination());
			else
				super.addChild(new HeartDestination());
		}
		
		public function get expectedshape():String {
			return this.expectedShape;
		}
	}
}
package 
{
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class Pipe extends Sprite
	{
		private var type:String;
		private var skin:Sprite;
				
		public function Pipe(parent:Sprite, type:String, location:Point, inverted:String) {
			this.type = type;
			if (type != LacunaConstants.PIPE_SOURCE && type != LacunaConstants.PIPE_DESTINATION)
			{
				skin = Level1Pipes.pipeGraphicsDictionary[type]();
				if (inverted == "true")
				{
					if(type != LacunaConstants.PIPE_EXIT_RIGHT && type != LacunaConstants.PIPE_EXIT_LEFT)
						skin.rotation += 180;
					else
						skin.scaleY = -skin.scaleY;
				}
				this.addChild(skin);
			}
			this.x = location.x;
			this.y = location.y;
			this.visible = true;
			parent.addChild(this);
		}
		
		public function get Type():String {
			return this.type;
		}
	}
}
package  
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Fixture;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	
	public class RayCastObjects
	{
		private var parent:Sprite;
		private var parnt:Sprite;
		protected var startPoint:Point;
		protected var endPoint:Point;
		
		public function RayCastObjects(parent:Sprite, _startPoint:Point, _endPoint:Point) 
		{
			this.parent = parent;
			startPoint = _startPoint;
			endPoint = _endPoint;
			
			
			
			//trace("casted.", startPoint.x, startPoint.y, endPoint.x * GenConstants.unitToPixels / GenConstants.RATIO, endPoint.y * GenConstants.unitToPixels / GenConstants.RATIO);
		}
		
		public function createRayCast():void 
		{
			GenConstants.LacWorld.RayCast(rayCastCallback, new b2Vec2(startPoint.x * GenConstants.unitToPixels / GenConstants.RATIO, startPoint.y * GenConstants.unitToPixels / GenConstants.RATIO), new b2Vec2(endPoint.x * GenConstants.unitToPixels / GenConstants.RATIO, endPoint.y * GenConstants.unitToPixels / GenConstants.RATIO));
			updategraphics();
		}
		
		public function updategraphics():void {
			if (parnt != null)
				parent.removeChild(parnt);
			/*parnt = new Sprite();
			parnt.graphics.lineStyle(2, 0xFF0000, 1);
			parnt.graphics.moveTo(startPoint.x * GenConstants.unitToPixels, startPoint.y * GenConstants.unitToPixels);
			parnt.graphics.lineTo(endPoint.x * GenConstants.unitToPixels, endPoint.y * GenConstants.unitToPixels);
			parnt.graphics.endFill();
			parent.addChild(parnt);*/
		}
		
		private function rayCastCallback(fix:b2Fixture, point:b2Vec2, normal:b2Vec2, fraction:Number):Number 
		{
			//trace("callback");
			if (fix.GetBody().GetUserData() is Man)
			{
				if(this is KillerRayCasts) {
					killAnime();
				}
				else if (this is HelperRayCasts) {
					doAction(/*HelperRayCasts(this).getType()*/);
				}
			}
			return 1;
		}
		
		protected function doAction(/*type:int*/):void {
			
		}
		
		protected function killAnime():void {
			
		}
	}
}
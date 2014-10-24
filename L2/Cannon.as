package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class Cannon extends Builder
	{
		
		public function Cannon(par:Sprite, pos:Point, impulse:Number, len:Number, hgt:Number, dir:int) 
		{
			this.hgt = hgt;
			this.len = len;
			
		}
		
		public function goIntoCannon():void {
			
		}
		
		public function shoot():void {
			GenConstants.LacunaInstance
		}
	}

}
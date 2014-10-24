package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class TelePipe extends Builder
	{
		private var dest:Point;
		public var isSource:Boolean;
		private var dir:int;
		private var id:int;
		private var destPipe:int;
		
		public function TelePipe(par:Sprite, pos:Point, dest:Point, dir:int, type:int, id:int, connectedTo:int) 
		{
			this.id = id;
			this.dest = dest;
			this.dir = dir;
			isSource = false;
			destPipe = connectedTo;
			
			if (type == 1) {
				isSource = true;
			}
			super(pos, par);
		}
		
		override protected function makeBody(pos:Point):void 
		{
			var body1Def:b2BodyDef = new b2BodyDef();
			var body1Shape:b2PolygonShape = new b2PolygonShape();
			var body1FixDef:b2FixtureDef = new b2FixtureDef();
			
			body1Shape.SetAsBox(0.5*GenConstants.unitToPixels/GenConstants.RATIO, 0.5*GenConstants.unitToPixels/GenConstants.RATIO);
			body1Def.position.Set((pos.x+0.5)*GenConstants.unitToPixels/GenConstants.RATIO, (pos.y+0.5)*GenConstants.unitToPixels/GenConstants.RATIO);
			
			body1Def.type = b2Body.b2_staticBody;
			
			body1FixDef.shape = body1Shape;
			body1FixDef.friction = 0.8;
			body1FixDef.restitution = 0.2;
			
			_body = GenConstants.LacWorld.CreateBody(body1Def);
			_body.CreateFixture(body1FixDef);
			
			super.makeBody(pos);
		}
		
		override protected function makeSkin(par:Sprite):void 
		{
			_skin = new pipeMc();
			par.addChild(_skin);
			switch(dir) {
				case GenConstants.LEFT:
					_skin.rotation = 90;
					break;
				case GenConstants.UP:
					_skin.rotation = 180;
					break;
				case GenConstants.RIGHT:
					_skin.rotation = -90;
					break;
				case GenConstants.DOWN:
					_skin.rotation = 0;
					break;
			}
			super.makeSkin(par);
		}
		
		public function getDir():int {
			return dir;
		}
		
		public function getDestination():Point {
			return dest;
		}
		
		public function isSrc():Boolean {
			return isSource;
		}
	}
}
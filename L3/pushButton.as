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
	 * @author 
	 */
	public class pushButton extends Builder
	{
		//private var par:Sprite;
		public var isPressed:Boolean = false;
		
		public function pushButton(par:Sprite, pos:Point) 
		{
			
			super(pos, par);
		}
		
		override protected function makeBody(pos:Point):void 
		{
			var body1Def:b2BodyDef = new b2BodyDef();
			var body1Shape:b2PolygonShape = new b2PolygonShape();
			var body1FixDef:b2FixtureDef = new b2FixtureDef();
			
			body1Shape.SetAsBox(0.5*GenConstants.unitToPixels/GenConstants.RATIO, 0.1*GenConstants.unitToPixels/GenConstants.RATIO);
			body1Def.position.Set((pos.x+0.5)*GenConstants.unitToPixels/GenConstants.RATIO, (pos.y+0.9)*GenConstants.unitToPixels/GenConstants.RATIO);
			
			body1Def.type = b2Body.b2_dynamicBody;
			
			body1FixDef.shape = body1Shape;
			body1FixDef.friction = 0.8;
			body1FixDef.restitution = 0.2;
			//body1FixDef.density = 0.8;
			
			_body = GenConstants.LacWorld.CreateBody(body1Def);
			_body.CreateFixture(body1FixDef);
			
			super.makeBody(pos);
		}
		
		override protected function makeSkin(par:Sprite):void 
		{
			this.par = par;
			_skin = new buttonSp();
			par.addChild(_skin);
			
			super.makeSkin(par);
		}
		
		public function pushIt():void {
			trace("button is pushed.");
			isPressed = true;
			buttonSp(_skin).gotoAndStop(2);
		}
	}
}
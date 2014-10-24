package 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class Spike extends killer 
	{
		private var spikeSprite:Sprite;
		private var inverted:int;
		private var speed:Number;
		
		public function Spike(parent:Sprite, pos:Point, speed:Number, inverted:int) {
				this.inverted = inverted;
				this.speed = speed;
				super(parent, pos, 1, 0, -1, 0);
		}
		
		override protected makeBody(pos:Point):void {
			var body1Def:b2BodyDef = new b2BodyDef();
			var body1Shape:b2PolygonShape = new b2PolygonShape();
			var body1FixDef:b2FixtureDef = new b2FixtureDef();
			
			body1Def.position.Set(((pos.x * GenConstants.unitToPixels) / GenConstants.RATIO), ((pos.y * GenConstants.unitToPixels) / GenConstants.RATIO));
			body1Def.type = b2Body.b2_dynamicBody;
			
			body1Shape.SetAsBox(GenConstants.unitToPixels / GenConstants.RATIO / 2, GenConstants.unitToPixels / GenConstants.RATIO / 2);
			
			body1FixDef.shape = body1Shape;
			body1FixDef.friction = friction;
			body1FixDef.restitution = restitution;
			
			_body = GenConstants.LacWorld.CreateBody(body1Def);
			_body.CreateFixture(body1FixDef);
			
			super.makeBody(pos);
		}
		
		override protected makeSkin(par:Sprite):void {
			var sp = new SpikeSprite();
			if (this.inverted == 1)
				sp.rotation += 180;
			par.addChild(sp);
		}
		
		public function shootOut():void {
			var newVel:b2Vec2;
			if(this.inverted == 0)
				newVel = new b2Vec2(speed, 0);
			else
				newVel = new b2Vec2( -speed, 0);
			_body.SetLinearVelocity(newVel);
		}
	}
}
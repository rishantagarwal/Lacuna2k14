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
	public class OscRocket extends killer
	{
		private var vel:Number;
		private var startPos:Point;
		private var endPos:Point;
		private var dir:int;
		
		public function OscRocket(par:Sprite, startPos:Point, endPos:Point, dir:int, vel:Number) 
		{
			this.vel = vel;
			this.dir = dir;
			this.endPos = endPos;
			this.startPos = startPos;
			
			super(par, startPos, 1, dir, killer.ROCKET, 1);
		}
		
		override protected function makeBody(pos:Point):void 
		{
			var body1Def:b2BodyDef = new b2BodyDef();
			var body1Shape:b2PolygonShape = new b2PolygonShape();
			var body1FixDef:b2FixtureDef = new b2FixtureDef();
			
			body1Shape.SetAsBox(0.3*GenConstants.unitToPixels/GenConstants.RATIO, 0.3*GenConstants.unitToPixels/GenConstants.RATIO);
			body1Def.position.Set((pos.x+0.5)*GenConstants.unitToPixels/GenConstants.RATIO, (pos.y+0.5)*GenConstants.unitToPixels/GenConstants.RATIO);
			
			body1Def.type = b2Body.b2_kinematicBody;
			
			body1FixDef.shape = body1Shape;
			body1FixDef.friction = 0;
			body1FixDef.restitution = 0.2;
			//body1FixDef.density = 0.8;
			
			_body = GenConstants.LacWorld.CreateBody(body1Def);
			_body.CreateFixture(body1FixDef);
			
			super.makeBody(pos);
		}
		
		override protected function makeSkin(par:Sprite):void 
		{
			_skin = new rocketMc();
			par.addChild(_skin);
			
			super.makeSkin(par);
		}
		
		override public function childSpecificUpdating():void 
		{
			//trace("upd turtle");
			//velBody = _body.GetPosition().x;
			
			if (dir == GenConstants.LEFT) {
				if (Math.floor((_body.GetPosition().x * GenConstants.RATIO) / GenConstants.unitToPixels) > startPos.x) {
					//trace("set velocity:", -vel);
					_body.SetLinearVelocity(new b2Vec2( -vel, 0));
					_skin.rotation = -90;
				}
				else {
					//swap(startPos, endPos);
					_skin.rotation = 90;
					dir = GenConstants.RIGHT;
					_body.SetPosition(new b2Vec2(_body.GetPosition().x + 0.5, _body.GetPosition().y));
				}
			}
			else if (dir == GenConstants.RIGHT) {
				if (Math.floor((_body.GetPosition().x * GenConstants.RATIO) / GenConstants.unitToPixels) < endPos.x) {
					//trace("set velocity:", vel);
					_body.SetLinearVelocity(new b2Vec2(vel, 0));
					_skin.rotation = 90;
				}
				else {
					//swap(startPos, endPos);
					_skin.rotation = -90;
					dir = GenConstants.LEFT;
					_body.SetPosition(new b2Vec2(_body.GetPosition().x-0.5, _body.GetPosition().y));
				}
			}
			if (dir == GenConstants.UP) {
				if (Math.floor((_body.GetPosition().y * GenConstants.RATIO) / GenConstants.unitToPixels) > startPos.y) {
					//trace("set velocity:", -vel);
					_body.SetLinearVelocity(new b2Vec2(0, -vel));
					_skin.rotation = 0;
				}
				else {
					//swap(startPos, endPos);
					_skin.rotation = 180;
					dir = GenConstants.DOWN;
					_body.SetPosition(new b2Vec2(_body.GetPosition().x, _body.GetPosition().y + 0.5));
				}
			}
			else if (dir == GenConstants.DOWN) {
				if (Math.floor((_body.GetPosition().y * GenConstants.RATIO) / GenConstants.unitToPixels) < endPos.y) {
					//trace("set velocity:", vel);
					_body.SetLinearVelocity(new b2Vec2(0, vel));
					_skin.rotation = 180;
				}
				else {
					//swap(startPos, endPos);
					_skin.rotation = 0;
					dir = GenConstants.UP;
					_body.SetPosition(new b2Vec2(_body.GetPosition().x, _body.GetPosition().y - 0.5));
				}
			}
			
			super.childSpecificUpdating();
		}
		override public function updateNow():void 
		{
			super.updateNow();
		}
	}
}
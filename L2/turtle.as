package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.greensock.TweenLite;
	/**
	 * ...
	 * @author 
	 */
	public class turtle extends Builder 
	{
		private var dir:int;
		private var startPos:Point;
		private var endPos:Point;
		private var vel:Number;
		private var velBody:Number;
		private var timeToWake:int;
		public var state:int = 0;
		
		public static const HORIZONTAL:uint = 1;
		
		public function turtle(par:Sprite, startPos:Point, endPos:Point, vel:Number, fric:Number, timeToWake:int) 
		{
			this.timeToWake = timeToWake;
			this.vel = vel;
			this.endPos = endPos;
			this.startPos = startPos;
			
			if (startPos.x > endPos.x) {
				dir = GenConstants.LEFT;
			}
			else {
				dir = GenConstants.RIGHT;
			}
			
			//makeBody(startPos);
			//makeSkin(par);
			
			super(startPos, par);
		}
		
		private function swap(p1:Point, p2:Point) {
			var tmp:Point = p1;
			p1 = p2;
			p2 = p1;
		}
		
		override protected function makeBody(pos:Point):void 
		{
			var body1Def:b2BodyDef = new b2BodyDef();
			var body1Shape:b2PolygonShape = new b2PolygonShape();
			var body1FixDef:b2FixtureDef = new b2FixtureDef();
			
			body1Shape.SetAsBox(0.4*GenConstants.unitToPixels/GenConstants.RATIO, 0.35*GenConstants.unitToPixels/GenConstants.RATIO);
			body1Def.position.Set((pos.x+0.5)*GenConstants.unitToPixels/GenConstants.RATIO, (pos.y+0.5)*GenConstants.unitToPixels/GenConstants.RATIO);
			
			body1Def.type = b2Body.b2_dynamicBody;
			
			body1FixDef.shape = body1Shape;
			body1FixDef.friction = 0.8;
			body1FixDef.restitution = 0.6;
			
			_body = GenConstants.LacWorld.CreateBody(body1Def);
			_body.CreateFixture(body1FixDef);
			
			super.makeBody(pos);
		}
		
		override protected function makeSkin(par:Sprite):void 
		{
			//trace("making turtle skin");
			_skin = new turtleMc();
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
					_skin.rotationY = 0;
				}
				else {
					//swap(startPos, endPos);
					_skin.rotationY = 180;
					dir = GenConstants.RIGHT;
					_body.SetPosition(new b2Vec2(_body.GetPosition().x + 0.5, _body.GetPosition().y));
				}
			}
			else if (dir == GenConstants.RIGHT) {
				if (Math.floor((_body.GetPosition().x * GenConstants.RATIO) / GenConstants.unitToPixels) < endPos.x) {
					//trace("set velocity:", vel);
					_body.SetLinearVelocity(new b2Vec2(vel, 0));
					_skin.rotationY = 180;
				}
				else {
					//swap(startPos, endPos);
					_skin.rotationY = 0;
					dir = GenConstants.LEFT;
					_body.SetPosition(new b2Vec2(_body.GetPosition().x-0.5, _body.GetPosition().y));
				}
			}
			
			super.childSpecificUpdating();
		}
		
		public function deactivate():void {
			if (state == 0) {
				//GenConstants.LacunaInstance.stopTurtle();
				_body.SetLinearVelocity(new b2Vec2(0, 0));
				_skin.y += 15;
				_skin.rotation = 180;
				trace("deactivated");
				state = 1;
				TweenLite.delayedCall(timeToWake, activate);
				//TweenLite.to();
			}
		}
		
		public function activate():void {
			_skin.rotation = 0;
			_skin.y -= 15;
			state = 0;
			_body.SetAwake(true);
			//GenConstants.LacunaInstance.startTurtle();
		}
		
		override public function destruct(par:Sprite):void 
		{
			
			super.destruct(par);
		}
	}
}
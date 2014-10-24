package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class Cannon extends Builder
	{
		private var len:Number;
		private var hgt:Number;
		public var isActive:Boolean = false;
		private var dir:int;
		
		public function Cannon(par:Sprite, pos:Point, impulse:Number, len:Number, hgt:Number, dir:int) 
		{
			this.dir = dir;
			this.hgt = hgt;
			this.len = len;
			super(pos, par);
		}
		
		override protected function makeBody(pos:Point):void 
		{
			var body1Def:b2BodyDef = new b2BodyDef();
			var body1Shape:b2PolygonShape = new b2PolygonShape();
			var body1FixDef:b2FixtureDef = new b2FixtureDef();
			
			body1Shape.SetAsBox(len * GenConstants.unitToPixels / GenConstants.RATIO, hgt * 2 * GenConstants.unitToPixels / GenConstants.RATIO);
			if (dir == GenConstants.UP) {
				body1Def.position.Set((pos.x + 0.5) * GenConstants.unitToPixels / GenConstants.RATIO, (pos.y + 0.5 + len / 2) * GenConstants.unitToPixels / GenConstants.RATIO);
			}
			else {
				body1Def.position.Set((pos.x + 0.5 + len/2) * GenConstants.unitToPixels / GenConstants.RATIO, (pos.y + 0.5) * GenConstants.unitToPixels / GenConstants.RATIO);
			}
			
			body1Def.type = b2Body.b2_kinematicBody;
			
			body1FixDef.shape = body1Shape;
			body1FixDef.friction = 0.5;
			body1FixDef.restitution = 0.2;
			//body1FixDef.density = 0.8;
			
			_body = GenConstants.LacWorld.CreateBody(body1Def);
			_body.CreateFixture(body1FixDef);
			
			super.makeBody(pos);
		}
		
		public function resetRotation():void {
			switch (dir) {
				case GenConstants.LEFT:
					_body.SetAngle(-Math.PI/2);
					break;
				case GenConstants.UP:
					_body.SetAngle(0);
					break;
				case GenConstants.RIGHT:
					_body.SetAngle(Math.PI / 2);
					break;
				case GenConstants.DOWN:
					_body.SetAngle(Math.PI);
					break;
			}
		}
		
		override protected function makeSkin(par:Sprite):void 
		{
			_skin = new cannonMc();
			par.addChild(_skin);
			resetRotation();
			
			super.makeSkin(par);
		}
		
		override public function childSpecificUpdating():void 
		{
			if (isActive) {
				
			}
			super.childSpecificUpdating();
		}
		
		public function activate():void {
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down3);
			cannonMc(_skin).gotoAndStop(2);
			isActive = true;
		}
		
		private function key_down3(e:KeyboardEvent):void 
		{
			if (e.keyCode == 39) {
				if (_body.GetAngle() < Math.PI/2) {
					_body.SetAngle(_body.GetAngle() + 0.1);
				}
			}
			else if (e.keyCode == 37) {
				if (_body.GetAngle() > -Math.PI / 2) {
					_body.SetAngle(_body.GetAngle() - 0.1);
				}
			}
			else if (e.keyCode == 76 || e.keyCode == 108) {
				trace("shooot man");
				shoot();
			}
		}
		
		public function shoot():void {
			GenConstants.LacunaInstance1.getManInstance().shoot(_body.GetAngle(), _body.GetPosition(), len);
			GenConstants.LacunaInstance2.getManInstance().shoot(_body.GetAngle(), _body.GetPosition(), len);
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down3);
			TweenLite.delayedCall(1, resetRotation);
			cannonMc(_skin).gotoAndStop(1);
			isActive = false;
		}
	}

}
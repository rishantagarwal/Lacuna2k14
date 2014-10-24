package  
{
	import Box2D.Common.Math.b2Vec2;
	import flash.automation.KeyboardAutomationAction;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class Rocket extends Builder
	{
		private var dir:int;
		public var isActive:Boolean = false;
		private var ammo:int;
		//private var par:Sprite;
		private var pos:Point;
		private var resetFlag:int;
		
		public function Rocket(par:Sprite, pos:Point, dir:int, ammo:int) 
		{
			
			resetFlag = 0;
			this.pos = pos;
			this.par = par;
			this.ammo = ammo;
			this.dir = dir;
			ammo = 500;
			super(pos, par);
		}
		
		override protected function makeBody(pos:Point):void 
		{
			var body1Def:b2BodyDef = new b2BodyDef();
			var body1Shape:b2PolygonShape = new b2PolygonShape();
			var body1FixDef:b2FixtureDef = new b2FixtureDef();
			
			body1Shape.SetAsBox(0.2* GenConstants.unitToPixels/GenConstants.RATIO, 0.1*GenConstants.unitToPixels/GenConstants.RATIO);
			body1Def.position.Set((pos.x)*GenConstants.unitToPixels/GenConstants.RATIO, (pos.y)*GenConstants.unitToPixels/GenConstants.RATIO);
			
			body1Def.type = b2Body.b2_dynamicBody;
			
			body1FixDef.shape = body1Shape;
			body1FixDef.density = 1;
			body1FixDef.friction = 0.5;
			body1FixDef.restitution = 0.1;
			//body1FixDef.density = 0.8;
			
			_body = GenConstants.LacWorld.CreateBody(body1Def);
			_body.CreateFixture(body1FixDef);
			
			/*switch(dir) {
				case GenConstants.LEFT:
					_body.SetAngle(Math.PI);
					break;
				case GenConstants.UP:
					_body.SetAngle(-Math.PI / 2);
					break;
				case GenConstants.RIGHT:
					_body.SetAngle(0);
					break;
				case GenConstants.DOWN:
					_body.SetAngle(Math.PI / 2);
					break;
			}*/
			_body.SetActive(false);
			//_body.SetLinearVelocity(new b2Vec2(0, 0));
			
			super.makeBody(pos);
		}
		
		public function rotateRck():void {
			_body.SetAngle(Math.PI / 2);
		}
		
		override protected function makeSkin(par:Sprite):void 
		{
			_skin = new rocketMc();
			//_skin = new Sprite();
			par.addChild(_skin);
			
			super.makeSkin(par);
		}
		
		override public function childSpecificUpdating():void 
		{
			if (resetFlag == 1) {
				reset();
				resetFlag = 2;
			}
			else if (resetFlag == 2) {
				resetFlag = 0;
				isActive = false;
			}
			//trace("updating rck");
			if (isActive) {
				_body.SetAwake(true);
				var theta:Number = (_body.GetAngle() * 180 / Math.PI) % 360;
				if (theta > 180 && theta < 360) {
					theta = -(360 - theta);
				}
				else if (theta < -180 && theta > - 360) {
					theta = 360 + theta;
				}
				/*else if (theta < -360) {
					while (theta < -360)
						theta += 360;
				}
				else if (theta > 360) {
					while (theta > 360)
						theta -= 360;
				}*/
				
				//trace("active update rck", theta);
				var velVec:b2Vec2 = new b2Vec2(1, 0);
				
				if (theta > 0 && theta <= 90) {
					theta = toRad(theta);
					velVec = new b2Vec2(Math.floor(GenConstants.ROCKET_VEL * Math.cos(theta)), Math.floor(GenConstants.ROCKET_VEL * Math.sin(theta)));
				}
				else if (theta > 90 && theta <= 180) {
					theta -= 90;
					theta = toRad(theta);
					trace(theta);
					velVec = new b2Vec2(Math.floor(-GenConstants.ROCKET_VEL * Math.sin(theta)), Math.floor(GenConstants.ROCKET_VEL * Math.cos(theta)));
				}
				else if (theta < 0 && theta > -90) {
					theta = -theta;
					theta = toRad(theta);
					trace(theta);
					velVec = new b2Vec2(Math.floor(GenConstants.ROCKET_VEL * Math.cos(theta)), Math.floor(-GenConstants.ROCKET_VEL * Math.sin(theta)));
				}
				else if (theta < -90 && theta > -180) {
					theta = -(theta + 90);
					theta = toRad(theta);
					trace(theta);
					velVec = new b2Vec2(Math.floor(-GenConstants.ROCKET_VEL * Math.sin(theta)), Math.floor(-GenConstants.ROCKET_VEL * Math.cos(theta)));
				}
				_body.SetLinearVelocity(velVec);
				
				//trace("vel", velVec.x, velVec.y);
			}
			
			//trace("setting vel", velVec.x, velVec.y);
			
			super.childSpecificUpdating();
		}
		
		private function toRad(theta:Number):Number 
		{
			theta = theta * Math.PI/180;
			return theta;
		}
		
		public function activateRocket(val:Boolean):void {
			isActive = val;
			_body.SetActive(true);
			trace("activated");
			if (val == true) {
				Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down2);
			}
			else {
				Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down2);
			}
			_body.SetSleepingAllowed(false);
		}
		
		public function rotateRocket(dir:int):void {
			trace("rotating");
			if (isActive) {
				switch(dir) {
					case GenConstants.LEFT:
						_body.SetAngle(_body.GetAngle() - 0.3);
						break;
					case GenConstants.RIGHT:
						_body.SetAngle(_body.GetAngle() + 0.3);
				}
			}
		}
		
		private function key_down2(ev:KeyboardEvent) {
			switch(ev.keyCode) {
				case 37:
					rotateRocket(GenConstants.LEFT);
					break;
				case 39:
					rotateRocket(GenConstants.RIGHT);
					break;
			}
		}
		
		public function getState():Boolean {
			return isActive;
		}
		
		public function getBody():b2Body {
			return _body;
		}
		
		public function getPos():Point {
			return pos;
		}
		
		public function reset():void {
			if (ammo > 0) {
				trace("rck pos:", pos.x, pos.y, _body);
				
				//_body.SetPosition(new b2Vec2((pos.x) * GenConstants.unitToPixels / GenConstants.RATIO, (pos.y) * GenConstants.unitToPixels / GenConstants.RATIO));
				trace("new pos:", _body.GetPosition().x, _body.GetPosition().y);
				ammo--;
				
				switch(dir) {
					case GenConstants.LEFT:
						_body.SetAngle(Math.PI);
						break;
					case GenConstants.UP:
						_body.SetAngle(-Math.PI / 2);
						break;
					case GenConstants.RIGHT:
						_body.SetAngle(0);
						break;
					case GenConstants.DOWN:
						_body.SetAngle(Math.PI / 2);
						break;
				}
				//_body.SetAwake(false);
				_body.SetAwake(false);
			}
			else {
				trace(par);
				if (par is Lacuna) {
					trace ("yes it is");
				}
				destruct(par);
			}
			_body.SetSleepingAllowed(true);
			
		}
		
		public function setResetFlag():void {
			if (resetFlag == 0) {
				resetFlag = 1;
			}
		}
		
	}

}
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
	import flash.text.engine.FontPosture;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian 
	 */
	public class Man extends Builder
	{
		private var dim:Point;
		private var par:Sprite;
		private var friction:Number;
		private var restitution:Number;
		private var density:Number;
		private var left:Boolean, right:Boolean, up:Boolean, down:Boolean;
		private var jumpHeight:Number;
		private var isJumping:Boolean;
		private var canJump:Boolean;
		private var jumpCount:int;
		private var horizFlag:Boolean;
		private var teleportDest:Point;
		private var canOpenSw:Boolean;
		public var canTeleport:Boolean;
		public var isTeleporting:Boolean;
		public var contactCount:int = 0;
		
		public function Man(par:Sprite, pos:Point, length:Number, width:Number, friction:Number, restitution:Number, density:Number, jumpImp:Number) 
		{
			// initialisations
			GenConstants.JUMP_IMPULSE = jumpImp;
			this.par = par;
			this.density = density;
			this.restitution = restitution;
			this.friction = friction;
			this.density = density;
			this.restitution = restitution;
			this.dim = new Point(width, length);
			this.jumpHeight = GenConstants.jumpCap;
			
			up = down = left = right = false;
			canJump = true;
			isJumping = false;
			jumpCount = 0;
			horizFlag = true;
			canTeleport = false;
			isTeleporting = false;
			canOpenSw = false;
			
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_UP, key_up);
			trace("out of constr");
			super(pos, par);
		}
		
		override protected function makeBody(pos:Point):void 
		{
			trace("making body");
			var body1Def:b2BodyDef = new b2BodyDef();
			var body1Shape:b2PolygonShape = new b2PolygonShape();
			var body1FixDef:b2FixtureDef = new b2FixtureDef();
			
			body1Def.position.Set(((pos.x * GenConstants.unitToPixels) / GenConstants.RATIO), ((pos.y * GenConstants.unitToPixels) / GenConstants.RATIO));
			body1Def.type = b2Body.b2_dynamicBody;
			
			body1Shape.SetAsBox(dim.x * GenConstants.unitToPixels / GenConstants.RATIO / 2, dim.y * GenConstants.unitToPixels / GenConstants.RATIO / 2);
			
			body1FixDef.shape = body1Shape;
			body1FixDef.friction = friction;
			body1FixDef.restitution = restitution;
			
			_body = GenConstants.LacWorld.CreateBody(body1Def);
			_body.CreateFixture(body1FixDef);
			
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_UP, key_up);
			trace("man created");
			super.makeBody(pos);
		}
		
		override protected function makeSkin(par:Sprite):void 
		{
			/*var sp:Sprite = new manSprite();
			sp.scaleX = (_wid * 2) / sp.width;
			sp.scaleY = sp.scaleX;
			
			_skin = sp;
			par.addChild(_skin);*/
			//_skin = new manSprite();
			//par.addChild(_skin);
			_skin = new manSp();
			par.addChild(_skin);
			
			super.makeSkin(par);
		}
		
		override public function childSpecificUpdating():void 
		{
			_body.SetAwake(true);
			
			var gravity:int = GenConstants.LacunaInstance.getGravDir();
			//trace("hz:", horizFlag);
			if (right && !left && horizFlag) {
				_body.SetAwake(true);
				
				switch(gravity) {
					case GenConstants.DOWN:
						pushRight();
						break;
					case GenConstants.LEFT:
						pushDown();
						break;
					case GenConstants.UP:
						pushLeft();
						break;
					case GenConstants.RIGHT:
						pushUp();
						break;
				}
			}
			if (left && !right && horizFlag) {
				_body.SetAwake(true);
				
				switch(gravity) {
					case GenConstants.DOWN:
						pushLeft();
						break;
					case GenConstants.LEFT:
						pushUp();
						break;
					case GenConstants.UP:
						pushRight();
						break;
					case GenConstants.RIGHT:
						pushDown();
						break;
				}
			}
			if (up && !down) {
				/*switch(gravity) {
					case GenConstants.UP:
						recede(gravity);
						break;
					default:
						jump(gravity);
						break;
				}*/
				jump(gravity);
			}
			if (down && !up) {
				if (canTeleport) {
					if (teleportDest != null) {
						GenConstants.LacunaInstance.startTeleport(teleportDest);
					}
				}
				else {
					recede(gravity);
				}
				
				/*switch(gravity) {
					case GenConstants.UP:
						jump(gravity);
						break;
					default:
						
						break;
				}*/
			}
			
			super.childSpecificUpdating();
		}
		
		private function pushRight():void {
			var newVel:b2Vec2 = new b2Vec2(0.5, 0);
			if (horizFlag) {
				if(_body.GetLinearVelocity().x < 5)
				{
					newVel.Add(_body.GetLinearVelocity());
					_body.SetLinearVelocity(newVel);
				}
			}
			else {
				if(_body.GetLinearVelocity().x < 4)
				{
					newVel.Add(_body.GetLinearVelocity());
					_body.SetLinearVelocity(newVel);
				}
			}
		}
		
		private function pushLeft():void {
			var newVel:b2Vec2 = new b2Vec2( -0.5, 0);
			
			if (horizFlag) {
				if(_body.GetLinearVelocity().x > -5) {
					newVel.Add(_body.GetLinearVelocity());
					_body.SetLinearVelocity(newVel);
				}
			}
			else {
				if(_body.GetLinearVelocity().x > -4) {
					newVel.Add(_body.GetLinearVelocity());
					_body.SetLinearVelocity(newVel);
				}
			}
		}
		
		private function pushUp():void {
			var newVel:b2Vec2 = new b2Vec2(0, -0.5);
				
			if(_body.GetLinearVelocity().y > -5)
			{
				newVel.Add(_body.GetLinearVelocity());
				_body.SetLinearVelocity(newVel);
			}
		}
		
		private function pushDown():void {
			var newVel:b2Vec2 = new b2Vec2( 0, 0.5);
				
			if(_body.GetLinearVelocity().y < 5)
			{
				newVel.Add(_body.GetLinearVelocity());
				_body.SetLinearVelocity(newVel);
			}
		}
		
		private function jump(gravDir:int):void {
			if (jumpCount < GenConstants.MAXJUMP) {
				if (!isJumping && canJump) {
					if (gravDir == GenConstants.DOWN) 
						_body.ApplyImpulse(new b2Vec2(0, -GenConstants.JUMP_IMPULSE), _body.GetWorldCenter());
					else if (gravDir == GenConstants.LEFT)
						_body.ApplyImpulse(new b2Vec2(GenConstants.JUMP_IMPULSE, 0), _body.GetWorldCenter());
					else if (gravDir == GenConstants.UP)
						_body.ApplyImpulse(new b2Vec2(0, GenConstants.JUMP_IMPULSE), _body.GetWorldCenter());
					else
						_body.ApplyImpulse(new b2Vec2( -GenConstants.JUMP_IMPULSE, 0), _body.GetWorldCenter());
				}
				jumpCount++;
				TweenLite.killDelayedCallsTo(resetJump);
				TweenLite.delayedCall(1.5, resetJump);
			}
		}
		
		private function resetJump():void 
		{
			jumpCount = 0;
		}
		
		private function recede(gravDir:int):void {
			if (isJumping) {
				if (gravDir == GenConstants.DOWN) 
					_body.ApplyImpulse(new b2Vec2(0, GenConstants.JUMP_IMPULSE), _body.GetWorldCenter());
				else if (gravDir == GenConstants.LEFT)
					_body.ApplyImpulse(new b2Vec2(-GenConstants.JUMP_IMPULSE, 0), _body.GetWorldCenter());
				else if (gravDir == GenConstants.UP)
					_body.ApplyImpulse(new b2Vec2(0, -GenConstants.JUMP_IMPULSE), _body.GetWorldCenter());
				else
					_body.ApplyImpulse(new b2Vec2(GenConstants.JUMP_IMPULSE, 0), _body.GetWorldCenter());
			}
		}
		
		private function key_down(e:KeyboardEvent):void 
		{
			switch(e.keyCode) {
				case 37:
					left = true;
					break;
				case 38:
					up = true;
					break;
				case 39:
					right = true;
					break;
				case 40:
					down = true;
					break;
				case 83:
				case 115:
					canOpenSw = true;
					trace("can Open");
					break;
			}
			//trace("key down", left, up, right, down);
		}
		
		private function key_up(e:KeyboardEvent):void 
		{	
			switch(e.keyCode) {
				case 37:
					left = false;
					break;
				case 38:
					up = false;
					break;
				case 39:
					right = false;
					break;
				case 40:
					down = false;
					break;
				case 83:
				case 115:
					canOpenSw = false;
					trace("can't Open");
					break;
			}
		}
		
		// GETTERS AND SETTERS
		public function setCanJump(val:Boolean) {
			canJump = val;
			if (val) {
				trace("can jump");
			}
			else {
				trace("can't jump");
			}
		}	
		
		public function getBody():b2Body {
			return _body;
		}
		
		public function allowHorizontal(val:Boolean):void {
			this.horizFlag = val;
		}
		
		public function setTeleportDestination(pos:Point) {
			teleportDest = pos;
		}
		
		public function canOpenSwitch():Boolean {
			return canOpenSw;
		}
		
		public function allowSwitchOpen(val:Boolean):void{
			canOpenSw = val;
		}
		
		public function removeListener() {
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_UP, key_up);
			trace("man movement stop");
		}
		
		public function resetListener() {
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_UP, key_up);
			trace("man movement start");
		}
	}
}
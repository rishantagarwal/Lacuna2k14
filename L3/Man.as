package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.text.engine.FontPosture;
	import com.greensock.easing.Quad;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian 
	 */
	public class Man extends Builder
	{
		private var dim:Point;
		//private var par:Sprite;
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
		public var isPaused:Boolean = false;
		private var manMc:MovieClip;
		private var shouldChangeSkin:Boolean;
		private var prevContact:int;
		private var isDead:Boolean;
		private var exitFlag:Boolean;
		public var canGoInside:Boolean;
		private var cannon:Cannon;
		private var id:int
		
		public function Man(par:Sprite, pos:Point, length:Number, width:Number, friction:Number, restitution:Number, density:Number, jumpImp:Number, id:int) 
		{
			this.id = id;
			trace(" making man");
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
			isDead = false;
			exitFlag = false;
			
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_UP, key_up);
			trace("out of constr");
			super(pos, par);
			shouldChangeSkin = false;
			prevContact = 0;
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
			manMc = new manSp();
			manMc.stop();
			_skin = new Sprite();
			_skin.addChild(manMc);
			par.addChild(_skin);
			
			super.makeSkin(par);
		}
		
		override public function childSpecificUpdating():void 
		{
			if (isDead) {
				return;
			}
			_body.SetAwake(true);
			
			var gravity:int = GenConstants.LacunaInstance1.getGravDir();
			//trace("hz:", horizFlag);
			
			if ((prevContact > 1 && contactCount <= 1) || (prevContact <= 1 && contactCount > 1))
				shouldChangeSkin = true;
			
			/*if (contactCount <= 1) {
				if (shouldChangeSkin) {
					_skin.removeChildAt(0);
					manMc = new manSp();
					_skin.addChild(manMc);
					shouldChangeSkin = false;
				}
			} else {
				if (shouldChangeSkin) {
					_skin.removeChildAt(0);
					manMc = new manPush();
					_skin.addChild(manMc);
					shouldChangeSkin = false;
				}
			}*/
			
			var vel:Number;
			prevContact = contactCount;
			
			if (gravity == GenConstants.DOWN)
				vel = _body.GetLinearVelocity().x;
			else if (gravity == GenConstants.UP)
				vel = -(_body.GetLinearVelocity().x);
			else if (gravity == GenConstants.LEFT)
				vel = _body.GetLinearVelocity().y;
			else 
				vel = -(_body.GetLinearVelocity().y);
			
			if (vel > 0.1) {
				manMc.rotationY = 0;
				if (contactCount == 0)
					//TweenLite.delayedCall(0.2, stopMan);
					manMc.gotoAndStop(2);
				else if (right)
					manMc.play();
				else
					TweenLite.delayedCall(0.3, stopMan);
					//manMc.gotoAndStop(8);
			} else if (vel < -0.1) {
				manMc.rotationY = 180;
				if (contactCount == 0)
					//TweenLite.delayedCall(0.2, stopMan);
					manMc.gotoAndStop(2);
				else if (left)
					manMc.play();
				else
					TweenLite.delayedCall(0.3, stopMan);
					//manMc.gotoAndStop(8);
			} else { manMc.gotoAndStop(0); }
			
			
			
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
						GenConstants.LacunaInstance1.startTeleport(teleportDest);
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
		
		private function stopMan():void {
			manMc.gotoAndStop(8);
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
				trace("jumping", gravDir, isJumping, canJump);
			}
		}
		
		public function jumpAdj(gravDir:int):void {
			//if (jumpCount < GenConstants.MAXJUMP) {
				//if (!isJumping && canJump) {
					if (gravDir == GenConstants.DOWN) 
						_body.ApplyImpulse(new b2Vec2(0, -GenConstants.JUMP_IMPULSE/2), _body.GetWorldCenter());
					else if (gravDir == GenConstants.LEFT)
						_body.ApplyImpulse(new b2Vec2(GenConstants.JUMP_IMPULSE/2, 0), _body.GetWorldCenter());
					else if (gravDir == GenConstants.UP)
						_body.ApplyImpulse(new b2Vec2(0, GenConstants.JUMP_IMPULSE/2), _body.GetWorldCenter());
					else
						_body.ApplyImpulse(new b2Vec2( -GenConstants.JUMP_IMPULSE/2, 0), _body.GetWorldCenter());
				//}
				//jumpCount++;
				//TweenLite.killDelayedCallsTo(resetJump);
				//TweenLite.delayedCall(1.5, resetJump);
			//}
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
			trace("key pressed");
			switch(e.keyCode) {
				case 37:
					if (id == 1)
						left = true;
					else if (id == 2)
						right = true;
					
					trace("go left");
					break;
				case 38:
					up = true;
					trace("go up");
					break;
				case 39:
					if (id == 1)
						right = true;
					else if (id == 2)
						left = true;
					
					trace("go right");
					break;
				case 40:
					down = true;
					trace("go down");
					break;
				case 83:
				case 115:
					canOpenSw = true;
					trace("can Open switch");
					break;
				case 69:
				case 101:
					exitFlag = true;
					trace("go exit");
					break;
				case 99:
				case 67:
					if (canGoInside) {
						if (cannon != null) {
							if (id == 1) 
								GenConstants.LacunaInstance1.activateCannon();
							else
								GenConstants.LacunaInstance2.activateCannon();
						}
					}
					break;
			}
			//trace("key down", left, up, right, down);
		}
		
		public function shoot(theta:Number, pos:b2Vec2, len:Number):void {
			trace("angle set:", theta);
			if (cannon != null) {
				if (id == 1)
					GenConstants.LacunaInstance1.shootMan(theta, pos, len * GenConstants.unitToPixels);
				else if (id == 2)
					GenConstants.LacunaInstance2.shootMan(theta, pos, len * GenConstants.unitToPixels);
			}
		}
		
		private function key_up(e:KeyboardEvent):void 
		{	
			switch(e.keyCode) {
				case 37:
					if (id == 1)
						left = false;
					else if (id == 2)
						right = false;
					break;
				case 38:
					up = false;
					break;
				case 39:
					if (id == 1)
						right = false;
					else if (id == 2)
						left = false;
					break;
				case 40:
					down = false;
					break;
				case 83:
				case 115:
					canOpenSw = false;
					trace("can't Open");
					break;
				case 69:
				case 101:
					exitFlag = false;
					break;
			}
		}
		
		// GETTERS AND SETTERS
		public function setCanJump(val:Boolean):void {
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
		
		public function setTeleportDestination(pos:Point):void {
			teleportDest = pos;
		}
		
		public function canOpenSwitch():Boolean {
			return canOpenSw;
		}
		
		public function allowSwitchOpen(val:Boolean):void{
			canOpenSw = val;
		}
		
		public function removeListener():void {
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_UP, key_up);
			//trace("man movement stop");
			isPaused = true;
		}
		
		public function resetListener():void {
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_UP, key_up);
			//trace("man movement start");
			isPaused = false;
		}
		
		public function playDeathAnimation():void {
			playUpDeath();
			isDead = true;
		}
		
		private function playUpDeath():void {
			TweenLite.to(_skin, 0.75, { scaleX:1.25, scaleY:1.25, y:_skin.y - 100, rotation:180, onComplete:playDownDeath, ease: Quad.easeOut });
		}
		
		private function playDownDeath():void {
			TweenLite.to(_skin, 3, { scaleX:1, scaleY: 1, y:_skin.y + 1200, ease:Quad.easeIn } );
		}
		
		public function setCanExit(val:Boolean) {
			exitFlag = val;
		}
		
		public function canExit():Boolean {
			return exitFlag;
		}
		
		public function stopMotion():void {
			manMc.stop();
		}
		
		override public function destruct(par:Sprite):void 
		{
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_UP, key_up);
			
			super.destruct(par);
		}
		
		public function setCannon(cn:Cannon):void 
		{
			cannon = cn;
		}
		
		public function getCannon():Cannon {
			return cannon;
		}
		
		public function getId():int { 
			return id;
		}
		
		public function goInvi():void 
		{
			_skin.visible = false;
		}
		
		public function goVisi():void {
			_skin.visible = true;
		}
	}
}
package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import com.greensock.easing.Cubic;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.greensock.plugins.ScrollRectPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class Lacuna extends Sprite
	{
		public static var STAGE:Stage = null;
		
		// all objects
		private var allWalls:Vector.<Wall>;
		private var allKillers:Vector.<killer>;
		private var allBoxes:Vector.<Box1>;
		private var allPipes:Vector.<TelePipe>;
		private var allGates:Vector.<Gate>;
		private var allRayCasts:Vector.<RayCastObjects>;
		
		private var gravDir:int = GenConstants.DOWN;
		private var man:Man;
		private var worldView:Boolean;
		private var l1p:Level1Pipes;
		private var xmlLoader:XMLLoader;
		private var xml2:XML;
		private var canRotate:Boolean;
		
		public function Lacuna(xml:XML, st:Stage) 
		{	
			trace("hello world");
			STAGE = st;
			worldView = true;
			canRotate = true;
			
			// SET THE WORLD WIDTH AND HEIGHT
			GenConstants.levelWidth = parseFloat(xml.level.@width);
			GenConstants.levelHeight = parseFloat(xml.level.@height);
			
			// INITIATE THE WORLD
			GenConstants.LacWorld = new b2World(new b2Vec2(parseInt(xml.gravity.@x),parseInt(xml.gravity.@y)), true);
			// GenConstants.gravityVal = parseInt(xml.gravity.@y);
			TweenPlugin.activate([ScrollRectPlugin]);
			
			// CREATE THE BOUNDARY OF THE WORLD
			trace("w", GenConstants.levelWidth, "h", GenConstants.levelHeight);
			createBoundingWalls();
			setDebug();
			
			// ADD THE WALLS TO THE WORLD
			allWalls = new Vector.<Wall>();
			allKillers = new Vector.<killer>();
			allBoxes = new Vector.<Box1>();
			allPipes = new Vector.<TelePipe>();
			allGates = new Vector.<Gate>();
			allRayCasts = new Vector.<RayCastObjects>();
			
			//man = new Man(this, new Point(parseInt(xml.man.@x), parseInt(xml.man.@y)), parseInt(xml.man.@height), parseInt(xml.man.@width), parseInt(xml.man.@friction), parseInt(xml.man.@restitution), parseInt(xml.man.@density));
			//man = new Man(this, new Point(4, 3), 0.8, 0.8, 0.5, 0.2, 2);
			
			// SPECIFY THE LEFT TOP GRID POINTS OF EACH ELEMENT
			
			for each(var wall in xml.staticobjs.staticobj)
			{
				if (wall.@type == "wall")
				{
					//trace("making wall.");
					allWalls.push(new Wall(this, new Point(parseInt(wall.@x), parseInt(wall.@y)), parseInt(wall.@length), parseInt(wall.@dir), parseInt(wall.@cornerType), parseInt(wall.@friction), parseInt(wall.@restitution)));
				}
				else if (wall.@type == "spike")
				{
					//trace("making killer");
					allKillers.push(new killer(this, new Point(parseInt(wall.@x), parseInt(wall.@y)), parseInt(wall.@length), parseInt(wall.@dir), killer.SPIKES));
				}
			}
			
			var objs:Object = xml.specobjs.specobj;
			for each(var spec in objs)
			{
				
				if (spec.@type == "switch_gate") {
					//trace("gate switch created");
					allRayCasts.push(new Switch(this, parseInt(spec.@id), new Point(parseInt(spec.@x), parseInt(spec.@y)), Switch.GATE_SWITCH, spec.@gatesLinked));
					// gatesLinked are the ids of the gates that toggle by this switch
					// format: 1,2,3 ...
				}
				else if (spec.@type == "switch_flip") {
					//trace("flip switch created");
					allRayCasts.push(new Switch(this, parseInt(spec.@id), new Point(parseInt(spec.@x), parseInt(spec.@y)), Switch.FLIP_SWITCH, null));
				}
				else if (spec.@type == "rot_laser") {
					//trace("laser created");
					allRayCasts.push(new RotatingLaser(this,  new Point(parseInt(spec.@startx), parseInt(spec.@starty)), new Point(parseInt(spec.@endx), parseInt(spec.@endy)), parseFloat(spec.@minAngle), parseFloat(spec.@maxAngle), parseInt(spec.@auto), parseInt(spec.@delay)));
					// auto = 1  ==>   auto-rotate
					// auto = 0  ==>   don't auto-rotate
				}
				else if (spec.@type == "box") {
					//trace("box created");
					allBoxes.push(new Box1(this, new Point(parseInt(spec.@x), parseInt(spec.@y)), parseFloat(spec.@width), parseFloat(spec.@height)));
				}
				else if (spec.@type == "pipe") {
					allPipes.push(new TelePipe(this,  new Point(parseInt(spec.@x), parseInt(spec.@y)), new Point(parseInt(spec.@destx), parseInt(spec.@desty)), parseInt(spec.@dir), parseInt(spec.@typeSD), parseInt(spec.@id), parseInt(spec.@connectedTo)));
					// id  ==>  id of the pipe
					// connectedTo  ==>  id of the destination pipe
				}
				else if (spec.@type == "gate") {
					allGates.push(new Gate(this, new Point(parseInt(spec.@x), parseInt(spec.@y)), parseInt(spec.@id), parseInt(spec.@dir), parseInt(spec.@closeDelay)));
				}
				else if (spec.@type == "man") {
					if (man == null) {
						//trace("making man");
						man = new Man(this, new Point(parseInt(spec.@x), parseInt(spec.@y)), parseFloat(spec.@length), parseFloat(spec.@width), parseFloat(spec.@friction), parseFloat(spec.@restitution), parseFloat(spec.@density), parseFloat(spec.@jumpImpulse));
					}
				}
			}
			// teleporter ==> (13, 19) ==> destination - (9, 1) ==> dir = down
			// teleporter ==> (9, 1) ==> dir = up
			// teleporter ==> (0, 17) ==> destination - (9, 1) ==> dir = left
			
			// man ==> (6, 4)
			// boxes ==> (0, 4), (8, 4), (12, 3), (19, 9), (5, 14), (0, 19)
			
			// CLUE SWITCHES ==> (2, 2), (16, 0), (12, 8), (9, 11)
			
			// GATE 
			// ==> (2, 16), H, (3, 19), V, K = 1 
			// ==> (17, 3), H, K = 2 
			// ==> (14, 11), V, K = 3
			
			// GATE SWITCHES 
			// ==> (7, 6), K = 1
			// ==> (7, 11), (19, 2), K = 2
			// ==> (13, 1), (9, 13), K = 3
			
			// Spikes
			// ==> (1, 0), H, L = 3
			// ==> (12, 0), V, L = 2
			// ==> (14, 0), H, L = 1
			// ==> (19, 0), H, L = 1
			// ==> (0, 1), V, L = 3
			// ==> (9, 6), V, L = 3
			// ==> (12, 0), H, L = 3
			// ==> (9, 10), H, L = 1
			// ==> (5, 11), H, L = 2
			// ==> (0, 12), V, L = 4
			// ==> (10, 15), H, L = 2
			// ==> (19, 16), V, L = 3
			// ==> (16, 19), H, L = 3
			
			// Rotating laser
			// ==> (3, 3)
			// ==> (17, 17)
			
			// TIME LIMIT OF GATES
			/*
			allRayCasts = new Vector.<RayCastObjects>();
			allRayCasts.push(new Switch(this, 1, new Point(1, 0), new Point(1, 1), new Point(3, 1)));
			allRayCasts.push(new Switch(this, 1, new Point(0, 1), new Point(1, 1), new Point(1, 3)));
			*/
			STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			STAGE.addEventListener(Event.ENTER_FRAME, update);
			
			var mc:MovieClip = new MovieClip();
			l1p = new Level1Pipes(mc);
			mc.addChild(l1p);
			STAGE.addChild(mc);
			mc.x = 900;
			mc.scaleX = mc.scaleY = 0.5;
			
			xmlLoader;
			var xmlName:String = "test.xml";
			
			xmlLoader = new XMLLoader(xmlName, {name:"testxml", onComplete:xmlLoaded} );
			xmlLoader.load();
			
			GenConstants.LacunaInstance = this;
		}
		
		function xmlLoaded(loadEvent:LoaderEvent):void {
			trace("XML Loaded");
			xml2 = new XML(LoaderMax.getContent("testxml"));
			for each(var pipe in xml2.pipes.pipe) {
				l1p.newPipe(parseInt(pipe.@x), parseInt(pipe.@y), new String(pipe.@type), new String(pipe.@inverted), new String(pipe.@expected));
			}
			for each(var clue in xml2.clues.clue) {
				l1p.newClue(parseInt(clue.@x), parseInt(clue.@y), new String(clue.@shapetype), new String(clue.@shapecolor), parseInt(clue.@questionno), new String(clue.@link), new String(clue.@speed));
			}
			l1p.sendClues();
			//rot();
		}
		
		function rot():void {
			l1p.rotatePipe(Math.random()*5);
			//TweenLite.delayedCall(3, rot);
		}
		
		private function createBoundingWalls():void {
			var bodyDef:b2BodyDef = new b2BodyDef();
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			var bodyFixDef:b2FixtureDef = new b2FixtureDef();
			var bd:b2Body ;
			
			/*// LEFT BOUND
			bodyDef.position.Set(-0.2, GenConstants.getLevelHeight() / GenConstants.RATIO / 2);
			bodyDef.type = b2Body.b2_staticBody;
			
			bodyShape.SetAsBox(0.2, GenConstants.getLevelHeight() / GenConstants.RATIO / 2);
			
			bodyFixDef.shape = bodyShape;
			bodyFixDef.friction = 0.5;
			bodyFixDef.restitution = 0;
			bd = GenConstants.LacWorld.CreateBody(bodyDef);
			bd.CreateFixture(bodyFixDef);
			bd.SetUserData();*/
			new Wall(this, new Point( -1, 0), GenConstants.getHeightUnits(), 1, 1, 1, 0.7);
			new Wall(this, new Point( 0, -1), GenConstants.getWidthUnits(), 0, 1, 1, 0.7);
			new Wall(this, new Point( GenConstants.getWidthUnits(), 0), GenConstants.getHeightUnits(), 1, 1, 1, 0.7);
			new Wall(this, new Point( 0, GenConstants.getHeightUnits()), GenConstants.getWidthUnits(), 0, 1, 1, 0.7);
			
			/*// TOP BOUND
			bodyDef = new b2BodyDef();
			bodyShape = new b2PolygonShape();
			bodyFixDef = new b2FixtureDef();
			bodyDef.position.Set(GenConstants.getLevelWidth() / GenConstants.RATIO / 2, -0.2);
			bodyDef.type = b2Body.b2_staticBody;
			
			bodyShape.SetAsBox(GenConstants.getLevelWidth() / GenConstants.RATIO / 2, 0.2);
			
			bodyFixDef.shape = bodyShape;
			bodyFixDef.friction = 1;
			bodyFixDef.restitution = 0.1;
			bd = GenConstants.LacWorld.CreateBody(bodyDef);
			bd.CreateFixture(bodyFixDef);
			
			// RIGHT BOUND
			bodyDef = new b2BodyDef();
			bodyShape = new b2PolygonShape();
			bodyFixDef = new b2FixtureDef();
			bodyDef.position.Set(GenConstants.getLevelWidth() / GenConstants.RATIO + 0.2, GenConstants.getLevelHeight() / GenConstants.RATIO / 2);
			bodyDef.type = b2Body.b2_staticBody;
			
			bodyShape.SetAsBox(0.2, GenConstants.getLevelHeight() / GenConstants.RATIO / 2);
			
			bodyFixDef.shape = bodyShape;
			bodyFixDef.friction = 0.5;
			bodyFixDef.restitution = 0.1;
			bd = GenConstants.LacWorld.CreateBody(bodyDef);
			bd.CreateFixture(bodyFixDef);
			
			// BOTTOM BOUND
			bodyDef = new b2BodyDef();
			bodyShape = new b2PolygonShape();
			bodyFixDef = new b2FixtureDef();
			bodyDef.position.Set(GenConstants.getLevelWidth() / GenConstants.RATIO / 2, GenConstants.getLevelHeight() / GenConstants.RATIO + 0.2);
			bodyDef.type = b2Body.b2_staticBody;
			
			bodyShape.SetAsBox(GenConstants.getLevelWidth() / GenConstants.RATIO / 2, 0.2);
			
			bodyFixDef.shape = bodyShape;
			bodyFixDef.friction = 0.5;
			bodyFixDef.restitution = 0.1;
			bd = GenConstants.LacWorld.CreateBody(bodyDef);
			bd.CreateFixture(bodyFixDef);
			trace("all added.");
			*/
			//trace(bd.GetWorldCenter().x, bd.GetWorldCenter().y);
		}
		
		private function update(e:Event) {
			//trace("updating");
			GenConstants.LacWorld.Step(1/30, 10, 10);
            GenConstants.LacWorld.ClearForces();
            GenConstants.LacWorld.DrawDebugData();
			GenConstants.LacWorld.SetContactListener(new LacunaContactListener());
			
			for each(var rc:RayCastObjects in allRayCasts) {
				rc.createRayCast();
			}
			
			for each(var bx:Box1 in allBoxes) {
				bx.updateNow();
			}
			
			man.updateNow();
			
			man.childSpecificUpdating();
			toggleView();
		}
		
		private function setDebug():void {
			var debugDraw:b2DebugDraw = new b2DebugDraw();
            var debugSprite:Sprite = new Sprite();
            addChild(debugSprite);
            debugDraw.SetSprite(debugSprite);
            debugDraw.SetDrawScale(GenConstants.RATIO);
            debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
            debugDraw.SetFillAlpha(0.5);
            GenConstants.LacWorld.SetDebugDraw(debugDraw);
		}
		
		public function getManInstance():Man {
			return man;
		}
		
		public function toggleSwitch(id:int):void {
			
		}
		
		private function key_down(e:KeyboardEvent):void 
		{
			if (e.keyCode == 99 || e.keyCode == 67) {
				trace("rotateAnti");
				if (canRotate) {
					rotateWorld();
				}
			}
			if (e.keyCode == 118 || e.keyCode == 86) {
				trace("rotateClock");
				if (canRotate) {
					rotateWorld2();
				}
			}
			if (e.keyCode == 77 || e.keyCode == 109) {
				//toggleView();
				if (worldView == false) 
					setKeyListener();
					
				worldView = !worldView;
			}
		}
		
		public function allowRotate(val:Boolean):void 
		{
			canRotate = val;
		}
		
		public function rotateWorld():void {
			GenConstants.LacWorld.SetGravity(new b2Vec2(0, 0));
			man.getBody().SetAngle(man.getBody().GetAngle() - Math.PI / 2);
			man.setCanJump(false);
			man.allowHorizontal(false);
			canRotate = false;
			
			TweenLite.delayedCall(1, resetGravity);
		}
		
		public function rotateWorld2():void {
			GenConstants.LacWorld.SetGravity(new b2Vec2(0, 0));
			man.getBody().SetAngle(man.getBody().GetAngle() + Math.PI / 2);
			man.setCanJump(false);
			canRotate = false;
			
			TweenLite.delayedCall(1, resetGravity2);
		}
		
		public function resetGravity():void {
			var newGrav:b2Vec2;
			man.allowHorizontal(false);
			man.resetListener();
			
			if (gravDir == GenConstants.DOWN) {
				newGrav = new b2Vec2( -10, 0);
				gravDir = GenConstants.LEFT;
			}
			else if (gravDir == GenConstants.LEFT) {
				trace("left");
				newGrav = new b2Vec2(0, -10);
				gravDir = GenConstants.UP;
			}
			else if (gravDir == GenConstants.UP) {
				trace("up");
				newGrav = new b2Vec2(10, 0);
				gravDir = GenConstants.RIGHT;
			}
			else if (gravDir == GenConstants.RIGHT) {
				newGrav = new b2Vec2(0, 10);
				gravDir = GenConstants.DOWN;
			}
			for each (var box:Box1 in allBoxes) {
				box.setAwake();
			}
			GenConstants.LacWorld.SetGravity(newGrav);
		}
		
		public function resetGravity2():void {
			var newGrav:b2Vec2;
			man.allowHorizontal(false);
			
			if (gravDir == GenConstants.DOWN) {
				newGrav = new b2Vec2( 10, 0);
				gravDir = GenConstants.RIGHT;
			}
			else if (gravDir == GenConstants.LEFT) {
				trace("left");
				newGrav = new b2Vec2(0, 10);
				gravDir = GenConstants.DOWN;
			}
			else if (gravDir == GenConstants.UP) {
				trace("up");
				newGrav = new b2Vec2(-10, 0);
				gravDir = GenConstants.LEFT;
			}
			else if (gravDir == GenConstants.RIGHT) {
				newGrav = new b2Vec2(0, -10);
				gravDir = GenConstants.UP;
			}
			for each (var box:Box1 in allBoxes) {
				box.setAwake();
			}
			GenConstants.LacWorld.SetGravity(newGrav);
		}
		
		public function startTeleport(dest:Point):void {
			// PLAY man going in mask animation
			man.isTeleporting = true;
			
			// delayed call to the teleportMan function
			teleportMan(dest);
		}
		
		public function teleportMan(dest:Point):void {
			// PLAY man coming out animation
			
			// delayed call to the endTeleport function
			endTeleport(dest);
		}
		
		public function endTeleport(dest:Point):void {
			// PUT man body in right place
			man.getBody().SetPosition(new b2Vec2(dest.x * GenConstants.unitToPixels/GenConstants.RATIO, dest.y * GenConstants.unitToPixels/GenConstants.RATIO));
			man.isTeleporting = false;
		}
		
		public function getGravDir():int {
			return gravDir;
		}
		
		public function toggleView():void {
			if (worldView) {
				var originX:Number = 0;
				var originY:Number = 0;
				var pt:b2Vec2 = man.getBody().GetWorldCenter();
				
				if (pt.x > 380 / GenConstants.RATIO) {
					originX = 200;
				}
				if (pt.x > 600 / GenConstants.RATIO) {
					originX = 500;
				}
				
				/*else if (pt.x > 1500) {
					originX = 1500;
				}*/
				/*else {
					originX = pt.x;
				}*/
				//originX -= 500;
				if (pt.y > 350 / GenConstants.RATIO) {
					originY = 250;
				}
				if (pt.y > 650 / GenConstants.RATIO) {
					originY = 600;
				}
				if (pt.y > 800) {
					originY = 800;
				}
				//originY -= 300;
				
				TweenLite.to(this, 1, { scaleX:1, scaleY:1, scrollRect: { x: originX, y:originY, width: STAGE.stageWidth*0.7, height: STAGE.stageHeight}, ease: Cubic.easeOut } );
			}
			else {
				TweenLite.to(this, 1, { scaleX: (STAGE.stageWidth*0.7 / (GenConstants.getLevelWidth()+GenConstants.unitToPixels*2)), scaleY:(STAGE.stageHeight / (GenConstants.getLevelHeight()+GenConstants.unitToPixels*2)), ease: Cubic.easeOut, scrollRect:{x:0, y:0, width:GenConstants.getLevelWidth()+20, height:GenConstants.getLevelHeight()+20} } );
				resetManListeners();
			}
		}
		
		private function setKeyListener():void 
		{
			man.resetListener();
		}
		
		private function resetManListeners():void 
		{
			man.removeListener();
		}
		
		public function pauseGame():void {
			STAGE.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		public function playGame():void {
			STAGE.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function toggleGate(id:int) {
			allGates[id].toggleState();
		}
		
		public function togglePipes(id:int):void {
			l1p.rotatePipe(id);
			trace("rotate pipe:", id);
		}
		public function autoMapStart():void {
			//pauseGame();
			worldView = false;
			TweenLite.delayedCall(2, autoMapEnd);
		}
		
		private function autoMapEnd():void 
		{
			worldView = true;
			setKeyListener();
		}
	}
}
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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class Lacuna extends Sprite
	{
		public static var STAGE:Stage = null;
		static public const CUR_LEVEL:int = 1;
		
		// all objects
		private var allWalls:Vector.<Wall>;
		private var allKillers:Vector.<killer>;
		private var allBoxes:Vector.<Box1>;
		private var allPipes:Vector.<TelePipe>;
		private var allGates:Vector.<Gate>;
		private var allRayCasts:Vector.<RayCastObjects>;
		private var allLasers:Vector.<RotatingLaser>;
		private var cluesSolved:Vector.<Boolean>;
		private static var allClues:Vector.<Clue>;
		
		private var gravDir:int = GenConstants.DOWN;
		private var man:Man;
		private var worldView:Boolean;
		//private var l1p:Level1Pipes;
		//public var l1pContainer:Sprite;
		private var moveWidth:Number, moveHeight:Number;
		private var manX:Number, manY:Number, manPrevX:Number, manPrevY:Number;
		private var halfStageW:Number, halfStageH:Number;
		private var xBeforeMap:Number, yBeforeMap:Number;
		/*private var shouldResetView:Boolean;*/
		private var hideCalled:Boolean;
		private var xmlLoader:XMLLoader;
		private var xml2:XML;
		private var canRotate:Boolean;
		private var numClues:int = 0;
		private var restartF:Function;
		private var ext:exitDoor;
		private var rst:restartMc;
		//private var rgtPanel:panel;
		
		private var nocorrans:Array;
		private var corresqno:Array;
		private var request5:URLRequest;
		private var loader5:URLLoader;
		private var phploaded:Boolean;
		private var xml:XML;
		private var tryAg:tryAgainMc;
		private var blackRect:Sprite;
		//private var cluMenu:ClueMenu;
		private var variables:URLVariables;
		private var request:URLRequest;
		private var countRotations:int;
		private var rotTf:TextField;
		private var btArr:Vector.<BitmapData>;
		private var specPoint:b2Vec2;
		private var instr:levelInstructs;
		private var instrTypo:instructsText;
		private static var manUpdate:Boolean = true;
		private var type:int;
		private var allRockets:Vector.<OscRocket>;
		private var allCannons:Vector.<Cannon>;
		private var inCannon:Boolean = false;
		
		public function Lacuna(xml:XML, st:Stage, restartF:Function, btArr:Vector.<BitmapData>, type:int) 
		{
			this.type = type;
			this.btArr = btArr;
			this.xml = xml;
			
			//TweenLite.to(this, 0, { scaleX:1, scaleY:1, scrollRect: { x:0, y:0, width: STAGE.stageWidth * 0.7, height: STAGE.stageHeight }, ease: Cubic.easeOut } );
			
			this.restartF = restartF;
			trace("hello world");
			if (type == 1)
				STAGE = st;
			worldView = true;
			canRotate = true;
			
			// SET THE WORLD WIDTH AND HEIGHT
			GenConstants.levelWidth = parseInt(xml.level.@width);
			GenConstants.levelHeight = parseInt(xml.level.@height);
			GenConstants.CANNON_IMPULSE = parseInt(xml.level.@cannonImp);
			countRotations = parseInt(xml.level.@countRotations);
			
			// INITIATE THE WORLD
			GenConstants.LacWorld = new b2World(new b2Vec2(parseInt(xml.gravity.@x),parseInt(xml.gravity.@y)), true);
			// GenConstants.gravityVal = parseInt(xml.gravity.@y);
			TweenPlugin.activate([ScrollRectPlugin]);
			
			// CREATE THE BOUNDARY OF THE WORLD
			trace("w", GenConstants.levelWidth, "h", GenConstants.levelHeight);
			/*if (type == 1)
				createBoundingWalls();*/
			//setDebug();
			
			// ADD THE WALLS TO THE WORLD
			allWalls = new Vector.<Wall>();
			allKillers = new Vector.<killer>();
			allBoxes = new Vector.<Box1>();
			allPipes = new Vector.<TelePipe>();
			allGates = new Vector.<Gate>();
			allRayCasts = new Vector.<RayCastObjects>();
			allLasers = new Vector.<RotatingLaser>();
			allRockets = new Vector.<OscRocket>();
			allCannons = new Vector.<Cannon>();
			allClues = new Vector.<Clue>();
			
			//nocorrans = new Array(0, 0, 0, 0, 0, 0);
			nocorrans = new Array(2, 2, 2, 2, 2);
			corresqno = new Array(0, 1, 2, 3, 4);
			request5 = new URLRequest("curanswerd.txt");
			request5.method = URLRequestMethod.POST;
			
			loader5 = new URLLoader(request5);
			loader5.addEventListener(Event.COMPLETE, oncurAnswrdgot);
			loader5.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader5.load(request5);
			
			instr = new levelInstructs();
			STAGE.addChild(instr);
			instr.visible = false;
			
			var cl:closeButton = new closeButton();
			instr.addChild(cl);
			cl.x = STAGE.stageWidth - cl.width / 2 - 10;
			cl.y = cl.height / 2 + 10;
			cl.addEventListener(MouseEvent.CLICK, hideInstructs);
			cl.buttonMode = true;
			
			instrTypo = new instructsText();
			instrTypo.x = STAGE.stageWidth - instrTypo.width/2 -5;
			instrTypo.y = STAGE.stageHeight - instrTypo.height / 2 -5;
			STAGE.addChild(instrTypo);
			instrTypo.addEventListener(MouseEvent.CLICK, showInstructs);
			instrTypo.buttonMode = true;
			//phploaded = true;
			
			//oncurAnswrdgot(null);
			//buildWorld();
		}
		
		public function showInstructs(ev:MouseEvent):void {
			instr.visible = true;
			instrTypo.removeEventListener(MouseEvent.CLICK, showInstructs);
			instrTypo.addEventListener(MouseEvent.CLICK, hideInstructs);
			pauseGame();
			STAGE.setChildIndex(instr, STAGE.numChildren -1);
		}
		
		public function hideInstructs(ev:MouseEvent):void {
			instr.visible = false;
			instrTypo.addEventListener(MouseEvent.CLICK, showInstructs);
			instrTypo.removeEventListener(MouseEvent.CLICK, hideInstructs);
			playGame();
		}
		
		public function oncurAnswrdgot(event):void {
			
			var returndata:URLVariables = new URLVariables(event.target.data);
			var i:int;
			//trace(returndata.curAnswrd);
			phploaded = true;
			
			for(i=0;i<5;i++){
				nocorrans[i] = Number(returndata.curAnswrd.charAt(i));	
			}
			
			numClues = 5;
			
			trace("total clues", numClues);
			phploaded = true;
			buildWorld();
		}
		
		private function buildWorld():void {
			// SPECIFY THE LEFT TOP GRID POINTS OF EACH ELEMENT
			ext = new exitDoor(this, new Point(xml.exit.@x, xml.exit.@y));
			var tf:TextField = new TextField();
			var txtFmt:TextFormat = new TextFormat("verdana", 12, 0, true, false, true);
			var c1:int = 0;
			trace("building world");
			
			if (type == 1) {
				GenConstants.LacunaInstance1 = this;
				for each(var wall in xml.normalworld.staticobjs.staticobj)
				{
					if (wall.@type == "wall")
					{
						trace("making wall.");
						//allWalls.push(new Wall(this, new Point(parseInt(wall.@x), parseInt(wall.@y)), parseInt(wall.@length), parseInt(wall.@dir), (parseInt(wall.@cornerType) == 1) ? true: false, parseInt(wall.@friction), parseInt(wall.@restitution)));
						allWalls.push(new Wall(this, new Point(parseInt(wall.@x), parseInt(wall.@y)), parseInt(wall.@length), parseInt(wall.@height), (parseInt(wall.@isGrassy) == 1 ? true:false), parseInt(wall.@friction), parseInt(wall.@restitution)));
						
						tf = new TextField();
						tf.text = String(c1);
						c1++;
						tf.setTextFormat(txtFmt);
						tf.x = (parseInt(wall.@x)) * GenConstants.unitToPixels;
						tf.y = (parseInt(wall.@y)) * GenConstants.unitToPixels;
						//this.addChild(tf);
					}
					else if (wall.@type == "spike")
					{
						//trace("making killer");
						allKillers.push(new killer(this, new Point(parseFloat(wall.@x), parseFloat(wall.@y)), parseInt(wall.@length), parseInt(wall.@dir), killer.SPIKES, parseInt(wall.@inverted)));
					}
				}
				
				var objs:Object = xml.normalworld.specobjs.specobj;
				for each(var spec in objs)
				{
					if (spec.@type == "man") {
						trace("mN 1");
						if (man == null) {
							//trace("making man");
							man = new Man(this, new Point(parseInt(spec.@x), parseInt(spec.@y)), parseFloat(spec.@length), parseFloat(spec.@width), parseFloat(spec.@friction), parseFloat(spec.@restitution), parseFloat(spec.@density), parseFloat(spec.@jumpImpulse), 1);
						}
					}
					else if (spec.@type == "switch_gate") {
						//trace("gate switch created");
						//allRayCasts.push(new Switch(this, parseInt(spec.@id), new Point(parseInt(spec.@x), parseInt(spec.@y)), Switch.GATE_SWITCH, spec.@gatesLinked, parseInt(spec.@closeDelay)));
						// gatesLinked are the ids of the gates that toggle by this switch
						// format: 1,2,3 ...
					}
					else if (spec.@type == "switch_flip") {
						//trace("flip switch created");
						//allRayCasts.push(new Switch(this, parseInt(spec.@id), new Point(parseInt(spec.@x), parseInt(spec.@y)), Switch.FLIP_SWITCH, null, 0));
					}
					else if (spec.@type == "rot_laser") {
						//trace("laser created");
						var tmp:RotatingLaser = new RotatingLaser(this,  new Point(parseInt(spec.@startx), parseInt(spec.@starty)), new Point(parseInt(spec.@endx), parseInt(spec.@endy)), parseFloat(spec.@minAngle), parseFloat(spec.@maxAngle), parseInt(spec.@auto), parseInt(spec.@delay))
						allRayCasts.push(tmp);
						allLasers.push(tmp);
						// auto = 1  ==>   auto-rotate
						// auto = 0  ==>   don't auto-rotate
					}
					else if (spec.@type == "box") {
						//trace("box created");
						trace("boxFric", parseFloat(spec.@friction));
						//allBoxes.push(new Box1(this, new Point(parseInt(spec.@x), parseInt(spec.@y)), parseFloat(spec.@width), parseFloat(spec.@height), parseFloat(spec.@friction)));
					}
					else if (spec.@type == "pipe") {
						allPipes.push(new TelePipe(this,  new Point(parseInt(spec.@x), parseInt(spec.@y)), new Point(parseInt(spec.@destx), parseInt(spec.@desty)), parseInt(spec.@dir), parseInt(spec.@typeSD), parseInt(spec.@id), parseInt(spec.@connectedTo)));
						// id  ==>  id of the pipe
						// connectedTo  ==>  id of the destination pipe
					}
					else if (spec.@type == "gate") {
						allGates.push(new Gate(this, new Point(parseInt(spec.@x), parseInt(spec.@y)), parseInt(spec.@id), parseInt(spec.@dir), parseInt(spec.@closeDelay)));
					}
					else if (spec.@type == "rocket") {
						allRockets.push(new OscRocket(this, new Point(parseInt(spec.@startx), parseInt(spec.@starty)), new Point(parseInt(spec.@endx), parseInt(spec.@endy)), parseInt(spec.@dir), parseInt(spec.@vel)));
					}
					else if (spec.@type == "cannon") {
						allCannons.push(new Cannon(this, new Point(parseInt(spec.@x), parseInt(spec.@y)), parseFloat(spec.@impulse), parseFloat(spec.@width), parseFloat(spec.@height), parseInt(spec.@dir)));
					}
					else if (spec.@type == "clue") {
						allClues.push(new Clue(this, new Point(parseInt(spec.@x), parseInt(spec.@y)), parseInt(spec.@qNo), 3, btArr));
					}
					
				}
				
				/*rotTf = new TextField();
				var txtFmt:TextFormat = new TextFormat("Segoe UI", 25, 0, true, false);
				rotTf.text = String(countRotations);
				rotTf.x = -80;
				rotTf.y = -235;
				rotTf.setTextFormat(txtFmt);*/
				//rgtPanel.addChild(rotTf);
				
				if (phploaded)
				{
					var k:uint = 0;
					for each(var clue in xml.clues.clue)
					{
						//curLevel = parseInt(clue.@level);
						//if (nocorrans[k] != 2) {
							//l1p.newClue(parseInt(clue.@x), parseInt(clue.@y), new String(clue.@shapetype), new String(clue.@shapecolor), parseInt(clue.@questionno), new String(clue.@link), new String(clue.@speed));
							//l1p.newClue(parseInt(clue.@x), parseInt(clue.@y), new String(clue.@shapetype), new String(clue.@shapecolor), parseInt(clue.@questionno), new String(clue.@link), new String(clue.@speed), new String(clue.@startdirection));
							//allClues.push(new ClueButton(this, clue.@image, new Point(parseFloat(clue.@x), parseFloat(clue.@y)), k, parseInt(clue.@level)));
							//cluMenu.addClue(btArr, parseInt(clue.@questionno), nocorrans[k]);
							trace("clue put");
						//}
						k++;
					}
				}
				
				STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
				STAGE.addEventListener(Event.ENTER_FRAME, update);
				
				
				
				rst = new restartMc();
				STAGE.addChild(rst);
				rst.y = rst.height / 2;
				rst.x = rst.width / 2 + 5;
				rst.addEventListener(MouseEvent.CLICK, refreshLevel);
				Sprite(rst).buttonMode = true;
				
				TweenLite.delayedCall(1, bringToFront);
				TweenLite.to(this, 0, { scaleX:1, scaleY:1, scrollRect: { x: 0, y:0, width: STAGE.stageWidth*0.7, height: STAGE.stageHeight}, ease: Cubic.easeOut } );
				
				var i:int;
				for (i = 0; i < 5; i++) {
					if (nocorrans[i] == 1) {
						//cluMenu.activateClue(corresqno[i]);
					}
					else if (nocorrans[i] == 2) {
						//cluMenu.markSeen(corresqno[i]);
					}
				}
			}
			else {
				c1 = 0;
				GenConstants.LacunaInstance2 = this;
				for each(var wall in xml.mirrorworld.staticobjs.staticobj)
				{
					if (wall.@type == "wall")
					{
						trace("making wall.");
						allWalls.push(new Wall(this, new Point(12 + parseInt(wall.@x), parseInt(wall.@y)), parseInt(wall.@length), parseInt(wall.@height), (parseInt(wall.@isGrassy) == 1 ? true:false), parseInt(wall.@friction), parseInt(wall.@restitution)));
						
						tf = new TextField();
						tf.text = String(c1);
						c1++;
						tf.setTextFormat(txtFmt);
						tf.x = (12 + parseInt(wall.@x)) * GenConstants.unitToPixels;
						tf.y = (parseInt(wall.@y)) * GenConstants.unitToPixels;
						//this.addChild(tf);
					}
					else if (wall.@type == "spike")
					{
						allKillers.push(new killer(this, new Point(12 + parseFloat(wall.@x), parseFloat(wall.@y)), parseInt(wall.@length), parseInt(wall.@dir), killer.SPIKES, parseInt(wall.@inverted)));
					}
				}
				
				var objs:Object = xml.mirrorworld.specobjs.specobj;
				for each(var spec in objs)
				{
					if (spec.@type == "man") {
						trace("mN 1");
						if (man == null) {
							man = new Man(this, new Point(12 + parseInt(spec.@x), parseInt(spec.@y)), parseFloat(spec.@length), parseFloat(spec.@width), parseFloat(spec.@friction), parseFloat(spec.@restitution), parseFloat(spec.@density), parseFloat(spec.@jumpImpulse), 2);
						}
					}
					else if (spec.@type == "switch_gate") {
						//trace("gate switch created");
						//allRayCasts.push(new Switch(this, parseInt(spec.@id), new Point(parseInt(spec.@x), parseInt(spec.@y)), Switch.GATE_SWITCH, spec.@gatesLinked, parseInt(spec.@closeDelay)));
						// gatesLinked are the ids of the gates that toggle by this switch
						// format: 1,2,3 ...
					}
					else if (spec.@type == "switch_flip") {
						//trace("flip switch created");
						//allRayCasts.push(new Switch(this, parseInt(spec.@id), new Point(parseInt(spec.@x), parseInt(spec.@y)), Switch.FLIP_SWITCH, null, 0));
					}
					else if (spec.@type == "rot_laser") {
						//trace("laser created");
						var tmp:RotatingLaser = new RotatingLaser(this,  new Point(parseInt(spec.@startx), parseInt(spec.@starty)), new Point(parseInt(spec.@endx), parseInt(spec.@endy)), parseFloat(spec.@minAngle), parseFloat(spec.@maxAngle), parseInt(spec.@auto), parseInt(spec.@delay))
						allRayCasts.push(tmp);
						allLasers.push(tmp);
						// auto = 1  ==>   auto-rotate
						// auto = 0  ==>   don't auto-rotate
					}
					else if (spec.@type == "box") {
						//trace("box created");
						trace("boxFric", parseFloat(spec.@friction));
						//allBoxes.push(new Box1(this, new Point(parseInt(spec.@x), parseInt(spec.@y)), parseFloat(spec.@width), parseFloat(spec.@height), parseFloat(spec.@friction)));
					}
					else if (spec.@type == "pipe") {
						allPipes.push(new TelePipe(this,  new Point(parseInt(spec.@x), parseInt(spec.@y)), new Point(parseInt(spec.@destx), parseInt(spec.@desty)), parseInt(spec.@dir), parseInt(spec.@typeSD), parseInt(spec.@id), parseInt(spec.@connectedTo)));
						// id  ==>  id of the pipe
						// connectedTo  ==>  id of the destination pipe
					}
					else if (spec.@type == "gate") {
						allGates.push(new Gate(this, new Point(parseInt(spec.@x), parseInt(spec.@y)), parseInt(spec.@id), parseInt(spec.@dir), parseInt(spec.@closeDelay)));
					}
					else if (spec.@type == "rocket") {
						allRockets.push(new OscRocket(this, new Point(12 + parseInt(spec.@startx), parseInt(spec.@starty)), new Point(12 + parseInt(spec.@endx), parseInt(spec.@endy)), parseInt(spec.@dir), parseInt(spec.@vel)));
					}
					else if (spec.@type == "cannon") {
						allCannons.push(new Cannon(this, new Point(12 + parseInt(spec.@x), parseInt(spec.@y)), parseFloat(spec.@impulse), parseFloat(spec.@width), parseFloat(spec.@height), parseInt(spec.@dir)));
					}
					else if (spec.@type == "clue") {
						allClues.push(new Clue(this, new Point(12 + parseInt(spec.@x), parseInt(spec.@y)), parseInt(spec.@qNo), 3, btArr));
					}
				}
				
				if (phploaded)
				{
					var k:uint = 0;
					for each(var clue in xml.clues.clue)
					{
						//curLevel = parseInt(clue.@level);
						//if (nocorrans[k] != 2) {
							//l1p.newClue(parseInt(clue.@x), parseInt(clue.@y), new String(clue.@shapetype), new String(clue.@shapecolor), parseInt(clue.@questionno), new String(clue.@link), new String(clue.@speed));
							//l1p.newClue(parseInt(clue.@x), parseInt(clue.@y), new String(clue.@shapetype), new String(clue.@shapecolor), parseInt(clue.@questionno), new String(clue.@link), new String(clue.@speed), new String(clue.@startdirection));
							//allClues.push(new ClueButton(this, clue.@image, new Point(parseFloat(clue.@x), parseFloat(clue.@y)), k, parseInt(clue.@level)));
							//cluMenu.addClue(btArr, parseInt(clue.@questionno), nocorrans[k]);
							trace("clue put");
						//}
						k++;
					}
				}
				
				STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
				STAGE.addEventListener(Event.ENTER_FRAME, update);
				
				
				
				TweenLite.to(this, 0, { scaleX:1, scaleY:1, scrollRect: { x: 0, y:0, width: STAGE.stageWidth*0.5, height: STAGE.stageHeight}, ease: Cubic.easeOut } );
				//STAGE.setChildIndex(rgtPanel, STAGE.numChildren -1);
				
				var i:int;
				for (i = 0; i < 5; i++) {
					if (nocorrans[i] == 1) {
						//cluMenu.activateClue(corresqno[i]);
					}
					else if (nocorrans[i] == 2) {
						allClues[i].markAnswered();
					}
				}
				
				var spr:Sprite = new Sprite();
				spr.graphics.beginFill(0, 1);
				spr.graphics.drawRect(STAGE.stageWidth/2, 0, 10, stage.stageHeight);
				spr.graphics.endFill();
				Lacuna.STAGE.addChild(spr);
			}
		}
			
		
		
		/*private function l1pMouseOver(e:MouseEvent):void {
			TweenLite.to(l1pContainer, 0.5, { alpha:1 } );
		}
		
		private function l1pMouseOut(e:MouseEvent):void {
			TweenLite.to(l1pContainer, 0.5, { alpha:0.75 } );
		}*/
		
		/*function rot():void {
			l1p.rotatePipe(Math.random()*5);
			//TweenLite.delayedCall(3, rot);
		}*/
		
		private function createBoundingWalls():void {
			var bodyDef:b2BodyDef = new b2BodyDef();
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			var bodyFixDef:b2FixtureDef = new b2FixtureDef();
			var bd:b2Body ;
			
			new Wall(this, new Point( -1, 0), GenConstants.getHeightUnits(), 1, false, 1, 0.7);
			new Wall(this, new Point( 0, -1), GenConstants.getWidthUnits()*2, 0, false, 1, 0.7);
			new Wall(this, new Point( GenConstants.getWidthUnits(), 0), GenConstants.getHeightUnits(), 1, false, 1, 0.7);
			new Wall(this, new Point( 0, GenConstants.getHeightUnits()), GenConstants.getWidthUnits()*2, 0, false, 1, 0.7);
		}
		
		private function update(e:Event) {
			//trace("updating");
			if (type == 1) {
				GenConstants.LacWorld.Step(1/30, 10, 10);
				GenConstants.LacWorld.ClearForces();
				//GenConstants.LacWorld.DrawDebugData();
				GenConstants.LacWorld.SetContactListener(new LacunaContactListener());
			}
			
			for each(var rc:RayCastObjects in allRayCasts) {
				rc.createRayCast();
			}
			
			for each(var rckt:OscRocket in allRockets) {
				OscRocket(rckt).updateNow();
			}
			
			for each(var cn:Cannon in allCannons) {
				Cannon(cn).updateNow();
			}
			
			for each(var cl:Clue in allClues) {
				cl.createRayCast();
			}
			
			ext.createRayCast();
			
			for each(var bx:Box1 in allBoxes) {
				bx.updateNow();
			}
			
			if (manUpdate) {
				man.updateNow();
			}
			
			man.childSpecificUpdating();
			if (!man.isPaused) {
				toggleView(man.getBody().GetWorldCenter());
			}
			else {
				//toggleView(specPoint);
			}
		}
		
		private function bringToFront():void {
			//STAGE.setChildIndex(rgtPanel, STAGE.numChildren -1);
			STAGE.setChildIndex(rst, STAGE.numChildren -1);
			STAGE.setChildIndex(instrTypo, STAGE.numChildren -1);
			STAGE.focus = STAGE;
		}
		
		private function moveView():void {
			if (!worldView)
				return;
			manX = man.getBody().GetPosition().x * GenConstants.RATIO;
			manY = man.getBody().GetPosition().y * GenConstants.RATIO;
			var delX:Number = manX - manPrevX;
			var delY:Number = manY - manPrevY;
			if(((manX + halfStageW) <= this.width) && ((manX - halfStageW) >= 0)) {
				this.x -= delX;
			}
			
			if(((manY + halfStageH) <= this.height) && ((manY - halfStageH) >= 0)) {
				this.y -= delY;
			}
			
			manPrevX = manX;
			manPrevY = manY;
		}
		
		private function setDebug():void {
			var debugDraw:b2DebugDraw = new b2DebugDraw();
            var debugSprite:Sprite = new Sprite();
            addChild(debugSprite);
            debugDraw.SetSprite(debugSprite);
            debugDraw.SetDrawScale(GenConstants.RATIO);
            debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
            debugDraw.SetFillAlpha(0.5);
            //GenConstants.LacWorld.SetDebugDraw(debugDraw);
		}
		
		public function getManInstance():Man {
			return man;
		}
		
		public function toggleSwitch(id:int):void {
			
		}
		
		public function updateGates():void {
			for each (var gt in allGates) {
				Gate(gt).updateNow();
			}
		}
		
		private function key_down(e:KeyboardEvent):void 
		{
			/*if (e.keyCode == 99 || e.keyCode == 67) {
				trace("rotateAnti");
				if (canRotate && countRotations > 0) {
					rotateWorld();
				}
			}
			if (e.keyCode == 118 || e.keyCode == 86) {
				trace("rotateClock");
				if (canRotate && countRotations > 0) {
					rotateWorld2();
				}
			}*/
			if (e.keyCode == 77 || e.keyCode == 109) {
				if (worldView == false) 
					setKeyListener();
					
				worldView = !worldView;
				//toggleView();
			}
			/*if (e.keyCode == 80) {
				// Toggle view of pipe maze network
				TweenLite.to(l1pContainer, 0.75, { alpha:0.75 } );
				if(!hideCalled) {
					TweenLite.delayedCall(7.5, hidePipeMze);
					hideCalled = true;
				}
			}*/
		}
		
		/*private function hidePipeMze():void {
			TweenLite.to(l1pContainer, 2.5, { alpha:0 } );
			hideCalled = false;
		}*/
		
		public function allowRotate(val:Boolean):void 
		{
			canRotate = val;
		}
		
		public function rotateWorld():void {
			GenConstants.LacWorld.SetGravity(new b2Vec2(0, 0));
			man.getBody().SetAngle(man.getBody().GetAngle() + Math.PI / 2);
			man.setCanJump(false);
			//man.allowHorizontal(false);
			canRotate = false;
			decRotation();
			
			TweenLite.delayedCall(1, resetGravity);
		}
		
		public function rotateWorld2():void {
			GenConstants.LacWorld.SetGravity(new b2Vec2(0, 0));
			man.getBody().SetAngle(man.getBody().GetAngle() - Math.PI / 2);
			man.setCanJump(false);
			canRotate = false;
			decRotation();
			
			TweenLite.delayedCall(1, resetGravity2);
		}
		
		private function decRotation():void 
		{
			countRotations--;
			var txtFmt:TextFormat = new TextFormat("Segoe UI", 25, 0, true, false);
			rotTf.text = String(countRotations);
			rotTf.setTextFormat(txtFmt);
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
			man.jumpAdj(GenConstants.LacunaInstance.getGravDir());
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
			man.jumpAdj(GenConstants.LacunaInstance.getGravDir());
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
		
		public function toggleView(pt:b2Vec2):void {
				
			if (worldView) {
				var originX:Number = 0;
				var originY:Number = 0
				//var pt:b2Vec2 = man.getBody().GetWorldCenter();
				
				if (pt.x < 380 / GenConstants.RATIO) {
					originX = 0;
				}
				/*else if (pt.x > 800 / GenConstants.RATIO) {
					originX = 500;
				}*/
				else {
					originX = pt.x * GenConstants.RATIO - 300;
				}
				
				if (pt.y < 300 / GenConstants.RATIO) {
					originY = 0;
				}
				else if (pt.y > 700 / GenConstants.RATIO) {
					originY = 500;
				}
				else {
					originY = pt.y * GenConstants.RATIO - 300;
				}
				
				TweenLite.to(this, 1, { scaleX:1, scaleY:1, scrollRect: { x: originX, y:originY, width: STAGE.stageWidth*0.5, height: STAGE.stageHeight}, ease: Cubic.easeOut } );
			}
			else {
				if (type == 1) {
					TweenLite.to(this, 1, { scaleX: (STAGE.stageWidth * 0.5 / (GenConstants.getLevelWidth())), scaleY:(STAGE.stageHeight / (GenConstants.getLevelHeight())), ease: Cubic.easeOut, scrollRect: { x:0, y:0, width:GenConstants.getLevelWidth() + 20, height:GenConstants.getLevelHeight() + 20 } } );
				}
				else {
					TweenLite.to(this, 1, { scaleX: (STAGE.stageWidth * 0.5 / (GenConstants.getLevelWidth())), scaleY:(STAGE.stageHeight / (GenConstants.getLevelHeight())), ease: Cubic.easeOut, scrollRect: { x:12*GenConstants.unitToPixels, y:0, width:GenConstants.getLevelWidth() + 20, height:GenConstants.getLevelHeight() + 20 } } );
				}
				//resetManListeners();
			}
		}
		
		private function setKeyListener():void 
		{
			if (inCannon == false) {
				man.resetListener();
			}
		}
		
		private function resetManListeners():void 
		{
			man.removeListener();
		}
		
		public function endGame():void {
			//l1p.stopClues();
			blackRect = new Sprite();
			blackRect.graphics.beginFill(0, 0.5);
			blackRect.graphics.drawRect(0, 0, STAGE.stageWidth, STAGE.stageHeight);
			blackRect.graphics.endFill();
			STAGE.addChild(blackRect);
			
			tryAg = new tryAgainMc();
			STAGE.addChild(tryAg);
			tryAg.x = STAGE.stageWidth / 2;
			tryAg.y = STAGE.stageHeight / 2;
			tryAg.addEventListener(MouseEvent.CLICK, refreshLevel);
			Sprite(tryAg).buttonMode = true;
			
			/*for each (var ls:RotatingLaser in allLasers) {
				ls.pauselaser();
			}*/
			
			STAGE.removeEventListener(Event.ENTER_FRAME, update);
			man.stopMotion();
		}
		
		public function pauseGame():void {
			trace("game paused");
			/*if (l1p != null) {
				l1p.stopClues();
			}*/
			/*for each (var ls:RotatingLaser in allLasers) {
				ls.pauselaser();
			}*/
			STAGE.removeEventListener(Event.ENTER_FRAME, update);
			man.removeListener();
			STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
		}
		
		public function playGame():void {
			//l1p.sendClues();
			/*for each (var ls:RotatingLaser in allLasers) {
				ls.playLaser();
			}*/
			STAGE.addEventListener(Event.ENTER_FRAME, update);
			man.resetListener();
			STAGE.focus = STAGE;
			STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
		}
		
		public function toggleGate(id:int) {
			allGates[id].toggleState();
		}
		
		/*public function togglePipes(id:int):void {
			l1p.rotatePipe(id);
			trace("rotate pipe:", id);
		}*/
		public function autoMapStart(id:int):void {
			//pauseGame();
			//specPoint = allGates[id].getPosition();
			man.removeListener();
			//worldView = false;
			
			//TweenLite.to(this, 1, { scaleX:1, scaleY:1, scrollRect: { x: ((allGates[id].getPosition().x-300)>0) ? allGates[id].getPosition().x-300 : 0, y:((allGates[id].getPosition().y-300)>0) ? allGates[id].getPosition().y-300 : 0, width: STAGE.stageWidth*0.7, height: STAGE.stageHeight}, ease: Cubic.easeOut } );
			
			TweenLite.delayedCall(2, autoMapEnd);
		}
		
		private function autoMapEnd():void 
		{
			worldView = true;
			
			setKeyListener();
		}
		
		public function canExit():Boolean {
			var i:int;
			if (man.canExit()) {
				for (i = 0; i < numClues; i++) {
					if (nocorrans[i] != 2) {
						return false;
					}
				}
				return true;
			}
			return false;
		}
		
		public function changeLevel():void {
			trace("level exit.");
			var i:int = 0;
			
			for (i = 0; i < numClues; i++) {
				if (nocorrans[i] != 2)
					return;
			}
			if (i == 5)
			{
				variables = new URLVariables();
				request = new URLRequest("anscheck.php");
				request.method=URLRequestMethod.POST;
				checkAns();
			}
		}
		
		var loader:URLLoader;
		
		private function checkAns():void {
			variables.QNo = 6;
			variables.Ansgiven = "nihavsoumy";
			variables.curLevel = CUR_LEVEL;
			request.data = variables;
			loader=new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onAnschecked);
			loader.dataFormat=URLLoaderDataFormat.VARIABLES;
			loader.load(request);
		}
		
		function onAnschecked(event:Event) {
			var returndata:URLVariables=new URLVariables(event.target.data);
			if (returndata.checkans=="true") {
				navigateToURL(new URLRequest("main.php"), "_self"); 
			}
		}
		
		public function refreshLevel(ev:MouseEvent):void {
			trace("restarting level...");
			//l1p.stopClues();
			
			for each(var obj1:Box1 in allBoxes) {
				obj1.destruct(this);
			}
			for each(var obj2:Wall in allWalls) {
				obj2.destruct(this);
			}
			for each(var obj3:killer in allKillers) {
				obj3.destruct(this);
			}
			for each(var obj4:Gate in allGates) {
				obj4.destruct(this);
			}
			for each(var obj5:TelePipe in allPipes) {
				obj5.destruct(this);
			}
			man.destruct(this);
			STAGE.removeEventListener(Event.ENTER_FRAME, update);
			
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			//Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_UP, key_up);
			
			rst.removeEventListener(MouseEvent.CLICK, refreshLevel);
			instrTypo.removeEventListener(MouseEvent.CLICK, showInstructs);
			instrTypo.removeEventListener(MouseEvent.CLICK, hideInstructs);
			
			//STAGE.removeChild(rst);
			/*while (STAGE.numChildren > 0) {
				//var obj:DisplayObject = STAGE.getChildAt(0);
				STAGE.removeChildAt(0);
			}*/
			//STAGE.removeChild(rgtPanel);
			STAGE.removeChild(rst);
			if (tryAg != null) {
				STAGE.removeChild(blackRect);
				STAGE.removeChild(tryAg);
			}
			//cluMenu.removeAnsBox();
			restartF();
		}
		
		public function updateAns(id:int, status:int):void {
			trace("trace updated:", id, status);
			nocorrans[id] = status;
		}
		
		/*public function addClueToMenu(btArr:Vector.<BitmapData>, qNo:int):void {
			trace("adding clue to menu");
			cluMenu.addClue(btArr, qNo, );
		}*/
		
		public function activateClue(qNo:int):void {
			//cluMenu.activateClue(qNo);
			//l1p.resetRotatingPipes();
		}
		
		public function getClueState(id:int):int {
			trace("state", nocorrans[0], nocorrans[1], nocorrans[2], nocorrans[3], nocorrans[4])
			return nocorrans[id];
		}
		
		public function activateCannon():void {
			if (man.canGoInside) {
				man.getCannon().activate();
				man.goInvi();
				GenConstants.LacunaInstance1.getManInstance().removeListener();
				GenConstants.LacunaInstance2.getManInstance().removeListener();
				manUpdate = false;
				inCannon = true;
				man.getBody().SetAwake(false);
				GenConstants.LacWorld.SetGravity(new b2Vec2(0, 0));
			}
		}
		
		public function shootMan(theta:Number, pos:b2Vec2, len:Number):void {
			trace("man shall shoot", len);
			man.goVisi();
			var mp:Point = new Point(pos.x * GenConstants.RATIO, pos.y * GenConstants.RATIO);
			trace("cannon pos:", mp.x, mp.y);
			theta = (theta * 180 / Math.PI) % 360;
			//var theta:Number = (_body.GetAngle() * 180 / Math.PI) % 360;
			if (theta > 180 && theta < 360) {
				theta = -(360 - theta);
			}
			else if (theta < -180 && theta > - 360) {
				theta = 360 + theta;
			}
			//theta += 90;
			var velVec:b2Vec2 = new b2Vec2(0, 0);
			
			if (theta >= 0 && theta <= 90) {
				theta = toRad(theta);
				mp.add(new Point(len * Math.cos(theta), len* Math.sin(theta)));
				velVec = new b2Vec2((GenConstants.CANNON_IMPULSE * Math.sin(theta)), (-GenConstants.CANNON_IMPULSE * Math.cos(theta)));
			}
			else if (theta > 90 && theta <= 180) {
				theta -= 90;
				theta = toRad(theta);
				trace(theta);
				mp.add(new Point(len * Math.sin(theta), len * Math.cos(theta)));
				velVec = new b2Vec2((GenConstants.CANNON_IMPULSE * Math.cos(theta)), (GenConstants.CANNON_IMPULSE * Math.sin(theta)));
			}
			else if (theta < 0 && theta >= -90) {
				theta = -theta;
				theta = toRad(theta);
				trace(theta);
				mp.add(new Point(len * Math.sin(theta), -len * Math.cos(theta)));
				velVec = new b2Vec2((-GenConstants.CANNON_IMPULSE * Math.sin(theta)), (-GenConstants.CANNON_IMPULSE * Math.cos(theta)));
			}
			else if (theta < -90 && theta >= -180) {
				theta = -(theta + 90);
				theta = toRad(theta);
				trace(theta);
				mp.add(new Point(-len * Math.sin(theta), -len * Math.cos(theta)));
				velVec = new b2Vec2(-GenConstants.CANNON_IMPULSE * Math.cos(theta), GenConstants.CANNON_IMPULSE * Math.sin(theta));
			}
			
			trace("man pos:", mp.x, mp.y);
			var manp:b2Vec2 = new b2Vec2(mp.x / GenConstants.RATIO, mp.y / GenConstants.RATIO);
			
			trace(man.getBody().GetPosition().x, man.getBody().GetPosition().y);
			//man.getBody().SetPosition(manp);
			trace("imp", velVec.x, velVec.y);
			manUpdate = true;
			GenConstants.LacunaInstance1.getManInstance().resetListener();
			GenConstants.LacunaInstance2.getManInstance().resetListener();
			man.getBody().ApplyImpulse(velVec, man.getBody().GetWorldCenter());
			man.getBody().SetAwake(true);
			//man.resetListener();
			inCannon = false;
			GenConstants.LacWorld.SetGravity(new b2Vec2(0, 10));
		}
		
		private function toRad(theta:Number):Number 
		{
			theta = theta * Math.PI/180;
			return theta;
		}
		
	}
}
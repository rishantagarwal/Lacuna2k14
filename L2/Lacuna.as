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
	import com.greensock.plugins.ScrollRectPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
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
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class Lacuna extends Sprite
	{
		private var allRayCasts:Vector.<Vector.<RayCastObjects>>;
		private var allBoxes:Vector.<Vector.<Box1>>;
		private var allPipes:Vector.<Vector.<TelePipe>>;
		private var allGates:Vector.<Vector.<Gate>>;
		private var allwalls:Vector.<Vector.<Wall>>;
		private var allKillers:Vector.<Vector.<killer>>;
		private var allTurtles:Vector.<Vector.<turtle>>;
		private var boxCount:int;
		public static var STAGE:Stage = null;
		private var shuffleOrder:Array;
		private var xml:XML;
		private var worldView:Boolean;
		private var wid:int;
		private var hei:int;
		private var man:Man;
		private var chBut:makeBt;
		private var rck:Rocket;
		private var gamMode:int = 1;
		private var turtUpdate:Boolean = true;
		private var allRocks:Vector.<Vector.<Box1>>;
		private var blackRect:Sprite;
		private var tryAg:tryAgainMc;
		private var instrTypo:instructsText;
		private var rst:restartMc;
		private var phb:pushButton;
		private var instr:levelInstructs;
		private var allbWalls:Vector.<Vector.<BreakableWall>>;
		private var nocorrans:Array;
		private var corresqno:Array;
		private var request5:URLRequest;
		private var loader5:URLLoader;
		private var phploaded:Boolean;
		private var variables:URLVariables;
		private var request:URLRequest;
		private var btArr:Vector.<BitmapData>;
		private var restartF:Function;
		private var numClues:int;
		private var allClues:Vector.<Vector.<Clue>>;
		private var newRocketFlag:Boolean;
		private var ammo:int;
		private var ext:exitDoor;
		private var allCluesRef:Vector.<Clue>;
		
		public function Lacuna(xml:XML, st:Stage, restartF:Function, btArr:Vector.<BitmapData>) 
		{
			this.restartF = restartF;
			this.xml = xml;
			this.btArr = btArr;
			STAGE = st;
			
			worldView = true;
			boxCount = parseInt(xml.prop.@boxCount);
			wid = parseInt(xml.prop.@width);
			hei = parseInt(xml.prop.@height);
			
			GenConstants.BOX_HEIGHT = parseInt(xml.prop.@boxHeight);
			GenConstants.BOX_WIDTH = parseInt(xml.prop.@boxWidth);
			
			GenConstants.levelWidth = wid * GenConstants.BOX_WIDTH;
			GenConstants.levelHeight = hei * GenConstants.BOX_HEIGHT;
			
			// INITIATE THE WORLD
			GenConstants.LacWorld = new b2World(new b2Vec2(parseInt(xml.gravity.@x),parseInt(xml.gravity.@y)), true);
			TweenPlugin.activate([ScrollRectPlugin]);
			
			// CREATE THE BOUNDARY OF THE WORLD
			//trace("w", GenConstants.levelWidth, "h", GenConstants.levelHeight);
			
			nocorrans = new Array(2, 2, 2, 2, 2);
			corresqno = new Array(0, 1, 2, 3, 4);
			request5 = new URLRequest("curanswerd.txt");
			request5.method = URLRequestMethod.POST;
			
			loader5 = new URLLoader(request5);
			loader5.addEventListener(Event.COMPLETE, oncurAnswrdgot);
			loader5.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader5.load(request5);
		}
		
		public function oncurAnswrdgot(event):void {
			
			var returndata:URLVariables = new URLVariables(event.target.data);
			var i:int;
			
			for(i=0;i<5;i++){
				nocorrans[i] = Number(returndata.curAnswrd.charAt(i));	
			}
			
			numClues = 5;
			buildWorld();
		}
		
		private function buildWorld():void 
		{
			allwalls = new Vector.<Vector.<Wall>>(boxCount, true);
			allTurtles = new Vector.<Vector.<turtle>>(boxCount, true);
			allBoxes = new Vector.<Vector.<Box1>>(boxCount, true);
			allbWalls = new Vector.<Vector.<BreakableWall>>(boxCount, true);
			shuffleOrder = String(xml.prop.@order).split(",");
			allClues = new Vector.<Vector.<Clue>>();
			
			createBoundingWalls();
			//setDebug();
			
			STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			STAGE.addEventListener(Event.ENTER_FRAME, update);
			
			GenConstants.LacunaInstance = this;
			allCluesRef = new Vector.<Clue>(5, true);
			
			// initialise all the vectors
			var i:int = 0;
			while (i < boxCount) {
				allwalls[i] = new Vector.<Wall>();
				i++;
			}
			// Generate all the boxes
			i = 0;
			while (i < boxCount) {
				makeBox(i, shuffleOrder[i]);
				i++;
			}
			
			// put regen button
			chBut = new makeBt();
			STAGE.addChild(chBut);
			chBut.x = STAGE.stageWidth - 100;
			chBut.y = STAGE.stageHeight - 100;
			chBut.buttonMode = true;
			chBut.addEventListener(MouseEvent.CLICK, showRearranger);
			
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
			
			rst = new restartMc();
			STAGE.addChild(rst);
			rst.y = STAGE.stageHeight - rst.height / 2 - 5;
			rst.x = rst.width / 2 + 5;
			rst.addEventListener(MouseEvent.CLICK, refreshLevel);
			Sprite(rst).buttonMode = true;
			
			TweenLite.delayedCall(1, bringToFront);
			
			var i:int;
			for (i = 0; i < 5; i++) {
				if (nocorrans[i] == 2) {
					if (allCluesRef[i] != null) {
						allCluesRef[i].markAnswered();
					}
				}
			}
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
		
		private function showRearranger(ev:MouseEvent):void {
			pauseGame();
			var gr:Grid = new Grid(wid, hei, xml);
			gr.reOrder(shuffleOrder);
			STAGE.addChild(gr);
			chBut.visible = false;
		}
		
		public function makeBox(boxNo:int, id:int):void {
			var objs:Object;
			
			var dispX:int = GenConstants.BOX_WIDTH * (boxNo % wid);
			var dispY:int = GenConstants.BOX_HEIGHT * int((boxNo / wid));
			
			//trace("wid:", wid, "hei:", hei, dispX, dispY);
			//trace("boxNo", boxNo, "id", id, "dispX", dispX, "dispY", dispY);
			var flags:Array = new Array();
			var count:int = 0;
			var firstTime:Boolean = false;
			
			if (allbWalls[id] == null) {
				firstTime = true;
			}
			else {
				for each(var wl:BreakableWall in allbWalls[id]) {
					flags.push(wl.destroyed);
				}
			}
			
			allwalls[id] = new Vector.<Wall>();
			allTurtles[id] = new Vector.<turtle>();
			allBoxes[id] = new Vector.<Box1>();
			allbWalls[id] = new Vector.<BreakableWall>();
			allClues[id] = new Vector.<Clue>();
			
			switch (id) {
				case 0:
					objs = xml.boxes.box0;
					break;
				case 1:
					objs = xml.boxes.box1;
					break;
				case 2:
					objs = xml.boxes.box2;
					break;
				case 3:
					objs = xml.boxes.box3;
					break;
				case 4:
					objs = xml.boxes.box4;
					break;
				case 5:
					objs = xml.boxes.box5;
					break;
				case 6:
					objs = xml.boxes.box6;
					break;
				case 7:
					objs = xml.boxes.box7;
					break;
				case 8:
					objs = xml.boxes.box8;
					break;
				case 9:
					objs = xml.boxes.box9;
					break;
			}
			var c1:int = 0;
			for each(var spec in objs) {
				var tf:TextField = new TextField();
				var txtFmt:TextFormat = new TextFormat("Verdana", 18, 0, true, false, true);
				if (spec.@type == "clue") {
					if (nocorrans[parseInt(spec.@qNo)] != 2) {
						var cl:Clue = new Clue(this, new Point(dispX + parseInt(spec.@x), dispY + parseInt(spec.@y)), parseInt(spec.@qNo),parseInt(spec.@level), btArr);
						allClues[id].push(cl);
						if (firstTime == true) {
							var qn:int = parseInt(spec.@qNo);
							trace("qn is:", qn);
							allCluesRef[qn] = cl;
						}
					}
				}
				else if (spec.@type == "wall")
				{
					trace("making wall.", dispX, dispY);
					allwalls[id].push(new Wall(this, new Point(dispX + parseInt(spec.@x), dispY +parseInt(spec.@y)), parseInt(spec.@length), parseInt(spec.@height), (parseInt(spec.@isGrassy) == 1 ? true:false), parseInt(spec.@friction), parseInt(spec.@restitution)));
					tf.text = String(c1);
					c1++;
					tf.setTextFormat(txtFmt);
					tf.x = (dispX + parseInt(spec.@x)) * GenConstants.unitToPixels;
					tf.y = (dispY + parseInt(spec.@y)) * GenConstants.unitToPixels;
					//this.addChild(tf);
					trace("wallPos:", id, dispX + parseInt(spec.@x), dispY + parseInt(spec.@y));
				}
				else if (spec.@type == "rocket") {
					rck = new Rocket(this, new Point(dispX + parseFloat(spec.@x), dispY + parseFloat(spec.@y)), GenConstants.DOWN, parseInt(spec.@ammo));
					rck.rotateRck();
					ammo = parseInt(spec.@ammo);
				}
				else if (spec.@type == "turtle") {
					trace("turtle pushed");
					allTurtles[id].push(new turtle(this, new Point(dispX+parseInt(spec.@startX), dispY+parseInt(spec.@startY)), new Point(dispX+parseInt(spec.@endX), dispY+parseInt(spec.@endY)), parseFloat(spec.@vel), parseFloat(spec.@fric), 5/*parseInt(spec.@timeToWake)*/));
					trace("wake:", parseInt(spec.@timeToWake));
				}
				else if (spec.@type == "rock") {
					allBoxes[id].push(new Box1(this, new Point(dispX + parseInt(spec.@x), dispY + parseInt(spec.@y))));
				}
				else if (spec.@type == "pushButton") {
					phb = new pushButton(this, new Point(dispX + parseInt(spec.@x), dispY + parseInt(spec.@y)));
				}
				else if (spec.@type == "bwall") {
					if (firstTime || flags[count++] == false) {
						allbWalls[id].push(new BreakableWall(this, new Point(dispX + parseInt(spec.@x), dispY + parseInt(spec.@y)), parseFloat(spec.@length), parseFloat(spec.@height)));
					}
				}
				else if (spec.@type == "man") {
					if (man == null) {
						trace("making man");
						man = new Man(this, new Point(dispX + parseFloat(spec.@x), dispY + parseFloat(spec.@y)), parseFloat(spec.@length), parseFloat(spec.@width), parseFloat(spec.@friction), parseFloat(spec.@restitution), parseFloat(spec.@density), parseFloat(spec.@jumpImpulse));
					}
				}
				else if (spec.@type == "exit") {
					ext = new exitDoor(this, new Point(dispX + parseFloat(spec.@x), dispY + parseFloat(spec.@y)));
				}
			}
		}
		
		public function rearrangeWorld(newOrder:Array):void {
			// destroy the entire world i.e walls
			
			// actual position in box2d units
			var manPos:b2Vec2 = man.getBody().GetWorldCenter();
			
			// grid position of man
			var manGridPos:Point = new Point(manPos.x * GenConstants.RATIO, manPos.y * GenConstants.RATIO);
			manGridPos.x = Math.floor(manGridPos.x / (GenConstants.BOX_WIDTH * GenConstants.unitToPixels));
			manGridPos.y = Math.floor(manGridPos.y / (GenConstants.BOX_HEIGHT * GenConstants.unitToPixels));
			
			// OFFSET in Pixels from start of current box
			var manOffset:Point = new Point(manPos.x * GenConstants.RATIO - (manGridPos.x * GenConstants.BOX_WIDTH * GenConstants.unitToPixels), manPos.y * GenConstants.RATIO - (manGridPos.y * GenConstants.BOX_HEIGHT * GenConstants.unitToPixels));
			var index:int = wid * manGridPos.y + manGridPos.x;
			var oldBox:int = shuffleOrder[index];
			trace("oldBox", oldBox, "mangridPos", manGridPos.x, manGridPos.y, "order", shuffleOrder);
			
			playGame();
			chBut.visible = true;
			var i:int = 0;
			while (i < boxCount) {
				for each(var wl in allwalls[i]) {
					trace("destBody");
					Wall(wl).destruct(this);
					//GenConstants.LacWorld.DestroyBody(Wall(wl).getBody());
				}
				allwalls[i] = new Vector.<Wall>();
				i++;
			}
			i = 0;
			while (i < boxCount) {
				for each(wl in allBoxes[i]) {
					trace("destBody");
					Box1(wl).destruct(this);
					//GenConstants.LacWorld.DestroyBody(Wall(wl).getBody());
				}
				allBoxes[i] = new Vector.<Box1>();
				i++;
			}
			i = 0;
			while (i < boxCount) {
				for each(wl in allTurtles[i]) {
					trace("destBody");
					turtle(wl).destruct(this);
					//GenConstants.LacWorld.DestroyBody(Wall(wl).getBody());
				}
				allTurtles[i] = new Vector.<turtle>();
				i++;
			}
			i = 0;
			while (i < boxCount) {
				for each(wl in allbWalls[i]) {
					if (BreakableWall(wl).destroyed == true) {
						continue;
					}
					trace("destBody");
					BreakableWall(wl).destruct(this);
					//GenConstants.LacWorld.DestroyBody(Wall(wl).getBody());
				}
				//allbWalls[i] = new Vector.<BreakableWall>();
				i++;
			}
			i = 0;
			while (i < boxCount) {
				for each(wl in allClues[i]) {
					trace("destBody");
					Clue(wl).destruct();
					//GenConstants.LacWorld.DestroyBody(Wall(wl).getBody());
				}
				allClues[i] = new Vector.<Clue>();
				i++;
			}
			
			phb.destruct(this);
			if (rck != null) {
				rck.destruct(this);
			}
			
			ext.destruct();
			//trace("allwalls: ", allwalls);
			// Re-generate the boxes in new position
			i= 0;
			while (i < boxCount) {
				if (newOrder[i] != -1) {
					makeBox(i, newOrder[i]);
					if (newOrder[i] == oldBox) {
						trace("replacing man in", i);
						var newManPos:b2Vec2 = new b2Vec2(((i % wid) * (GenConstants.BOX_WIDTH * GenConstants.unitToPixels) + manOffset.x) / GenConstants.RATIO, (Math.floor(i / wid) * (GenConstants.BOX_HEIGHT * GenConstants.unitToPixels) + manOffset.y) / GenConstants.RATIO);
						man.getBody().SetPosition(newManPos);
					}
				}
				i++;
			}
			shuffleOrder = newOrder;
			//trace("sh order", shuffleOrder);
			STAGE.setChildIndex(chBut, STAGE.numChildren - 1);
			
			var i:int;
			for (i = 0; i < 5; i++) {
				if (nocorrans[i] == 2) {
					trace("reorder answered");
					if (allCluesRef[i] != null) {
						allCluesRef[i].markAnswered();
					}
				}
			}
		}
		
		private function createBoundingWalls():void {
			var bodyDef:b2BodyDef = new b2BodyDef();
			var bodyShape:b2PolygonShape = new b2PolygonShape();
			var bodyFixDef:b2FixtureDef = new b2FixtureDef();
			var bd:b2Body ;
			
			new Wall(this, new Point( -1, 0), 1,GenConstants.getHeightUnits(), false, 1, 0.7);
			new Wall(this, new Point( 0, -1), GenConstants.getWidthUnits(), 1, false, 1, 0.7);
			new Wall(this, new Point( GenConstants.getWidthUnits(), 0), 1, GenConstants.getHeightUnits(), false, 1, 0.7);
			new Wall(this, new Point( 0, GenConstants.getHeightUnits()), GenConstants.getWidthUnits(), 1, false, 1, 0.7);
		}
		
		private function update(e:Event) {
			//trace("updating");
			GenConstants.LacWorld.Step(1/30, 10, 10);
            GenConstants.LacWorld.ClearForces();
            GenConstants.LacWorld.DrawDebugData();
			GenConstants.LacWorld.SetContactListener(new LacunaContactListener());
			
			if (rck != null && rck.isActive) {
				rck.updateNow();
			}
			
			ext.createRayCast();
			
			if (newRocketFlag) {
				newRocket();
			}
			
			var i:int = 0;
			for (i = 0; i < allTurtles.length; i++) {
				for each (var tr:turtle in allTurtles[i]) {
					if (tr.state == 0)  {
						tr.updateNow();
					}
				}
			}
			i = 0;
			for (i = 0; i < allClues.length; i++) {
				for each (var tr2:Clue in allClues[i]) {
					tr2.createRayCast();
				}
			}
			i = 0;
			for (i = 0; i < allBoxes.length; i++) {
				for each (var tr3:Box1 in allBoxes[i]) {
					tr3.updateNow();
				}
			}
			i = 0;
			for (i = 0; i < allbWalls.length; i++) {
				for each (var tr4:BreakableWall in allbWalls[i]) {
					tr4.updateNow();
				}
			}
			
			// rocket = 7 x = 7, y = 2
			// stone = 6 x =2, y = 1
			
			if (man != null) {
				man.updateNow();
			}
			
			toggleView();
		}
		
		private function bringToFront():void {
			STAGE.setChildIndex(rst, STAGE.numChildren -1);
			STAGE.setChildIndex(instrTypo, STAGE.numChildren -1);
			STAGE.setChildIndex(chBut, STAGE.numChildren - 1);
			STAGE.focus = STAGE;
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
		
		private function key_down(e:KeyboardEvent):void 
		{
			if (e.keyCode == 77 || e.keyCode == 109) {
				//toggleView();
				if (worldView == false) 
					setKeyListener();
					
				worldView = !worldView;
			}
			if (e.keyCode == 82 || e.keyCode == 114) {
				if (rck.isActive) {
					return;
				}
				rck.activateRocket(true);
				GenConstants.LacWorld.SetGravity(new b2Vec2(0, 0));
				//pauseGame();
				man.removeListener();
				gamMode = 2;
			}
		}
		
		public function toggleView():void {
			if (worldView) {
				var originX:Number = 0;
				var originY:Number = 0;
				var pt:b2Vec2 = man.getBody().GetWorldCenter();
				//var pt:b2Vec2 = new b2Vec2(0, 0);
				if (pt.x < 380 / GenConstants.RATIO) {
					originX = 0;
				}
				else if (pt.x > 1300 / GenConstants.RATIO) {
					originX = 1200;
				}
				else {
					originX = pt.x * GenConstants.RATIO - 300;
				}
				
				/*if (pt.x > 600 / GenConstants.RATIO) {
					originX = 500;
				}
				if (pt.x > 900 / GenConstants.RATIO) {
					originX = 800;
				}
				if (pt.x > 1200 / GenConstants.RATIO) {
					originX = 1100;
				}*/
				
				/*if (pt.x > 1800 / GenConstants.RATIO) {
					originX = 1700;
				}*/
				/*if (pt.x > 1000) {
					originX = 900;
				}*/
				
				//originX -= 500;
				if (pt.y < 400 / GenConstants.RATIO) {
					originY = 0;
				}
				else if (pt.y > 900 / GenConstants.RATIO) {
					originY = 850;
				}
				else {
					originY = pt.y * GenConstants.RATIO - 300;
				}
				/*if (pt.y > 1000) {
					originY = 900;
				}
				if (pt.y > 650 / GenConstants.RATIO) {
					originY = 550;
				}
				if (pt.y > 800 / GenConstants.RATIO) {
					originY = 700;
				}*/
				//originY -= 300;
				
				TweenLite.to(this, 1, { scaleX:1, scaleY:1, scrollRect: { x: originX, y:originY, width: STAGE.stageWidth, height: STAGE.stageHeight}, ease: Cubic.easeOut } );
			}
			else {
				TweenLite.to(this, 1, { scaleX: (STAGE.stageWidth / GenConstants.getLevelWidth()), scaleY:(STAGE.stageHeight / GenConstants.getLevelHeight()), ease: Cubic.easeOut, scrollRect:{x:0, y:0, width:GenConstants.getLevelWidth(), height:GenConstants.getLevelHeight()} } );
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
		
		/*public function pauseGame():void {
			STAGE.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		public function playGame():void {
			STAGE.addEventListener(Event.ENTER_FRAME, update);
		}*/
		
		public function toggleSwitch(id:int):void 
		{
			
		}
		
		public function toggleGate(array:Array):void 
		{
			
		}
		
		public function togglePipes(id:int):void 
		{
			
		}
		
		public function pauseGame():void {
			//trace("game paused");
			STAGE.removeEventListener(Event.ENTER_FRAME, update);
			man.removeListener();
			STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
		}
		
		public function playGame():void {
			STAGE.addEventListener(Event.ENTER_FRAME, update);
			man.resetListener();
			STAGE.focus = STAGE;
			STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
		}
		
		public function getGravDir():int 
		{
			return GenConstants.DOWN;
		}
		
		public function startTeleport(teleportDest:Point):void 
		{
			
		}
		
		public function stopTurtle():void {
			//turtUpdate = false;
		}
		
		public function startTurtle():void {
			//turtUpdate = true;
		}
		
		public function endGame():void 
		{
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
			
			STAGE.removeEventListener(Event.ENTER_FRAME, update);
			man.stopMotion();
		}
		
		public function refreshLevel(ev:MouseEvent):void {
			trace("restarting level...");
			
			var i:int = 0;
			while (i < boxCount) {
				for each(var wl in allwalls[i]) {
					//trace("destBody");
					Wall(wl).destruct(this);
					//GenConstants.LacWorld.DestroyBody(Wall(wl).getBody());
				}
				//allwalls[i] = new Vector.<Wall>();
				i++;
			}
			i = 0;
			while (i < boxCount) {
				for each(wl in allBoxes[i]) {
					//trace("destBody");
					Box1(wl).destruct(this);
					//GenConstants.LacWorld.DestroyBody(Wall(wl).getBody());
				}
				//allBoxes[i] = new Vector.<Box1>();
				i++;
			}
			i = 0;
			while (i < boxCount) {
				for each(wl in allTurtles[i]) {
					//trace("destBody");
					turtle(wl).destruct(this);
					//GenConstants.LacWorld.DestroyBody(Wall(wl).getBody());
				}
				//allTurtles[i] = new Vector.<turtle>();
				i++;
			}
			i = 0;
			while (i < boxCount) {
				for each(wl in allbWalls[i]) {
					//trace("destBody");
					if (BreakableWall(wl).destroyed == true) {
						continue;
					}
					BreakableWall(wl).destruct(this);
					//GenConstants.LacWorld.DestroyBody(Wall(wl).getBody());
				}
				//allbWalls[i] = new Vector.<BreakableWall>();
				i++;
			}
			i = 0;
			while (i < boxCount) {
				for each(wl in allClues[i]) {
					//trace("destBody");
					Clue(wl).destruct();
					//GenConstants.LacWorld.DestroyBody(Wall(wl).getBody());
				}
				//allClues[i] = new Vector.<Clue>();
				i++;
			}
			
			phb.destruct(this);
			if (rck != null) {
				rck.destruct(this);
			}
			
			man.destruct(this);
			ext.destruct();
			//phb.destruct(this);
			
			STAGE.removeEventListener(Event.ENTER_FRAME, update);
			STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			
			rst.removeEventListener(MouseEvent.CLICK, refreshLevel);
			instrTypo.removeEventListener(MouseEvent.CLICK, showInstructs);
			instrTypo.removeEventListener(MouseEvent.CLICK, hideInstructs);
			
			STAGE.removeChild(chBut);
			STAGE.removeChild(rst);
			if (blackRect != null) {
				STAGE.removeChild(blackRect);
			}
			if (tryAg != null) {
				STAGE.removeChild(tryAg);
			}
			
			restartF();
		}
		
		public function resetRocket():void {
			rck.reset();
			var pos:Point = rck.getPos();
			rck.getBody().SetPosition(new b2Vec2((pos.x) * GenConstants.unitToPixels / GenConstants.RATIO, (pos.y) * GenConstants.unitToPixels / GenConstants.RATIO));
			GenConstants.LacWorld.SetGravity(new b2Vec2(0, 10));
			man.resetListener();
		}
		
		public function destroyRocket():void 
		{
			rck.reset();
			
		}
		
		public function autoMapStart(id:int):void {
			//specPoint = allGates[id].getPosition();
			man.removeListener();
			
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
			trace("checking");
			variables.QNo = 6;
			variables.Ansgiven = "nihavsoumy";
			variables.curLevel = 2;
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
		
		public function updateAns(id:int, status:int):void {
			trace("trace updated:", id, status);
			nocorrans[id] = status;
		}
		
		public function activateClue(qNo:int):void {
			updateAns(qNo, 1);
		}
		
		public function getClueState(id:int):int {
			return nocorrans[id];
		}
		
		public function breakBox2Wall():void {
			var i:int = 0;
			var ind:int;
			
			while (i < boxCount) {
				if (shuffleOrder[i] == 2) {
					ind = i;
				}
				i++;
			}
			
			for each(var wl in allbWalls[ind]) {
				BreakableWall(wl).setDestroyFlag();
			}
			//allbWalls[ind] = null;
		}
		
		public function setNewRocketFlag():void {
			newRocketFlag = true;
		}
		
		public function newRocket():void {
			var rcPos:Point = rck.getPos();
			
					if (ammo > 0) {
						rck.destruct(this);
						newRocketFlag = false;
						rck = new Rocket(this, rcPos, GenConstants.DOWN, ammo);
						rck.rotateRck();
						ammo--;
					}
					else if (ammo == 0) {
						newRocketFlag = false;
						rck.destruct(this);
					}
					GenConstants.LacWorld.SetGravity(new b2Vec2(0, 10));
		
		}
			
		
	}
}
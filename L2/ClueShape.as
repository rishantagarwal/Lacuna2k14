package  {
	import flash.display.Sprite;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import com.greensock.easing.Linear;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class ClueShape {
		
		private var shapeType:String;
		private var shapeColor:String;
		private var clueImage:Sprite;
		private var clueGraphics:Sprite;
		private var currentState:uint;
		private var onScreen:Boolean;
		private var questionNo:uint;
		private var moveDuration:uint;
		private var initialLocation:Point;
		private var fromDirection:String;
		private var originalStartDirection:String;
		private var randomLeftRight:Array;
		private var randomUpDown:Array;

		public function ClueShape(parent:Sprite, link:String, location:Point, questionNo:uint, shapeType:String, shapeColor:String, speed:String, startDirection:String) {
			
			randomLeftRight = [moveLeft, moveRight];
			randomUpDown = [moveUp, moveDown];
			currentState = LacunaConstants.CLUE_NOT_REACHED;
			clueGraphics = Level1Pipes.shapesDictionary[shapeColor + "," + shapeType]();
			this.shapeType = shapeType;
			this.shapeColor = shapeColor;
			
			onScreen = false;
			
			initialLocation = location;
			clueGraphics.x = location.x;
			clueGraphics.y = location.y;
			clueGraphics.visible = false;
			
			parent.addChild(clueGraphics);
			
			if (speed == "fast")
				this.moveDuration = LacunaConstants.CLUE_SPEED_FAST;
			else if (speed == "medium")
				this.moveDuration = LacunaConstants.CLUE_SPEED_MEDIUM;
			else if (speed == "slow")
				this.moveDuration = LacunaConstants.CLUE_SPEED_SLOW;
			
			this.questionNo = questionNo;
			
			clueImage = new Sprite();			
			//var imgLoader:ImageLoader = new ImageLoader(link, 
			//	{ name:"quesimage", container:clueImage, centerRegistration: true} );
			//imgLoader.load();
			
			originalStartDirection = new String(startDirection);
			fromDirection = getOppositeDirection();
		}
		
		private function getOppositeDirection():String {
			if(originalStartDirection == LacunaConstants.LEFT)
				return LacunaConstants.RIGHT;
			if(originalStartDirection == LacunaConstants.RIGHT)
				return LacunaConstants.LEFT;
			if(originalStartDirection == LacunaConstants.UP)
				return LacunaConstants.DOWN;
			if(originalStartDirection == LacunaConstants.DOWN)
				return LacunaConstants.UP;
			return null;
		}
		
		public function get shapetype():String {
			return this.shapeType;
		}
		
		public function get shapecolor():String {
			return this.shapeColor;
		}
		
		public function get state():uint {
			return currentState;
		}
		
		public function set state(state:uint):void {
			this.currentState = state;
		}
		
		public function get onscreen():Boolean {
			return this.onScreen;
		}
		
		public function set onscreen(newVal:Boolean):void {
			this.onScreen = newVal;
			clueGraphics.visible = newVal;
		}
		
		public function get location():Point {
			return new Point(clueGraphics.x, clueGraphics.y);
		}
		
		public function moveClue() {
			var pipe:Pipe = Pipe(Level1Pipes.pipeDictionary[clueGraphics.x + "," + clueGraphics.y]);
			if (pipe == null)
				resetClue();
			else if(pipe.Type == LacunaConstants.PIPE_ROTATABLE)
				moveCaller(RotatingPipe(pipe).Orientation, null);
			else if (pipe.Type == LacunaConstants.PIPE_DESTINATION)
				moveCaller(pipe.Type, DestinationPipe(pipe).expectedshape);
			else
				moveCaller(pipe.Type, null);
		}
		
		private function matchDestination(shapeType:String):void {
			if (this.shapeType == shapeType)
			{
				this.state = LacunaConstants.CLUE_REACHED;
				trace("Reached!");
				resetClue();
				this.onscreen = true;
				; // Call function to pause lacuna
				//Level1Pipes.showQuestion(this);
			}
			else
				resetClue();
		}
		
		private function resetClue():void {
			this.onScreen = false;
			clueGraphics.visible = false;
			clueGraphics.x = initialLocation.x;
			clueGraphics.y = initialLocation.y;
			fromDirection = getOppositeDirection();
		}
		
		public function moveCaller(direction:String, shapeTypeForDest:String) {
			switch(direction) {
				case LacunaConstants.LEFT									:
				case LacunaConstants.RIGHT								:
				case LacunaConstants.PIPE_LEFT_RIGHT		 	: if (fromDirection == LacunaConstants.RIGHT)
																											moveLeft();
																										else if(fromDirection == LacunaConstants.LEFT)
																											moveRight();
																										else
																											randomLeftRight[int(Math.random() * 2)]();
																										break;
				case LacunaConstants.DOWN									:
				case LacunaConstants.UP										:
				case LacunaConstants.PIPE_UP_DOWN 				: if (fromDirection == LacunaConstants.UP)
																											moveDown();
																										else if (fromDirection == LacunaConstants.DOWN)
																											moveUp();
																										else
																											randomUpDown[int(Math.random() * 2)]();
																										break;
				case LacunaConstants.PIPE_DOWN_LEFT 			: if (fromDirection == LacunaConstants.LEFT)
																											moveDown();
																										else
																											moveLeft();
																										break;
				case LacunaConstants.PIPE_DOWN_RIGHT 			: if (fromDirection == LacunaConstants.RIGHT)
																											moveDown();
																										else
																											moveRight();
																										break;
				case LacunaConstants.PIPE_UP_LEFT 				:	if (fromDirection == LacunaConstants.LEFT)
																											moveUp();
																										else
																											moveLeft();
																										break;
				case LacunaConstants.PIPE_UP_RIGHT 				: if (fromDirection == LacunaConstants.RIGHT)
																											moveUp();
																										else
																											moveRight();
																										break;
				case LacunaConstants.PIPE_DESTINATION 		: matchDestination(shapeTypeForDest);
																										break;
				case LacunaConstants.PIPE_EXIT_LEFT				: if (fromDirection != originalStartDirection)
																											moveRight();
																										else
																											moveLeft();
																										break;
				case LacunaConstants.PIPE_EXIT_RIGHT			: if (fromDirection != originalStartDirection)
																											moveLeft();
																										else
																											moveRight();
																										break;
				case LacunaConstants.PIPE_EXIT_DOWN				:	if (fromDirection != originalStartDirection)
																											moveUp();
																										else
																											moveDown();
																										break;
				case LacunaConstants.PIPE_EXIT_UP					: if (fromDirection != originalStartDirection)
																											moveDown();
																										else
																											moveUp();
																										break;
				case LacunaConstants.PIPE_SOURCE          : if (fromDirection != originalStartDirection)
																											moveCaller(originalStartDirection, null);
																										else
																											resetClue();
				default : return;
			}
		}
		
		public function moveRight() {
			trace("Right");
			fromDirection = LacunaConstants.LEFT;
			TweenLite.to(clueGraphics, moveDuration, { x:this.clueGraphics.x + LacunaConstants.CELL_WIDTH, ease:Linear.easeNone, onComplete:moveClue} );
		}
		
		public function moveLeft() {
			trace("Left");
			fromDirection = LacunaConstants.RIGHT;
			TweenLite.to(clueGraphics, moveDuration, { x:this.clueGraphics.x - LacunaConstants.CELL_WIDTH, ease:Linear.easeNone, onComplete:moveClue} );
		}
		
		public function moveUp() {
			trace("Up");
			fromDirection = LacunaConstants.DOWN;
			TweenLite.to(clueGraphics, moveDuration, { y:this.clueGraphics.y - LacunaConstants.CELL_HEIGHT, ease:Linear.easeNone, onComplete:moveClue} );
		}
		
		public function moveDown() {
			trace("Down");
			fromDirection = LacunaConstants.UP;
			TweenLite.to(clueGraphics, moveDuration, { y:clueGraphics.y + LacunaConstants.CELL_HEIGHT, ease:Linear.easeNone, onComplete:moveClue } );
		}
	}
}

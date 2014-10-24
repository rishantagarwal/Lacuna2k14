package  {
	import flash.display.Sprite;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class Level1Pipes extends Sprite{
		
		public static var shapesDictionary:Dictionary = new Dictionary();
		public static var pipeDictionary:Dictionary = new Dictionary();
		public static var pipeGraphicsDictionary:Dictionary = new Dictionary();
		public var unsolvedClues:Array;
		public var onScreenNow:Array;
		private var rotatingPipes:Array;
		private var rotatablePipeCount:uint;
		private var sendingClues:Boolean;
		private var randomSend:Boolean;
		
		public function Level1Pipes(parent:Sprite) {
			
			shapesDictionary["red,star"] = function ():Sprite { return new RedStar(); };
			shapesDictionary["blue,star"] = function ():Sprite { return new BlueStar(); };
			shapesDictionary["yellow,star"] = function ():Sprite { return new YellowStar(); };
			shapesDictionary["red,heart"] = function ():Sprite { return new RedHeart(); };
			shapesDictionary["blue,heart"] = function ():Sprite { return new BlueHeart(); };
			shapesDictionary["green,heart"] = function ():Sprite { return new GreenHeart(); };
			
			pipeGraphicsDictionary["leftright"] = function():Sprite { return new LeftRightPipe(); };
			pipeGraphicsDictionary["updown"] = function():Sprite { return new UpDownPipe(); };
			pipeGraphicsDictionary["downleft"] = function():Sprite { return new DownLeftPipe(); };
			pipeGraphicsDictionary["downright"] = function():Sprite { return new DownRightPipe(); };
			pipeGraphicsDictionary["upleft"] = function():Sprite { return new UpLeftPipe(); };
			pipeGraphicsDictionary["upright"] = function():Sprite { return new UpRightPipe(); };
			pipeGraphicsDictionary["rotatable"] = function():Sprite { return new RotatablePipe(); };
			pipeGraphicsDictionary["leftexit"] = function():Sprite { return new LeftExit(); };
			pipeGraphicsDictionary["rightexit"] = function():Sprite { return new RightExit(); };
			pipeGraphicsDictionary["upexit"] = function():Sprite { return new UpExit(); };
			pipeGraphicsDictionary["downexit"] = function():Sprite { return new DownExit(); };
			pipeGraphicsDictionary["stardestination"] = function():Sprite { return new StarDestination(); };
			pipeGraphicsDictionary["heartdestination"] = function():Sprite { return new HeartDestination(); };
			
			unsolvedClues = new Array();
			onScreenNow = new Array();
			rotatingPipes = new Array();
			sendingClues = false;
			randomSend = false;
			
			this.x = parent.x;
			this.y = parent.y;
			
			rotatablePipeCount = 0;
		}
		
		public function newClue(gridX:uint, gridY:uint, shapeType:String, shapeColor:String, questionNo:uint, link:String, speed:String):void {
			var location:Point = new Point(LacunaConstants.CELL_WIDTH * gridX - LacunaConstants.CELL_WIDTH / 2, LacunaConstants.CELL_HEIGHT * gridY - LacunaConstants.CELL_HEIGHT / 2);
			unsolvedClues.push(new ClueShape(this, link, location, questionNo, shapeType, shapeColor, speed, LacunaConstants.DOWN));
		}
		
		public function newPipe(gridX:uint, gridY:uint, pipeType:String, isInverted:String, expectedShapeIfDest:String = null):void {
			var location:Point = new Point(LacunaConstants.CELL_WIDTH * gridX - LacunaConstants.CELL_WIDTH / 2, LacunaConstants.CELL_HEIGHT * gridY - LacunaConstants.CELL_HEIGHT / 2);
			var pipeToAdd:Pipe;
			if (pipeType == LacunaConstants.PIPE_ROTATABLE)
			{
				pipeToAdd = new RotatingPipe(this, LacunaConstants.PIPE_LEFT_RIGHT, location, rotatablePipeCount++);
				rotatingPipes.push(pipeToAdd);
			}
			else if	(pipeType == LacunaConstants.PIPE_DESTINATION)
				pipeToAdd = new DestinationPipe(this, location, expectedShapeIfDest);
			else
				pipeToAdd = new Pipe(this, pipeType, location, isInverted);
			Level1Pipes.pipeDictionary[location.x + "," + location.y] = pipeToAdd;
		}
		
		public function sendClues():void {
			if (sendingClues)
				return;
			else
			{
				this.sendingClues = true;
				this.randomSend = true;
				randomlySendClues();
			}
		}
		
		public function stopClues():void {
			if (!sendingClues)
				return;
			else
			{
				stopSendingClues();
				this.randomSend = false;
				this.sendingClues = false;
			}
		}
		
		public function showScreen():void {
			this.visible = true;
		}
		
		public function hideScreen():void {
			this.visible = false;
		}
		
		private function randomlySendClues():void {
			if (!randomSend)
				return;
			var index:uint;
			if (onScreenNow.length != unsolvedClues.length)
			{
				do {
					index = 0 + (unsolvedClues.length) * Math.random();
					if (!unsolvedClues[index].onscreen) {
						startClue(unsolvedClues[index]);
						break;
					}
				} while (true);
			}
			trace("Clues left : " + unsolvedClues.length);
			TweenLite.delayedCall(LacunaConstants.CLUE_SEND_LOWER + Math.random() * LacunaConstants.CLUE_SEND_UPPER, randomlySendClues);
		}
		
		public function rotatePipe(pipeNumber:uint):void {
			RotatingPipe(rotatingPipes[pipeNumber]).rotate();
		}
		
		public function startClue(clue:ClueShape):void {
			clue.onscreen = true;
			clue.moveClue();
		}
		
		public function stopSendingClues():void {
			unsolvedClues.length = 0;
		}
	}
}

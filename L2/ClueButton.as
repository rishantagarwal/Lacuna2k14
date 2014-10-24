package  
{
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author 
	 */
	public class ClueButton extends Sprite 
	{
		private var id:int;
		
		private var cluesymbol:Sprite;
		public var imageContainer1:Sprite;
		private var ans:Sprite;
		private var firstTime:Boolean;
		private var quesNo:uint;
		private var currentLevel:uint;
		
		var variables:URLVariables;
		var request:URLRequest;
		
		var loader:URLLoader;
		var curclickon:uint;
		var clue:Clue;
		private var isActive:Boolean;
		
		public function ClueButton(link:String, id:int, ques:int, curlvl:int) 
		{	
			this.id = id;
			parent.addChild(cluesymbol);
			
			firstTime = true;
			quesNo = ques;
			currentLevel = curlvl;
			ans = new answerbox();
			//trace("yes2");

			imageContainer1 = new Sprite();
			//trace("yes3");

			var ig:ImageLoader = new ImageLoader(link, { name:"quesimage", container:imageContainer1, centerRegistration: true, onComplete:scaleImage} );
			ig.load();
			
			
			clue = new Clue();
						//trace("yes4");
			//trace(Lacuna.STAGE.stageWidth);
			clue.buttonMode = true;
			//trace("yes5");
			clue.mouseChildren = false;
			//trace("yes6");
			clue.x = Lacuna.STAGE.stageWidth / 2 - clue.width / 2;
			//trace("yes6-7");
			clue.y = Lacuna.STAGE.stageHeight - clue.height;
			//trace("yes7");
			clue.visible = false;
			
			variables = new URLVariables();
			//trace("yes8");
			request = new URLRequest("anscheck.php");
			//trace("yes9");
			request.method=URLRequestMethod.POST;
			//trace("yes10");
			super(parent, new Point(location.x * Lacuna.WIDTH, location.y * Lacuna.HEIGHT), new Point((location.x + 1) * Lacuna.WIDTH, (location.y+1)*Lacuna.HEIGHT));
		}
		
		private function gotoShowQues(e:MouseEvent):void 
		{
			showQues();
			clue.visible = false;
			clue.removeEventListener(MouseEvent.CLICK, gotoShowQues);
		}
		
		private function scaleImage(ld:LoaderEvent):void 
		{
			if (imageContainer1.height > Lacuna.STAGE.stageHeight - 100)
			{
				imageContainer1.width = imageContainer1.width * (Lacuna.STAGE.stageHeight - 100) / imageContainer1.height;
				imageContainer1.height = Lacuna.STAGE.stageHeight - 100;
			}
			else if (imageContainer1.width > Lacuna.STAGE.stageWidth)
			{
				imageContainer1.height = imageContainer1.height * Lacuna.STAGE.stageWidth / imageContainer1.width;
				imageContainer1.width = Lacuna.STAGE.stageWidth;
			}
				ans.addChild(imageContainer1);
			imageContainer1.x = 0;
			imageContainer1.y = 0;
			
		}
		
		public function showQues():void
		{
			Lacuna.STAGE.addChild(ans);
			ans.x = Lacuna.STAGE.stageWidth / 2;
			ans.y = Lacuna.STAGE.stageHeight / 2;
			

			answerbox(ans).wrong.visible=false;
			answerbox(ans).correct.visible = false;
			answerbox(ans).loadingcirc.visible = false;
			answerbox(ans).close_btn.addEventListener(MouseEvent.CLICK, removeAns);
			answerbox(ans).submit.buttonMode = true;
			answerbox(ans).close_btn.buttonMode = true;
			answerbox(ans).submit.addEventListener(MouseEvent.CLICK, checkAns);
		}
		
		private function checkAns(e:MouseEvent):void 
		{
			
			variables.QNo=quesNo;
			variables.Ansgiven = answerbox(ans).ansbox.text;
			variables.curLevel=currentLevel;
			request.data=variables;
			loader=new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onAnschecked);
			loader.dataFormat=URLLoaderDataFormat.VARIABLES;
			loader.load(request);
			answerbox(ans).loadingcirc.visible = true;
			answerbox(ans).correct.visible = false;
			answerbox(ans).wrong.visible = false;
			
			answerbox(ans).loadingcirc.play();
		}
		
		private function removeAns(e:MouseEvent):void 
		{
			Lacuna.STAGE.removeChild(ans);
			answerbox(ans).close_btn.removeEventListener(MouseEvent.CLICK, removeAns);
			answerbox(ans).submit.removeEventListener(MouseEvent.CLICK, checkAns);
			
			GenConstants.LacunaInstance.playGame();
		}
		
		override protected function killAnime(spriteType:uint, pt:b2Vec2):void 
		{
			if(firstTime)
			{
				firstTime = false;
				Man(Lacuna.allDynaBodies[Lacuna.allDynaBodies.length - 1]).pauseMan();
				Man.lacunaInstance.pauseGame();
				showQues();
			}
			else
			{
				if(clue.parent != Lacuna.STAGE)
				{
					Lacuna.STAGE.addChild(clue);
					
				}
				clue.visible = true;
				clue.addEventListener(MouseEvent.CLICK, gotoShowQues);
				TweenLite.delayedCall(6, removeClueBtn);
			}
			super.killAnime(spriteType, pt);
		}
		
		private function removeClueBtn():void 
		{
			if(clue.parent == Lacuna.STAGE)
				Lacuna.STAGE.removeChild(clue);
			clue.visible = false;
			clue.removeEventListener(MouseEvent.CLICK, gotoShowQues);
		}
		
		var picbmpds:Vector.<BitmapData>;
	
		var anscorrect:Boolean;
		function onAnschecked(event:Event) {
			var returndata:URLVariables=new URLVariables(event.target.data);
			answerbox(ans).loadingcirc.visible = false;
			answerbox(ans).loadingcirc.stop();
			
			if (returndata.checkans=="true") {
				answerbox(ans).correct.visible = true;
				Man.lacunaInstance.nocorrans[quesNo] = 1;
				anscorrect = true;
				Lacuna.allClues.splice(Lacuna.allClues.indexOf(this), 1);
				Man.lacunaInstance.removeChild(this.cluesymbol);	
			} else {
				answerbox(ans).wrong.visible = true;
				
				answerbox(ans).ansbox.addEventListener(TextEvent.TEXT_INPUT, hidewrong);
			}
		}

		function hidewrong(ev:TextEvent):void {
			answerbox(ans).ansbox.removeEventListener(TextEvent.TEXT_INPUT, hidewrong);
			answerbox(ans).wrong.visible=false;
		}
	}
}
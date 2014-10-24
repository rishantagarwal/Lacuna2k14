package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	/**
	 * ...
	 * @author 
	 */
	public class ClueSymbol extends Sprite
	{
		private var cluesymbol:ClueMc;
		public var imageContainer1:Sprite;
		private var ans:Sprite;
		private var quesNo:uint;
		private var currentLevel:uint;
		private var bmp:Bitmap;
		
		var variables:URLVariables;
		var request:URLRequest;
		
		var loader:URLLoader;
		var curclickon:uint;
		var isActive:Boolean = false;
		
		public function ClueSymbol(btArr:Vector.<BitmapData>, ques:uint, curlvl:int, state:int) 
		{
			cluesymbol = new ClueMc();
			this.addChild(cluesymbol);
			//if (state == 0) {
			cluesymbol.gotoAndStop("inactive");
			cluesymbol.buttonMode = false;
			
			quesNo = ques;
			currentLevel = curlvl;
			ans = new answerbox();
			
			imageContainer1 = new Sprite();
			bmp = new Bitmap(btArr[ques]);
			imageContainer1.addChild(bmp);
			
			scaleImage();
			//var ig:ImageLoader = new ImageLoader(link, { name:"quesimage", container:imageContainer1, centerRegistration: true, onComplete:scaleImage} );
			//ig.load();
			
			/*variables = new URLVariables();
			request = new URLRequest("anscheck.php");
			request.method = URLRequestMethod.POST;
			seenQues();*/
		}
		
		private function seenQues():void 
		{
			variables.QNo = (quesNo+1);
			variables.curLevel = currentLevel;
			request.data = variables;
			
			loader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onSeenReceived);
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.load(request);
		}
		
		private function onSeenReceived(e:Event):void 
		{
			var returndata:URLVariables = new URLVariables(e.target.data);
			
			if (returndata.checkans == "true") {	
				GenConstants.LacunaInstance1.updateAns(quesNo, 1);
				
				cluesymbol.addEventListener(MouseEvent.CLICK, gotoShowQues);
				cluesymbol.gotoAndStop("active");
				cluesymbol.buttonMode = true;
			} 
		}
		
		public function activate():void {
			if (GenConstants.LacunaInstance1.getClueState(quesNo) != 2) {
				trace("activated by symbol");
				variables = new URLVariables();
				request = new URLRequest("anscheck.php");
				request.method = URLRequestMethod.POST;
				
				GenConstants.LacunaInstance1.updateAns(quesNo, 1);
					
				cluesymbol.addEventListener(MouseEvent.CLICK, gotoShowQues);
				cluesymbol.gotoAndStop("active");
				cluesymbol.buttonMode = true;
					
				//seenQues();
				isActive = true;
			}
		}
		
		public function markAnswered():void {
			cluesymbol.buttonMode = false;
			cluesymbol.gotoAndStop("answered");
			cluesymbol.removeEventListener(MouseEvent.CLICK, gotoShowQues);
		}
		
		private function gotoShowQues(e:MouseEvent):void 
		{
			showQues();
			cluesymbol.removeEventListener(MouseEvent.CLICK, gotoShowQues);
		}
		
		private function scaleImage():void 
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
			imageContainer1.x = -imageContainer1.width/2; 
			imageContainer1.y = -imageContainer1.height/2;
			
		}
		
		public function showQues():void
		{
			trace("ques no", quesNo);
			GenConstants.LacunaInstance1.pauseGame();GenConstants.LacunaInstance2.pauseGame();
			Lacuna.STAGE.addChild(ans);
			ans.alpha = 0;
			TweenLite.to(ans, 1, { alpha:1 } );
			
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
			variables.QNo = (quesNo+1);
			variables.Ansgiven = answerbox(ans).ansbox.text;
			variables.curLevel = currentLevel;
			request.data = variables;
			loader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onAnschecked);
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
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
			answerbox(ans).ansbox.removeEventListener(TextEvent.TEXT_INPUT, hidewrong);
			cluesymbol.addEventListener(MouseEvent.CLICK, gotoShowQues);
			
			GenConstants.LacunaInstance1.playGame();
			GenConstants.LacunaInstance2.playGame();
		}
		
		function onAnschecked(event:Event) {
			var returndata:URLVariables = new URLVariables(event.target.data);
			answerbox(ans).loadingcirc.visible = false;
			answerbox(ans).loadingcirc.stop();
			
			if (returndata.checkans == "true") {
				answerbox(ans).correct.visible = true;
				GenConstants.LacunaInstance1.updateAns(quesNo, 2);
				cluesymbol.buttonMode = false;
				cluesymbol.gotoAndStop("answered");
				cluesymbol.removeEventListener(MouseEvent.CLICK, gotoShowQues);
			} 
			else {
				answerbox(ans).wrong.visible = true;
				answerbox(ans).ansbox.addEventListener(TextEvent.TEXT_INPUT, hidewrong);
			}
		}
		
		function hidewrong(ev:TextEvent):void {
			answerbox(ans).ansbox.removeEventListener(TextEvent.TEXT_INPUT, hidewrong);
			answerbox(ans).wrong.visible=false;
		}
		
		function removeAnsBox():void {
			try {
				Lacuna.STAGE.removeChild(ans);
			}
			catch (e:Error) {
				
			}
		}
	}
}
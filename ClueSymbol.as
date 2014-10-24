package  
{
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
	import com.greensock.loading.ImageLoader;
	import com.greensock.events.LoaderEvent;
	/**
	 * ...
	 * @author 
	 */
	public class ClueSymbol extends Sprite
	{
		private var cluesymbol:Sprite;
		public var imageContainer1:Sprite;
		private var ans:Sprite;
		private var quesNo:uint;
		private var currentLevel:uint;
		
		var variables:URLVariables;
		var request:URLRequest;
		
		var loader:URLLoader;
		var curclickon:uint;
		var isActive:Boolean;
		
		public function ClueSymbol(link:String, ques:uint, curlvl:int) 
		{
			cluesymbol = new ClueMc();
			this.addChild(cluesymbol);
			cluesymbol.gotoAndStop("inactive");
			cluesymbol.buttonMode = false;
			
			quesNo = ques;
			currentLevel = curlvl;
			ans = new answerbox();
			
			imageContainer1 = new Sprite();
			var ig:ImageLoader = new ImageLoader(link, { name:"quesimage", container:imageContainer1, centerRegistration: true, onComplete:scaleImage} );
			ig.load();
			
			variables = new URLVariables();
			request = new URLRequest("anscheck.php");
			request.method=URLRequestMethod.POST;
		}
		
		public function activate():void {
			cluesymbol.addEventListener(MouseEvent.CLICK, gotoShowQues);
			cluesymbol.gotoAndStop("active");
			cluesymbol.buttonMode = true;
		}
		
		private function gotoShowQues(e:MouseEvent):void 
		{
			showQues();
			cluesymbol.removeEventListener(MouseEvent.CLICK, gotoShowQues);
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
			imageContainer1.x = 0; Lacuna.STAGE.stageWidth / 2;
			imageContainer1.y = 0; Lacuna.STAGE.stageHeight / 2;
		}
		
		public function showQues():void
		{
			Lacuna.STAGE.addChild(ans);
			ans.alpha = 0;
			TweenLite.to(ans, 2, { alpha:1 } );
			
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
			variables.QNo = quesNo;
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
			
			GenConstants.LacunaInstance.playGame();
		}
		
		function onAnschecked(event:Event) {
			var returndata:URLVariables = new URLVariables(event.target.data);
			answerbox(ans).loadingcirc.visible = false;
			answerbox(ans).loadingcirc.stop();
			
			if (returndata.checkans == "true") {
				answerbox(ans).correct.visible = true;
				GenConstants.LacunaInstance.updateAns(quesNo, 2);
				cluesymbol.buttonMode = false;
				cluesymbol.gotoAndStop("answered");
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
	}
}
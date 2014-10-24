package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class conveyerCell extends Sprite
	{
		private var nextDir:int;
		private var isRoundabout:Boolean;
		private var dir:int;
		private var sp:Sprite;
		private var isDest:Boolean;
		private var key:int;
		
		public function conveyerCell(nextDir:int, isRoundabout:Boolean, dir:int) 
		{
			this.nextDir = nextDir;
			this.isRoundabout = isRoundabout;
			this.dir = dir;
			
			addSprite();
		}
		
		public function addSprite():void {
			if (isRoundabout) {
				sp = new roundAboutSprite();
				if (dir == GenConstants.HORIZONTAL) {
					sp.gotoAndStop(2);
				}
			}
			else if (isDest) {
				switch (key) {
					case 1:
						sp = new key1Sprite();
						break;
					case 2:
						sp = new key2Sprite();
						break;
					case 3:
						sp = new key3Sprite();
						break;
				}
			}
			else {
				sp = new beltSprite();
				if (dir == GenConstants.HORIZONTAL) {
					sp.rotation = 90;
				}
			}
			
			this.addChild(sp);
			sp.x = sp.width / 2;
			sp.y = sp.height / 2;
		}
		
		public function changeDir(newDir:int):void {
			if (isRoundabout) {
				this.dir = newDir;
				if (dir == GenConstants.HORIZONTAL)
					sp.gotoAndStop(2);
				else 
					sp.gotoAndStop(1);
			}
		}
		
		public function getNextDir():int {
			return nextDir;
		}
		
		public function getKey():int {
			return key;
		}
	}
}
package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class KillerSprite extends Sprite 
	{
		var sp:Sprite;
		
		public function KillerSprite(len:int, type:int, rot:int) 
		{
			sp = new Sprite();
			
			if (type == GenConstants.SPIKES) {
				var c:int = 0;
				var spike:Sprite = new SpikeStrip();
				var px:Number = ( -len / 2 + 0.5) * GenConstants.unitToPixels;
				spike.x = px;
				sp.addChild(spike);
				
				while (c < len) {
					spike = new SpikeStrip();
					px += GenConstants.unitToPixels;
					spike.x = px;
					sp.addChild(spike);
				}
			}
			
			this.addChild(sp);
			sp.rotation = rot;
		}		
	}
}
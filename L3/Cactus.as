package 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class	Cactus extends killer
	{
		private var spikes:Array;
		private var cactusSprite:Sprite;
		private var spikeDuration:int;
		private var spikesSpeed:Number;
		private var parent:Sprite;
		private var pos:Point;
		private var shouldShoot:Boolean;
		
		public function Cactus(parent:Sprite, pos:Point, spikeSpeed:Number, spikeDuration:int) {
			spikes = new Array();
			this.spikeDuration = spikeDuration;
			this.spikesSpeed = spikeSpeed;
			this.parent = parent;
			this.pos = pos;
			shouldShoot = false;
			
			super(parent, pos, 1, 0, -1, 0);
		}
		
		override protected function makeSkin(par:Sprite):void {
			var sp:Sprite = new CactusSprite();
			par.addChild(sp);
		}
		
		private function shootOutSpikes():void {
			if (!this.shouldShoot)
				return;
			spikes.push(new Spike(this.parent, this.pos, this.spikesSpeed, 0));
			spikes.push(new Spike(this.parent, this.pos, this.spikesSpeed, 1));
			for each (var spike:Spike in spikes) {
				spike.shootOut();
			}
			
			TweenLite.delayedCall(spikeDuration, shootOutSpikes);
		}
		
		public function stopShootingSpikes():void {
			shouldShoot = false;
		}
		
		public function startShootingSpikes():void {
			if (this.shouldShoot)
				return;
			shouldShoot = true;
			TweenLite.delayedCall(spikeDuration, shootOutSpikes);
		}
	}
}
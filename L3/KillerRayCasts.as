package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
		
		public class KillerRayCasts extends RayCastObjects 
		{
			public static const ROTATING_LASER:int = 2;
			public static const DEATH_ZONE:int = 3;
			
			private var location:Point;
			public var flag:Boolean;
			
			public var type:uint;
			public var sp:Sprite;
			
			public function KillerRayCasts(par:Sprite, type:int, location:Point, _startPoint:Point, _endPoint:Point) 
			{
				this.location = location;
				var killerSprite:Sprite = createSprite(type, _startPoint, _endPoint);
				par.addChild(killerSprite);
				
				killerSprite.x = (location.x * GenConstants.unitToPixels) + killerSprite.width / 2;
				killerSprite.y = (location.y * GenConstants.unitToPixels) + killerSprite.height / 2;
				
				this.type = type;
				sp = killerSprite;
				super(par, _startPoint, _endPoint);
			}
			
			private function createSprite(spriteType:uint, stPoint:Point, endPoint:Point):Sprite
			{
				var killerSprite:Sprite;
				
				switch (spriteType) {
					case ROTATING_LASER:
						killerSprite = new Sprite();
						break;
					case DEATH_ZONE:
						killerSprite = new deathZoneSp();
						break;
				}
				
				return killerSprite;
			}
			
			override public function createRayCast():void 
			{
				super.createRayCast();
			}
			
			override protected function killAnime():void 
			{
				if (this is RotatingLaser) {
					trace("killed by rotating laser");
				}
				GenConstants.LacunaInstance.endGame();
				GenConstants.LacunaInstance.getManInstance().playDeathAnimation();
				
				super.killAnime();
			}
			
			public function getType():int {
				return type;
			}
		}
	
}
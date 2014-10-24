package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class killer extends Builder
	{
		private var _len:Number;
		private var _dir:int;
		private var _type:int;
		private var _wid:Number;
		public static const SPIKES:int = 1;
		public static const BOB:int = 2;
		public static const TURTLE:int = 3;
		public static const CACTUS:int = 4;
		
		public function killer(par:Sprite, pos:Point, length:Number, dir:int, type:int) 
		{
			_dir = dir;
			_len = length;
			_type = type;
			_wid = 1;										//half width
			
			super(pos, par);
		}
		
		override protected function makeBody(pos:Point):void 
		{
			if (_type == SPIKES) {
				var body1Def:b2BodyDef = new b2BodyDef();
				var body1Shape:b2PolygonShape = new b2PolygonShape();
				var body1FixDef:b2FixtureDef = new b2FixtureDef();
				
				if (_dir == GenConstants.HORIZONTAL) {
					body1Shape.SetAsBox((_len * GenConstants.unitToPixels) / GenConstants.RATIO / 2, _wid/2);
					body1Def.position.Set(((pos.x + _len/2) * GenConstants.unitToPixels)/GenConstants.RATIO, ((pos.y + _wid/2) * GenConstants.unitToPixels)/GenConstants.RATIO);
				}
				else {
					body1Shape.SetAsBox(_wid/2, (_len * GenConstants.unitToPixels) / GenConstants.RATIO / 2);
					body1Def.position.Set(((pos.x + _wid/2) * GenConstants.unitToPixels)/GenConstants.RATIO, ((pos.y + _len/2) * GenConstants.unitToPixels)/GenConstants.RATIO);
				}
				
				body1Def.type = b2Body.b2_staticBody;
				
				body1FixDef.shape = body1Shape;
				body1FixDef.friction = 1;
				body1FixDef.restitution = 0;
				
				_body = GenConstants.LacWorld.CreateBody(body1Def);
				_body.CreateFixture(body1FixDef);
			}
			else if (_type == BOB) {
				// BASE PIVOT ==> STATIC BODY
				
				
				
			}
			
			super.makeBody(pos);
		}
		
		override protected function makeSkin(par:Sprite):void 
		{
			var sp:Sprite;
			if (_type == SPIKES) {
				sp = new spikeMc();
				//sp = new KillerSprite(_len, _type);
			}
			_skin = sp;
			par.addChild(_skin);
			//_skin = new Sprite();
			
			super.makeSkin(par);
		}
	}

}
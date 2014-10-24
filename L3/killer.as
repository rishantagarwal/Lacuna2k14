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
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class killer extends Builder
	{
		private var _len:Number;
		private var _dir:int;
		private var _type:int;
		private var _wid:Number;
		private var _inv:Boolean;
		public static const SPIKES:int = 1;
		public static const BOB:int = 2;
		public static const ROCKET:int = 3;
		
		public function killer(par:Sprite, pos:Point, length:Number, dir:int, type:int, inv:int) 
		{
			_dir = dir;
			_len = length;
			_type = type;
			_wid = 0.5;										//half width
			if (inv == 1)
				_inv = true;
			else
				_inv = false;
			
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
					if (_inv) {
						body1Shape.SetAsBox(_wid/2, (_len * GenConstants.unitToPixels) / GenConstants.RATIO / 2);
						body1Def.position.Set(((pos.x + 0.5 + _wid / 2) * GenConstants.unitToPixels) / GenConstants.RATIO, ((pos.y + _len / 2) * GenConstants.unitToPixels) / GenConstants.RATIO);
					}
					else {
						body1Shape.SetAsBox(_wid/2, (_len * GenConstants.unitToPixels) / GenConstants.RATIO / 2);
						body1Def.position.Set(((pos.x + _wid / 2) * GenConstants.unitToPixels) / GenConstants.RATIO, ((pos.y + _len / 2) * GenConstants.unitToPixels) / GenConstants.RATIO);
					}
				}
				
				body1Def.type = b2Body.b2_staticBody;
				
				body1FixDef.shape = body1Shape;
				body1FixDef.friction = 1;
				body1FixDef.restitution = 0;
				
				_body = GenConstants.LacWorld.CreateBody(body1Def);
				_body.CreateFixture(body1FixDef);
			}
			
			super.makeBody(pos);
		}
		
		override protected function makeSkin(par:Sprite):void 
		{
			var sp:Sprite;
			if (_type == SPIKES) {
				sp = new spikeMc();
				if (_dir == GenConstants.HORIZONTAL)
					sp.x = ( -_len / 2) * GenConstants.unitToPixels;
				else
					sp.y = ( -_len / 2) * GenConstants.unitToPixels;
				_skin = new Sprite();
				var c:int = 0, prevx:Number = sp.x - GenConstants.unitToPixels / 2, prevy:Number = sp.y - GenConstants.unitToPixels / 2;
				while (c < _len) {
					if (_dir == GenConstants.HORIZONTAL) {
						if (_inv) {
							sp.rotation = 180;
							//sp.y += GenConstants.unitToPixels/2+5;
						}
						sp.x = prevx + GenConstants.unitToPixels;
					}
					else {
						if (_inv) {
							sp.rotation = -90;
							sp.x -= GenConstants.unitToPixels/2+2;
						}
						else {
							sp.rotation = 90;
							sp.x += GenConstants.unitToPixels/2+2;
						}
						sp.y = prevy + GenConstants.unitToPixels;
					}
					_skin.addChild(sp);
					prevx = sp.x;
					prevy = sp.y;
					sp = new spikeMc();
					c++;
				}
			}
			
			par.addChild(_skin);
			//_skin = new Sprite();
			
			//super.makeSkin(par);
		}
		override public function updateNow():void 
		{
			super.updateNow();
		}
	}

}
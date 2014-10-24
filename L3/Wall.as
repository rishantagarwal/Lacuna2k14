package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	/**
	 * ...
	 * @author 
	 */
	public class Wall extends Builder
	{
		private var _len:Number;
		private var _restitution:Number;
		private var _friction:Number;
		private var wid:Number;
		private var isGrassy:Boolean;
		
		public function Wall(par:Sprite, pos:Point, length:Number, wid:Number, isGrassy:Boolean, friction:Number, restitution:Number) 
		{
			this.isGrassy = isGrassy;
			this.wid = wid;
			_len = length;										// LENGTH IS STORED AS UNITS
			
			_friction = friction;
			_restitution = restitution;
			
			super(pos, par);
		}
		
		override protected function makeBody(pos:Point):void 
		{
			var body1Def:b2BodyDef = new b2BodyDef();
			var body1Shape:b2PolygonShape = new b2PolygonShape();
			var body1FixDef:b2FixtureDef = new b2FixtureDef();
		
			body1Shape.SetAsBox((_len * GenConstants.unitToPixels) / GenConstants.RATIO / 2, wid * GenConstants.unitToPixels / GenConstants.RATIO / 2);
			body1Def.position.Set(((pos.x + _len/2) * GenConstants.unitToPixels)/GenConstants.RATIO, ((pos.y + wid/2) * GenConstants.unitToPixels)/GenConstants.RATIO);
			
			body1Def.type = b2Body.b2_staticBody;
			
			body1FixDef.shape = body1Shape;
			body1FixDef.friction = _friction;
			body1FixDef.restitution = _restitution;
			
			_body = GenConstants.LacWorld.CreateBody(body1Def);
			_body.CreateFixture(body1FixDef);
			
			super.makeBody(pos);
		}
		
		override protected function makeSkin(par:Sprite):void 
		{
			if (!(this is BreakableWall)){
				_skin = new Sprite();
				var sp:Sprite = new WallSkin(_len, wid, isGrassy);
				sp.x = -sp.width / 2;
				sp.y = -sp.height/2 ;
				_skin.addChild(sp);
				par.addChild(_skin);
			}
			super.makeSkin(par);
		}
		
		public function getBody():b2Body {
			return _body;
		}
		
		override public function destruct(par:Sprite):void 
		{
			super.destruct(par);
		}
		
	}

}
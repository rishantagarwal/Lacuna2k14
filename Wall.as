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
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class Wall extends Builder
	{
		private var _len:int;
		private var _dir:int;
		private var isCorner:int;
		private var _restitution:int;
		private var _friction:int;
		private var par:Sprite;
		
		public function Wall(par:Sprite, pos:Point, length:int, dir:int, cornerType:int, friction:Number, restitution:Number) 
		{
			_len = length;										// LENGTH IS STORED AS UNITS
			_dir = dir;
			isCorner = cornerType;
			_friction = friction;
			_restitution = restitution;
			this.par = par;
			
			super(pos, par);
		}
		
		override protected function makeBody(pos:Point):void 
		{
			var body1Def:b2BodyDef = new b2BodyDef();
			var body1Shape:b2PolygonShape = new b2PolygonShape();
			var body1FixDef:b2FixtureDef = new b2FixtureDef();
			
			if (_dir == GenConstants.HORIZONTAL) {
				body1Shape.SetAsBox((_len * GenConstants.unitToPixels) / GenConstants.RATIO / 2, 1 * GenConstants.unitToPixels / GenConstants.RATIO / 2);
				body1Def.position.Set(((pos.x + _len/2) * GenConstants.unitToPixels)/GenConstants.RATIO, ((pos.y + 0.5) * GenConstants.unitToPixels)/GenConstants.RATIO);
			}
			else {
				body1Shape.SetAsBox(1 * GenConstants.unitToPixels / GenConstants.RATIO / 2, (_len * GenConstants.unitToPixels) / GenConstants.RATIO / 2);
				body1Def.position.Set(((pos.x + 0.5) * GenConstants.unitToPixels)/GenConstants.RATIO, ((pos.y + _len/2) * GenConstants.unitToPixels)/GenConstants.RATIO);
			}
			
			
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
			/*
			var sp:Sprite = new WallSkin(_len, isCorner);
			
			_skin = sp;
			par.addChild(_skin);
			*/
			_skin = new Sprite();
			// USE WALLSKIN CLASS HERE
			super.makeSkin(par);
		}
		
		
		
	}

}
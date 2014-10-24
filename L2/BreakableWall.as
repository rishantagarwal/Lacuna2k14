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
	public class BreakableWall extends Builder
	{
		private var wid:Number;
		private var _len:Number;
		private var destructFlag:Boolean;
		private var pos:Point;
		public var destroyed:Boolean = false;
		
		public function BreakableWall(par:Sprite, pos:Point, length:Number, wid:Number) 
		{
			this.pos = pos;
			trace("making bwall", pos.x, pos.y, length, wid);
			this.wid = wid;
			_len = length;
			destructFlag = false;
			
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
			body1FixDef.friction = 0;
			body1FixDef.restitution = 0;
			
			_body = GenConstants.LacWorld.CreateBody(body1Def);
			_body.CreateFixture(body1FixDef);
			
			super.makeBody(pos);
		}
		override public function childSpecificUpdating():void 
		{
			//trace("call for destroy");
			if (destructFlag) {
				destruct(par);
				trace("destroyed");
				destructFlag = false;
			}
			super.childSpecificUpdating();
		}
		
		override protected function makeSkin(par:Sprite):void 
		{
			var sp:Sprite = new WallSkin((_len == 0.5 ? 1:_len), (wid == 0.5 ? 1:wid), false);
			_skin = new Sprite();
			if (_len == 0.5) {
				sp.scaleX = 0.5;
			}
			else if (wid == 0.5) {
				sp.scaleY = 0.5;
			}
			
			sp.x = -sp.width / 2;
			sp.y = -sp.height/2 ;
			_skin.addChild(sp);
			par.addChild(_skin);
			
			super.makeSkin(par);
		}
		
		override public function destruct(par:Sprite):void 
		{
			trace("destroyed wall");
			super.destruct(par);
		}
		
		public function setDestroyFlag():void {
			destructFlag = true;
			destroyed = true;
			trace("setting destroy flag");
		}
		
	}

}
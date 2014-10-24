package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class Gate extends Builder
	{
		private var id:int;
		private var pos:Point;
		private var isOpen:Boolean;
		private var dir:int;
		private var toggleAllowed:Boolean;
		private var returnDelay:int;
		
		public function Gate(par:Sprite, pos:Point, id:int, dir:int, returnDelay:int) 
		{
			this.returnDelay = returnDelay;
			isOpen = false;
			this.pos = pos;
			this.id = id;
			this.dir = dir;
			toggleAllowed = true;
			
			super(pos, par);
		}
		
		override protected function makeBody(pos:Point):void 
		{
			var body1Def:b2BodyDef = new b2BodyDef();
			var body1Shape:b2PolygonShape = new b2PolygonShape();
			var body1FixDef:b2FixtureDef = new b2FixtureDef();
			
			if (dir == GenConstants.HORIZONTAL) {
				body1Shape.SetAsOrientedBox(1 * GenConstants.unitToPixels / GenConstants.RATIO, 0.2 / GenConstants.RATIO, new b2Vec2(0, 0), 0);
				body1Def.position.Set(pos.x * GenConstants.unitToPixels / GenConstants.RATIO, (pos.y+0.5) * GenConstants.unitToPixels / GenConstants.RATIO);
			}
			else {
				body1Shape.SetAsOrientedBox(1 * GenConstants.unitToPixels / GenConstants.RATIO, 0.2 / GenConstants.RATIO, new b2Vec2(0, 0), -Math.PI/2);
				body1Def.position.Set((pos.x+0.5) * GenConstants.unitToPixels / GenConstants.RATIO, (pos.y) * GenConstants.unitToPixels / GenConstants.RATIO);
			}
			body1Def.type = b2Body.b2_kinematicBody;
			
			body1FixDef.shape = body1Shape;
			body1FixDef.friction = 1;
			body1FixDef.restitution = 0;
			
			_body = GenConstants.LacWorld.CreateBody(body1Def);
			_body.CreateFixture(body1FixDef);
			trace("gate:", id, _body.GetAngle() * 180 / Math.PI);
			
			super.makeBody(pos);	
		}
		
		override protected function makeSkin(par:Sprite):void 
		{
			_skin = new Sprite();
			super.makeSkin(par);
		}
		
		public function toggleState():void {
			trace("toggling gate:", id);
			
			if (toggleAllowed) {
				GenConstants.LacunaInstance.autoMapStart();
				if (dir == GenConstants.HORIZONTAL) {
					if (isOpen) {
						_body.SetPosition(new b2Vec2(_body.GetWorldCenter().x + (1 * GenConstants.unitToPixels/GenConstants.RATIO), _body.GetWorldCenter().y));
						//_body.SetAngle(0);
					}
					else {
						_body.SetPosition(new b2Vec2(_body.GetWorldCenter().x - (1 * GenConstants.unitToPixels/GenConstants.RATIO), _body.GetWorldCenter().y));
						//_body.SetAngle(-Math.PI / 2);
						TweenLite.delayedCall(returnDelay, toggleState);
					}
				}
				else {
					if (isOpen) {
						_body.SetPosition(new b2Vec2(_body.GetWorldCenter().x, _body.GetWorldCenter().y + (1 * GenConstants.unitToPixels/GenConstants.RATIO)));
						//_body.SetAngle(0);
					}
					else {
						_body.SetPosition(new b2Vec2(_body.GetWorldCenter().x, _body.GetWorldCenter().y - (1 * GenConstants.unitToPixels/GenConstants.RATIO)));
						//_body.SetAngle(-Math.PI / 2);
						TweenLite.delayedCall(returnDelay, toggleState);
					}
				}				
				isOpen = !isOpen;
				toggleAllowed = false;
				TweenLite.delayedCall(1.5, allowToggle);
			}
		}
		
		public function allowToggle():void {
			toggleAllowed = true;
		}
	}
}
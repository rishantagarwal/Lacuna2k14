package  
{
	import Box2D.Dynamics.b2Body;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class Builder extends EventDispatcher
	{
		protected var par:Sprite;
		protected var _body:b2Body;
		protected var _skin:Sprite;
		
		public function Builder(pos:Point, par:Sprite) 
		{
			this.par = par;
			makeBody(pos);
			makeSkin(par);
			if (this is BreakableWall) {
				trace("parent is", par);
			}
			_body.SetUserData(this);
			
			updateAttribs();
			//Lacuna.STAGE.addEventListener(Event.ENTER_FRAME, updateNow);
		}
		
		protected function makeSkin(par:Sprite):void 
		{
			// overridden in child
		}
		
		protected function makeBody(pos:Point):void 
		{
			// overridden in child
		}
		
		public function updateNow():void {
			
			updateAttribs();
			childSpecificUpdating();
			
		}
		
		public function updateAttribs():void {
			_skin.x = _body.GetPosition().x * GenConstants.RATIO;
			_skin.y = _body.GetPosition().y * GenConstants.RATIO;
			_skin.rotation = _body.GetAngle() * 180 / Math.PI;
		}
		
		public function childSpecificUpdating():void {
			// overridden in child
		}
		
		public function destruct(par1:Sprite):void {
			if (_body != null) {
				trace("remove body");
				GenConstants.LacWorld.DestroyBody(_body);
			}
			if (_skin != null) {
				trace("parent is while dest", par);
				par.removeChild(_skin);
			}
		}
		
	}

}
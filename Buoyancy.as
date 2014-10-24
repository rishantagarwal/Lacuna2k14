package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Controllers.b2BuoyancyController;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 
	 */
	public class Buoyancy extends Sprite
	{
		private var world:b2World = new b2World(new b2Vec2(0, 10), true);
		var buoyancyController:b2BuoyancyController = new b2BuoyancyController();
		private var worldScale:int = 30;
		
		public function Buoyancy() 
		{
			debugDraw();
			buoyancyController.normal.Set(0, -1);
			buoyancyController.offset = -180 / worldScale;
			buoyancyController.useDensity = true;
			buoyancyController.density = 2.0;
			buoyancyController.linearDrag = 5;
			buoyancyController.angularDrag = 2;
			world.AddController(buoyancyController);
			
			addBox(320,480,640,20,b2Body.b2_staticBody,false);
            addBox(320,340,320,20,b2Body.b2_staticBody,false);
            addBox(170,230,20,200,b2Body.b2_staticBody,false);
            addBox(470,230,20,200,b2Body.b2_staticBody,false);
            addBox(320, 245, 280, 170, b2Body.b2_staticBody, true);
			
			var waterCanvas:Sprite = new Sprite();
			addChild(waterCanvas);
			
			waterCanvas.graphics.beginFill(0x0000ff, 0.2);
			waterCanvas.graphics.drawRect(180, 160, 280, 170);
			waterCanvas.graphics.endFill();
			addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		private function debugDraw():void 
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			debugDraw.SetFillAlpha(0.5);
			world.SetDebugDraw(debugDraw);
		}
		
		private function addBox(pX:Number, pY:Number, w:Number, h:Number, bodyType:uint, isSensor:Boolean):void 
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(pX / worldScale, pY / worldScale);
			bodyDef.type = bodyType;
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(w / 2 / worldScale, h / 2 / worldScale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.isSensor = isSensor;
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0.4;
			fixtureDef.friction = 0.5;
			
			var body:b2Body = world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
		}
		
		private function mouseClick(e:MouseEvent):void 
		{
			addBox(mouseX, -100, Math.random() * 50 + 25, Math.random() * 50 + 25, b2Body.b2_dynamicBody, false);
			
		}
		
		private function update(e:Event):void 
		{
			
		}
		
	}

}
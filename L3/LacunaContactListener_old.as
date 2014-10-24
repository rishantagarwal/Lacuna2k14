package  
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	/**
	 * ...
	 *	
	 */
	public class LacunaContactListener extends b2ContactListener 
	{
		private var contactCount:int;
		
		public function LacunaContactListener() 
		{
			contactCount = 0;
		}
		
		override public function BeginContact(contact:b2Contact):void 
		{
			var body1:b2Body;
			var body2:b2Body;
				
				if (contact.GetFixtureA().GetBody().GetUserData() is Man)
				{
					body1 = contact.GetFixtureA().GetBody();
					body2 = contact.GetFixtureB().GetBody();
				}
				else if (contact.GetFixtureB().GetBody().GetUserData() is Man)
				{
					body1 = contact.GetFixtureB().GetBody();
					body2 = contact.GetFixtureA().GetBody();
				}
				if (!(body1 == null || body2 == null)) {
				if (body2.GetUserData() is Wall)
				{
					trace("allow horizontal");
					contactCount++;
					if (contactCount >0) 
						Man(body1.GetUserData()).allowHorizontal(true);
				}
				// NEW CODE ADDED HERE ON 11-03-14
				else if (body2.GetUserData() is turtle) {
					if (body1.GetPosition().y < body2.GetPosition().y) {
						turtle(body2).deactivate();
					}
					else {
						// kill man
					}
				}
				else if (body2.GetUserData() is Box1) {
					
					var gravDir:int = GenConstants.LacunaInstance.getGravDir();
					switch(gravDir) {
						case GenConstants.LEFT:
							if (body2.GetWorldCenter().x > body1.GetWorldCenter().x && (Math.abs(body2.GetWorldCenter().y - body1.GetWorldCenter().y) < 0.5)) {
								// kill man
								GenConstants.LacunaInstance.pauseGame();
								trace("dead");
							}else {
								// hands up
								contactCount++;
								if (contactCount >0) 
									Man(body1.GetUserData()).allowHorizontal(true);
							}
							break;
						case GenConstants.DOWN:
							if (body2.GetWorldCenter().y < body1.GetWorldCenter().y && (Math.abs(body2.GetWorldCenter().x - body1.GetWorldCenter().x) < 0.5)) {
								// kill man
								GenConstants.LacunaInstance.pauseGame();
								trace("dead");
							}
							else {
								// hands up
								contactCount++;
								if (contactCount >0) 
									Man(body1.GetUserData()).allowHorizontal(true);
							}
							break;
						case GenConstants.RIGHT:
							if (body2.GetWorldCenter().x < body1.GetWorldCenter().x && (Math.abs(body2.GetWorldCenter().y - body1.GetWorldCenter().y) < 0.5)) {
								// kill man
								GenConstants.LacunaInstance.pauseGame();
								trace("dead");
							}
							else {
								// hands up
								contactCount++;
								if (contactCount >0) 
									Man(body1.GetUserData()).allowHorizontal(true);
							}
							break;
						case GenConstants.UP:
							if (body2.GetWorldCenter().y > body1.GetWorldCenter().y && (Math.abs(body2.GetWorldCenter().x - body1.GetWorldCenter().x) < 0.5)) {
								// kill man
								GenConstants.LacunaInstance.pauseGame();
								trace("dead");
							}
							else {
								// hands up
								contactCount++;
								if (contactCount >0) 
									Man(body1.GetUserData()).allowHorizontal(true);
							}
							break;
					}
				}
				else if (body2.GetUserData() is TelePipe) {
					// teleport man
					var gravDir:int = GenConstants.grvityDir;
					contactCount++;
					if (contactCount >0) 
						Man(body1.GetUserData()).allowHorizontal(true);
					
					trace(GenConstants.LacunaInstance.getGravDir(), TelePipe(body2.GetUserData()).getDir());
					
					if (GenConstants.LacunaInstance.getGravDir() == TelePipe(body2.GetUserData()).getDir()) {
						if (TelePipe(body2.GetUserData()).isSrc() == false) {
							trace("ready to teleport");
							Man(body1.GetUserData()).canTeleport = true;
							Man(body1.GetUserData()).setTeleportDestination(TelePipe(body2.GetUserData()).getDestination());
						}
						else {
							Man(body1.GetUserData()).canTeleport = false;
						}
					}
				}
				else if (body2.GetUserData() is killer) {
					// kill man
					trace("dead by spikes");
					GenConstants.LacunaInstance.pauseGame();
				}
				else if (body2.GetUserData() is Gate) {
					contactCount++;
					if (contactCount >0) 
						Man(body1.GetUserData()).allowHorizontal(true);
				}
			}
			trace("cntct", contactCount);
			GenConstants.LacunaInstance.getManInstance().setCanJump(true);
			
			super.BeginContact(contact);
		}
		
		override public function EndContact(contact:b2Contact):void 
		{
			var body1:b2Body;
			var body2:b2Body;
			
			if (contact.GetFixtureA().GetBody().GetUserData() is Man)
			{
				body1 = contact.GetFixtureA().GetBody();
				body2 = contact.GetFixtureB().GetBody();
			}
			else if (contact.GetFixtureB().GetBody().GetUserData() is Man)
			{
				body1 = contact.GetFixtureB().GetBody();
				body2 = contact.GetFixtureA().GetBody();
			}
			else 
			{
				return;
			}
			if (body2.GetUserData() is Wall)
			{
				GenConstants.LacunaInstance.getManInstance().setCanJump(false);
				trace("no horizontal");
				contactCount--;
				trace("cntct", contactCount);
				if (contactCount == 0) 
					Man(body1.GetUserData()).allowHorizontal(false);
			}
			else if (body2.GetUserData() is TelePipe) {
				contactCount--;
				if (contactCount == 0) 
					Man(body1.GetUserData()).allowHorizontal(false);
			}
			else if (body2.GetUserData() is Gate) {
				contactCount--;
				if (contactCount == 0) 
					Man(body1.GetUserData()).allowHorizontal(false);
			}
			else if (body2.GetUserData() is Box1) {
				contactCount--;
				if (contactCount == 0) 
					Man(body1.GetUserData()).allowHorizontal(false);
			}
			trace("cntct", contactCount);
			
			super.EndContact(contact);
		}
	}
}
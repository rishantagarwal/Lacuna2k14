package  
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 *	
	 */
	public class LacunaContactListener extends b2ContactListener 
	{
		private  var contactCount:int;
		
		public function LacunaContactListener() 
		{
			contactCount = GenConstants.LacunaInstance.getManInstance().contactCount;
		}
		
		override public function BeginContact(contact:b2Contact):void 
		{
			trace("BC");
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
				else if (contact.GetFixtureB().GetBody().GetUserData() is Box1 && contact.GetFixtureA().GetBody().GetUserData() is pushButton) {
					pushButton(contact.GetFixtureA().GetBody().GetUserData()).pushIt();
					GenConstants.LacunaInstance.breakBox2Wall();
				}
				else if (contact.GetFixtureB().GetBody().GetUserData() is pushButton && contact.GetFixtureA().GetBody().GetUserData() is Box1) {
					pushButton(contact.GetFixtureB().GetBody().GetUserData()).pushIt();
					GenConstants.LacunaInstance.breakBox2Wall();
				}
				else if (contact.GetFixtureB().GetBody().GetUserData() is Rocket) {
					if (!(contact.GetFixtureA().GetBody().GetUserData() is BreakableWall)) {
						// reset rocket
						GenConstants.LacunaInstance.setNewRocketFlag();
					}
					else {
						BreakableWall(contact.GetFixtureA().GetBody().GetUserData()).setDestroyFlag();
						GenConstants.LacunaInstance.setNewRocketFlag();
					}
				}
				else if (contact.GetFixtureA().GetBody().GetUserData() is Rocket) {
					if (!(contact.GetFixtureB().GetBody().GetUserData() is BreakableWall)) {
						// reset rocket
						GenConstants.LacunaInstance.setNewRocketFlag();
					}
					else {
						BreakableWall(contact.GetFixtureB().GetBody().GetUserData()).setDestroyFlag();
						GenConstants.LacunaInstance.setNewRocketFlag();
					}
				}
				else {
					return;
				}
				if (body1 != null && body1.GetUserData() is Man && body2 != null) {
					if (body2.GetUserData() is Wall)
					{
						contactCount++;
					}
					else if (body2.GetUserData() is turtle) {
						trace("turtle contact detected");
						if ((body2.GetPosition().y - body1.GetPosition().y) > 0.5) {
							turtle(body2.GetUserData()).deactivate();
							trace("contact detected deactivate");
						}
						else {
							// kill man
							trace("contact kill man");
							if (turtle(body2.GetUserData()).state == 0) {
								GenConstants.LacunaInstance.endGame();
								Man(body1.GetUserData()).playDeathAnimation();
							}
						}
					}
					else if (body2.GetUserData() is TelePipe) {
						// teleport man
						//var gravDir:int = GenConstants.grvityDir;
						contactCount++;
						
						//trace(GenConstants.LacunaInstance.getGravDir(), TelePipe(body2.GetUserData()).getDir());
						
						if (GenConstants.LacunaInstance.getGravDir() == TelePipe(body2.GetUserData()).getDir()) {
							if (TelePipe(body2.GetUserData()).isSrc() == false) {
								var flag:Boolean = false;
								
								switch(body2.GetUserData().getDir()) {
									case GenConstants.LEFT:
										if (body1.GetWorldCenter().x - body2.GetWorldCenter().x > 0.3) {
											flag = true;
										}
										break;
									case GenConstants.DOWN:
										if (body2.GetWorldCenter().y - body1.GetWorldCenter().y > 0.3) {
											flag = true;
										}
										break;	
								}
								trace("ready to teleport");
								if (flag) {
									Man(body1.GetUserData()).canTeleport = true;
									Man(body1.GetUserData()).setTeleportDestination(TelePipe(body2.GetUserData()).getDestination());
								}
							}
							else {
								Man(body1.GetUserData()).canTeleport = false;
							}
						}
					}
					else if (body2.GetUserData() is killer) {
						// kill man
						trace("dead by spikes");
						Man(body1.GetUserData()).playDeathAnimation();
						GenConstants.LacunaInstance.endGame();
					}
					else if (body2.GetUserData() is Gate) {
						contactCount++;
					}
					else if (body2.GetUserData() is exitDoor) {
						GenConstants.LacunaInstance.getManInstance().setCanExit(true);
					}
					
					if (contactCount > 0) {
						GenConstants.LacunaInstance.getManInstance().setCanJump(true);
						//GenConstants.LacunaInstance.allowRotate(true);
						GenConstants.LacunaInstance.getManInstance().allowHorizontal(true);
					}
			}
			trace("cntct", contactCount);
			GenConstants.LacunaInstance.getManInstance().contactCount = contactCount;
			
			super.BeginContact(contact);
		}
		
		override public function EndContact(contact:b2Contact):void 
		{
			trace("EC");
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
			if (body1.GetUserData() is Man) {
				if (body2.GetUserData() is Wall) {
					//trace("cntct", contactCount);
					trace("wall contact -1");
					contactCount--;
				}
				else if (body2.GetUserData() is TelePipe) {
					Man(body1.GetUserData()).canTeleport = false;
					trace("pipe contact -1");
					contactCount--;
				}
				else if (body2.GetUserData() is Gate) {
					trace("gate contact -1");
					contactCount--;
				}
				else if (body2.GetUserData() is Box1) {
					trace("box contact -1");
					contactCount--;
				}
				else if (body2.GetUserData() is exitDoor) {
					GenConstants.LacunaInstance.getManInstance().setCanExit(false);
				}
			}
			if (contactCount <= 0) {
				GenConstants.LacunaInstance.getManInstance().setCanJump(false);
				//GenConstants.LacunaInstance.allowRotate(false);
				//GenConstants.LacunaInstance.getManInstance().allowHorizontal(false);
			}
			trace("end cntct", contactCount);
			
			GenConstants.LacunaInstance.getManInstance().contactCount = contactCount;
			
			super.EndContact(contact);
		}
	}
}
package  
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	/**
	 * ...
	 * @author Siddhant Tuli
	 * @author Anant Subramanian
	 */
	public class GenConstants 
	{
		public static var levelWidth:int;
		public static var levelHeight:int;
		public static const RATIO:int = 30;
		public static const unitToPixels:int = 60;
		public static var grav:b2Vec2 = new b2Vec2(0, 10);
		public static var LacWorld:b2World;
		
		public static const HORIZONTAL:int = 0;
		public static const VERTICAL:int = 1;
		
		public static const MIDDLE:int = 0;
		public static const LEFT_CORNER:int = 1;
		public static const RIGHT_CORNER:int = 2;
		public static const BOTH_CORNER:int = 3;
		
		// DIRECTION CONSTANTS
		public static const LEFT:int = 0;
		public static const UP:int = 1;
		public static const RIGHT:int = 2;
		public static const DOWN:int = 3;
		
		public static var grvityDir:int = 0;			// ANY OF THE DIRECTION CONSTANTS FIT HERE
		
		public static const jumpCap:int = 2;
		
		// Lacuna instance
		public static var LacunaInstance:Lacuna = null;
		
		public static const MAXJUMP:int = 2;
		public static var JUMP_IMPULSE:Number = 3.5;
		
		public static function setWorldDimensions(_wid:int, _hei:int) {
			levelWidth = _wid;
			levelHeight = _hei;
		}
		
		public static function getWidthUnits():int {
			return levelWidth;
		}
		
		public static function getHeightUnits():int {
			return levelHeight;
		}
		
		public static function getLevelWidth():int {
			return levelWidth * unitToPixels;
		}
		
		public static function getLevelHeight():int {
			return levelHeight * unitToPixels;
		}
	}
}
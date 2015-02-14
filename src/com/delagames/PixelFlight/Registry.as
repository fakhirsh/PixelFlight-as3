package com.delagames.PixelFlight 
{
	import com.delagames.PixelFlight.objects.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class Registry 
	{
		public static var ads:FGLAds;
		
		public static const MAX_SCORE_LIMIT:int = 999999999;
		public static const LOW_FUEL_LIMIT:int = 30;
		public static var MAX_LIVES:int = 3;
		
		public static const VERSION:Number = 1.0;
		
		public static var player:Player;
		public static var hud:HUD;
		public static var fuelCollectEmitter:FlxEmitter;
		public static var playerDeadEmitter:FlxEmitter;
		public static var spawnPointEmitter:FlxEmitter;
		public static var highScoreEmitter:FlxEmitter;
		
		public static var score:int;
		public static var lives:int;
		public static var clickedSponsorLogo:Boolean = false;
		
		public static var gameOver:Boolean;
		
		public static var MUTE:Boolean = false;
		
		public static var BEST_SCORE:int = 0;
		
		public static var gamePlayMusicPtr:FlxSound;
		
		public function Registry() 
		{
			
		}
		
	}

}
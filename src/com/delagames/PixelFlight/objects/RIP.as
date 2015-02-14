package com.delagames.PixelFlight.objects 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class RIP extends FlxSprite 
	{
		
		public function RIP(X:int, Y:int) 
		{
			[Embed(source = "../../../../../assets/art/player_death_point.png")] var RIPGFX:Class;
			
			loadGraphic(RIPGFX);
			
			this.x = X;
			this.y = Y;
			
		}
		
	}

}
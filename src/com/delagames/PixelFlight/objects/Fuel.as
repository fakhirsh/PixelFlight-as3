package com.delagames.PixelFlight.objects 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class Fuel extends FlxSprite 
	{
		public static const FUEL_AMOUNT:int = 30;
		
		[Embed(source="../../../../../assets/sound/fuel_collect.mp3")] private var FuelCollectSFX:Class;
		private var _fuelCollectSoundPtr:FlxSound;
		
		public function Fuel(X:int, Y:int) 
		{
			[Embed(source = "../../../../../assets/art/fuel.png")] var FuelGFX:Class;
			
			loadGraphic(FuelGFX);
			x = X;
			y = Y;
			
			this.offset.x = 4;
			this.offset.y = 5;
			this.width = this.width - 11;
			this.height = this.height - 8;
			
			_fuelCollectSoundPtr = FlxG.play(FuelCollectSFX, 0.85);
			_fuelCollectSoundPtr.stop();
		}
		
		public function Destroy():void
		{
			
		}
		
		public function PlayFuelCollectSound():void
		{
			_fuelCollectSoundPtr.play(true);
		}

		public function StopFuelCollectSound():void
		{
			_fuelCollectSoundPtr.stop();
		}
	}

}
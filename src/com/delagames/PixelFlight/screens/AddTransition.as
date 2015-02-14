package com.delagames.PixelFlight.screens 
{
	import com.delagames.PixelFlight.Registry;
	import flash.events.Event;
	import flash.ui.Mouse;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class AddTransition extends FlxState 
	{
		
		public function AddTransition() 
		{
			
		}
		
		override public function create():void
		{
			super.create();
			Mouse.show();
			FlxG.bgColor = 0xff000000;
			
			//Registry.ads.addEventListener(FGLAds.EVT_AD_CLOSED, enableGame);
			//Registry.ads.addEventListener(FGLAds.EVT_AD_LOADING_ERROR, enableGame);
			
			enableGame();
		}
		
		override public function update():void
		{
			Mouse.show();	
			super.update();
		}
		
		private function enableGame(e:Event = null):void 
		{
            // removing listeners
			//Registry.ads.removeEventListener(FGLAds.EVT_AD_CLOSED, enableGame);
            //Registry.ads.removeEventListener(FGLAds.EVT_AD_LOADING_ERROR, enableGame);
            
			// start the game
            init();
        }
		
		private function init():void{
            FlxG.switchState(new Splash2());
        }
		
	}

}
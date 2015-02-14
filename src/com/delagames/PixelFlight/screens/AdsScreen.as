package com.delagames.PixelFlight.screens 
{
	import flash.events.Event;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class AdsScreen extends FlxState 
	{
		private var ads:FGLAds;
		
		public function AdsScreen() 
		{

		}
		
		override public function create():void
		{
			ads = new FGLAds(stage, "FGL-00000000");
			ads.addEventListener(FGLAds.EVT_API_READY, showStartupAd);
			
		}
		
		public function showStartupAd(e:Event):void
		{
			ads.showAdPopup();
		}
		
	}

}
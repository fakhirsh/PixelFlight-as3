package com.delagames.PixelFlight.screens 
{
	import com.delagames.PixelFlight.Registry;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.net.*;
	import flash.ui.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class Splash2 extends FlxState 
	{
		
		public function Splash2() 
		{
			
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xffffffff;
			
			var logo:FlxButton = new FlxButton(150, 100, null, OnLogoClick);
			[Embed(source = "../../../../../assets/art/logo_large.png")] var SponsorLogoGFX:Class;
			logo.loadGraphic(SponsorLogoGFX);
			add(logo);
			logo.alpha = 0.0;
			TweenMax.to(logo, 1.5, {alpha:1.0, ease:Cubic.easeOut});
			
			
			TweenMax.delayedCall(3.0, ResetDelayFn);
		
		}
		
		private function OnLogoClick():void 
		{
			navigateToURL(new URLRequest("https://www.facebook.com/gamesbyfakhir"), "_blank");
			DAnalytics.Get().ReportMetric("SplashScreen_Sponsor_Clicked");
		}
		
		private function ResetDelayFn():void
		{
			FlxG.switchState(new MainMenu());
		}
		
		override public function update():void
		{
			Mouse.show();	
			super.update();
		}
	}

}
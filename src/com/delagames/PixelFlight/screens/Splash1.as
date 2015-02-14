package com.delagames.PixelFlight.screens 
{
	import com.greensock.TweenMax;
	import flash.net.*;
	import flash.ui.Mouse;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class Splash1 extends FlxState 
	{
		
		public function Splash1() 
		{
			
		}
		
		override public function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xffffffff;
			
			var logo:FlxButton = new FlxButton(100, 100, null, OnLogoClick);
			[Embed(source = "../../../../../assets/art/sponsor_logo.png")] var SponsorLogoGFX:Class;
			logo.loadGraphic(SponsorLogoGFX);
			add(logo);
			
			TweenMax.delayedCall(2.0, ResetDelayFn);
		}
		
		private function OnLogoClick():void 
		{
			navigateToURL(new URLRequest("https://www.facebook.com/gamesbyfakhir"), "_blank");
		}
		
		private function ResetDelayFn():void
		{
			FlxG.switchState(new Splash2());
		}
		
		override public function update():void
		{
			Mouse.show();	
			super.update();
		}
	}

}
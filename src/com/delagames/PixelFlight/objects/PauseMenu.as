package com.delagames.PixelFlight.objects 
{
	import com.delagames.PixelFlight.*;
	import com.delagames.PixelFlight.screens.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class PauseMenu extends FlxGroup 
	{
		
		[Embed(source = "../../../../../assets/art/gameOverScreen_BG.png")] private var PauseMenuGFX:Class;
		
		private var menuBG:FlxSprite;
		private var lbl:FlxText;
		private var lbl1:FlxText;
		private var lbl2:FlxText;
		private var lbl3:FlxText;
		private var lbl4:FlxText;
		private var lbl5:FlxText;
		
		public function PauseMenu() 
		{
			menuBG = new FlxSprite(92, 60, PauseMenuGFX);
			menuBG.alpha = 0.9;
			menuBG.scrollFactor = new FlxPoint(0, 0);
			this.add(menuBG);
			
			lbl = new FlxText(0, 120, FlxG.width, "Game Paused");
			lbl.size = 30;
			lbl.shadow = 0xff000000;
			lbl.alignment = "center";
			lbl.scrollFactor = new FlxPoint(0, 0);
			this.add(lbl);
			
			lbl = new FlxText(0, 200, FlxG.width, "Press 'P' to resume");
			lbl.size = 16;
			lbl.shadow = 0xff000000;
			lbl.alignment = "center";
			lbl.scrollFactor = new FlxPoint(0, 0);
			this.add(lbl);
			
			lbl = new FlxText(0, 240, FlxG.width, "Press 'R' to restart");
			lbl.size = 16;
			lbl.shadow = 0xff000000;
			lbl.alignment = "center";
			lbl.scrollFactor = new FlxPoint(0, 0);
			this.add(lbl);

			lbl = new FlxText(0, 280, FlxG.width, "Press 'Q' to quit");
			lbl.size = 16;
			lbl.shadow = 0xff000000;
			lbl.alignment = "center";
			lbl.scrollFactor = new FlxPoint(0, 0);
			this.add(lbl);
			
			
		}
		
		public function Show():void
		{
			
		}
		
		public function Hide():void
		{
			
		}
		
		public function Update():void
		{
			if(FlxG.keys.justPressed("Q"))
			{
				FlxG.mute = Registry.MUTE;
				FlxG.paused = false;
				FlxG.switchState(new MainMenu());
			}
			else if(FlxG.keys.justPressed("R"))
			{
				FlxG.mute = Registry.MUTE;
				FlxG.paused = false;
				FlxG.switchState(new Gameplay());
			}
			
		}
	}

}
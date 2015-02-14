package com.delagames.PixelFlight.screens 
{
	import com.delagames.PixelFlight.SoundManager;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	import org.flixel.plugin.photonstorm.FX.StarfieldFX;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class Credits extends FlxState 
	{
		
		private var _starfield:StarfieldFX;
		private var _stars:FlxSprite;
		
		//private var _mainMenuMusicPtr:FlxSound;
		
		public function Credits() 
		{
			
		}
		
		override public function create():void
		{
			DAnalytics.Get().ReportMetric("Credits_Accessed");
			
			if (FlxG.getPlugin(FlxSpecialFX) == null)
			{
				FlxG.addPlugin(new FlxSpecialFX);
			}
			_starfield = FlxSpecialFX.starfield();
			_stars = _starfield.create(0, 0, FlxG.width, FlxG.height, 500);
			_stars.scrollFactor = new FlxPoint(0,0);
			add(_stars);
			
			var lbl:FlxText = new FlxText(0, 40, FlxG.width, "Credits");
			lbl.size = 30;
			lbl.alignment = "center";
			add(lbl);
			
			lbl = new FlxText(0, 110, FlxG.width, "Artwork");
			lbl.size = 16;
			lbl.alignment = "center";
			add(lbl);
			
			lbl = new FlxText(0, 130, FlxG.width, "Programming");
			lbl.size = 16;
			lbl.alignment = "center";
			add(lbl);
			
			lbl = new FlxText(0, 150, FlxG.width, "Fakhir Shaheen");
			lbl.size = 24;
			lbl.alignment = "center";
			add(lbl);
			
			lbl = new FlxText(0, 200, FlxG.width, "Sponsored by");
			lbl.size = 16;
			lbl.alignment = "center";
			add(lbl);
			
			
			var sponsorBtn:FlxButton = new FlxButton(270, 230, null, OnSponsorBtn);
			[Embed(source = "../../../../../assets/art/sponsor_logo_small.png")] var SponsorLogoSmallGFX:Class;
			sponsorBtn.loadGraphic(SponsorLogoSmallGFX);
			sponsorBtn.scrollFactor = new FlxPoint(0, 0);
			add(sponsorBtn);
			

			lbl = new FlxText(0, 300, FlxG.width, "Special thanks");
			lbl.size = 16;
			lbl.alignment = "center";
			add(lbl);
			
			lbl = new FlxText(0, 330, FlxG.width, "Asad, Ali Syed, Zarathustra, Chanez, Andrei");
			lbl.size = 12;
			lbl.alignment = "center";
			add(lbl);
			
			lbl = new FlxText(0, 350, FlxG.width, "Eirij, Fahad, Asim");
			lbl.size = 12;
			lbl.alignment = "center";
			add(lbl);
			
			lbl = new FlxText(0, 377, FlxG.width, "Music: Kevin MacLeod (incompetech.com)");
			lbl.size = 8;
			lbl.alignment = "center";
			add(lbl);
			lbl = new FlxText(0, 386, FlxG.width, "Black Vortex, ");
			lbl.size = 8;
			lbl.alignment = "center";
			add(lbl);
			
			var backBtn:FlxButton = new FlxButton(30, 350, "Back", OnBackBtn);
			add(backBtn);
			
			//[Embed(source = "../../../../../assets/sound/mainMenu_music.mp3")] var MainMenuMusicSFX:Class;
			//_mainMenuMusicPtr = FlxG.play(MainMenuMusicSFX, 0.9, true); 
			SoundManager.Get().PlayMainMenuMusic();
		}
		
		private function OnSponsorBtn():void 
		{
			navigateToURL(new URLRequest("https://www.facebook.com/gamesbyfakhir"), "_blank");
			DAnalytics.Get().ReportMetric("Credits_Sponsor_Clicked");
		}
		
		override public function update():void
		{
			Mouse.show();
						
			if(FlxG.keys.justPressed("P"))
			{
				
			}
			if(FlxG.keys.justPressed("M"))
			{
				if(FlxG.mute == false)
					FlxG.mute = true;
				else
					FlxG.mute = false;
			}
			
			super.update();
		}
		
		private function OnBackBtn():void 
		{
			//_mainMenuMusicPtr.stop();
			SoundManager.Get().StopMainMenuMusic();
			FlxG.switchState(new MainMenu());
		}
		
		private function DestroyStarField():void 
		{
			_stars.destroy();
			_starfield.destroy();
		}
		
		override public function destroy():void
		{
			DestroyStarField();
			
			super.destroy();
		}
		
	}

}
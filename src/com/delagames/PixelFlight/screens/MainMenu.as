package com.delagames.PixelFlight.screens 
{
	import com.delagames.PixelFlight.Registry;
	import com.delagames.PixelFlight.SoundManager;
	import com.greensock.TweenMax;
	import flash.ui.Mouse;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	import org.flixel.plugin.photonstorm.FX.StarfieldFX;
	import flash.net.*;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class MainMenu extends FlxState 
	{
		private var _starfield:StarfieldFX;
		private var _stars:FlxSprite;
		
		private var _clickedOnce:Boolean = false;
		
		//private var _mainMenuMusicPtr:FlxSound;
		
		public function MainMenu() 
		{
			
		}
		
		override public function create():void
		{
			DAnalytics.Get().ReportMetric("MainMenu_Accessed");
			
			super.create();
			
			var shared:SharedObject = SharedObject.getLocal("BEST_SCORE");
            if (shared.data.bestScore==undefined) {
                shared.data.bestScore = 0;
            }
            Registry.BEST_SCORE = shared.data.bestScore;
			trace("Shared Object best score: " + Registry.BEST_SCORE);
			shared.close();
			
			shared = SharedObject.getLocal("FACEBOOK_LIKE_CLICKED");
			if (shared.data.facebookLikeClicked == undefined) {
				// Facebook like has not been clicked yet. Proceed with 3 lives.
				Registry.MAX_LIVES = 3;
			}
			else
			{
				// Facebook like button clicked. Grant 6 lives.
				Registry.MAX_LIVES = 6;
			}
            shared.close();
			
			Mouse.show();
			
			FlxG.bgColor = 0xff000000;
			//FlxG.visualDebug = true;
			
			if (FlxG.getPlugin(FlxSpecialFX) == null)
			{
				FlxG.addPlugin(new FlxSpecialFX);
			}
			_starfield = FlxSpecialFX.starfield();
			_stars = _starfield.create(0, 0, FlxG.width, FlxG.height, 500);
			_stars.scrollFactor = new FlxPoint(0,0);
			add(_stars);

			
			var sponsorBtn:FlxButton = new FlxButton(FlxG.width - 140, FlxG.height - 80, null, OnSponsorBtn);
			[Embed(source = "../../../../../assets/art/sponsor_logo_small.png")] var SponsorLogoSmallGFX:Class;
			sponsorBtn.loadGraphic(SponsorLogoSmallGFX);
			sponsorBtn.scrollFactor = new FlxPoint(0, 0);
			add(sponsorBtn);
			
			CreateLabels();
			CreateShipGraphic();
			CreateMenu();
			
			//[Embed(source = "../../../../../assets/sound/mainMenu_music.mp3")] var MainMenuMusicSFX:Class;
			//_mainMenuMusicPtr = FlxG.play(MainMenuMusicSFX, 0.9, true); 
			
			//SoundManager.Get().PlayMainMenuMusic();
			
		}
		
		private function OnSponsorBtn():void 
		{
			navigateToURL(new URLRequest("https://www.facebook.com/gamesbyfakhir"), "_blank");
			DAnalytics.Get().ReportMetric("MainMenu_Sponsor_Clicked");
		}
		
		override public function update():void
		{
			Mouse.show();
			
			if(FlxG.keys.justPressed("P"))
			{
				//FlxG.paused = !FlxG.paused;
			}
			if(FlxG.keys.justPressed("M"))
			{
				Registry.MUTE = !Registry.MUTE;
				
				//if(FlxG.mute == false)
				//	FlxG.mute = true;
				//else
				//	FlxG.mute = false;
			}
			
			FlxG.mute = Registry.MUTE;
			
			super.update();
		}
		
		private function CreateLabels():void
		{
			var lbl:FlxText = new FlxText(-10, 80, FlxG.width, "Pixel");
			lbl.size = 70;
			lbl.alignment = "center";
			lbl.color = 0xffffffff;
			add(lbl);

			lbl = new FlxText(40, 150, FlxG.width, "flight");
			lbl.size = 45;
			lbl.alignment = "center";
			lbl.color = 0xffffffff;
			add(lbl);
			
			lbl = new FlxText(0, 350, FlxG.width, "Press 'm' to mute/unmute");
			lbl.size = 14;
			lbl.alignment = "center";
			lbl.color = 0xffffffff;
			add(lbl);
			
			lbl = new FlxText(0, 368, FlxG.width, "Press 'p' to pause/unpause");
			lbl.size = 14;
			lbl.alignment = "center";
			lbl.color = 0xffffffff;
			add(lbl);
		}
		
		private function CreateShipGraphic():void
		{
			[Embed(source = "../../../../../assets/art/ship.png")] var ShipGFX:Class;
			[Embed(source = "../../../../../assets/art/exhaust_left.png")] var ExhaustLeftGFX:Class;
			[Embed(source = "../../../../../assets/art/exhaust_bottom.png")] var ExhaustBottomGFX:Class;
			
			var X:int = 340;
			var Y:int = 50;
			
			var ship:FlxSprite = new FlxSprite(X + 5, Y + 0, ShipGFX);
			add(ship);
			
			var leftExhaust:FlxSprite = new FlxSprite(X + 1, Y + 9);
			leftExhaust.loadGraphic(ExhaustLeftGFX, true, false, 9, 11);
			leftExhaust.addAnimation("LeftExhaustON", [1, 2, 3], 15);
			leftExhaust.play("LeftExhaustON");
			add(leftExhaust);
			
			var bottomExhaust:FlxSprite = new FlxSprite(X + 23, Y + 25);
			bottomExhaust.loadGraphic(ExhaustBottomGFX, true, false, 11, 9);
			bottomExhaust.addAnimation("BottomExhaustON", [1, 2, 3], 30);
			bottomExhaust.play("BottomExhaustON");
			add(bottomExhaust);
		}
		
		private function CreateMenu():void
		{
			var X:int = FlxG.width / 2 - 40;
			var Y:int = 230;
			var GAP:int = 30;
			
			var playBtn:FlxButton = new FlxButton(X, Y + GAP * 0, "Play", OnPlayBtn);
			add(playBtn);
			
			var creditsBtn:FlxButton = new FlxButton(X,  Y + GAP * 1, "Credits", OnCreditsBtn);
			add(creditsBtn);
			
			var moreGamesBtn:FlxButton = new FlxButton(X,  Y + GAP * 2, "More Games", OnMoreGamesBtn);
			add(moreGamesBtn);
		}
		
		private function OnMoreGamesBtn():void 
		{
			[Embed(source = "../../../../../assets/sound/fuel_collect.mp3")] var FuelCollectSFX:Class;
			FlxG.play(FuelCollectSFX);
			navigateToURL(new URLRequest("https://www.facebook.com/gamesbyfakhir"), "_blank");
			DAnalytics.Get().ReportMetric("MoreGames_Clicked");
		}
		
		private function OnCreditsBtn():void 
		{
			if (_clickedOnce) return;
			_clickedOnce = true;
			
			[Embed(source = "../../../../../assets/sound/fuel_collect.mp3")] var FuelCollectSFX:Class;
			FlxG.play(FuelCollectSFX);
			TweenMax.delayedCall(0.5, CreditsBtnClickDelay);
			
		}
		
		private function CreditsBtnClickDelay():void
		{
			//_mainMenuMusicPtr.stop();
			SoundManager.Get().StopMainMenuMusic();
			FlxG.switchState(new Credits());
		}
		
		private function OnPlayBtn():void
		{
			if (_clickedOnce) return;
			_clickedOnce = true;

			FlxG.shake(0.005, 0.35);
			FlxG.flash(0xffffffff, .35);
			[Embed(source = "../../../../../assets/sound/ShipDestroy.mp3")] var DestroySFX:Class;
			FlxG.play(DestroySFX);
			TweenMax.delayedCall(1.0, PlayBtnClickDelay);
		}
		
		private function PlayBtnClickDelay():void
		{
			//_mainMenuMusicPtr.stop();
			SoundManager.Get().StopMainMenuMusic();
			FlxG.switchState(new Gameplay());
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
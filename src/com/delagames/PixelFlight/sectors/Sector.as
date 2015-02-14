package com.delagames.PixelFlight.sectors 
{
	import com.delagames.PixelFlight.objects.*;
	import com.delagames.PixelFlight.Registry;
	import com.delagames.PixelFlight.screens.Gameplay;
	import com.delagames.PixelFlight.screens.MainMenu;
	import com.delagames.PixelFlight.SoundManager;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author fakhir
	 */
	
	 /*
	  * Sector Width: 150
	  * Sector height: variable
	  * 
	  */
	 
	public class Sector 
	{
		protected var _collectableGroup:FlxGroup;
		protected var _collisionLayer:FlxTilemap;
		protected var _spawnPointList:Array;
		protected var _visualLayer:FlxTilemap;
		protected var _currentSpawnPoint:FlxPoint;
		protected var _state:FlxGroup;
		
		private var _spawnPointUpdated:Boolean;
		
		private var _width:int;
		private var _height:int;
		
		public var nextSectorLoaded:Boolean;
		
		public function Sector() 
		{
			Mouse.show();
			nextSectorLoaded = false;
			_currentSpawnPoint = new FlxPoint(0, 0);
			
		}
		
		private function PlayerCollided(og1:FlxBasic, og2:FlxBasic):void
		{
			//return;
			
			Registry.player.Destroy();
			Registry.lives --;
			if (Registry.lives < 0) Registry.lives = 0;
			
			if (Registry.lives > 0)
			{
				var DELAY:Number = 1.8;
				Registry.player.ResetPlayer(_currentSpawnPoint.x, _currentSpawnPoint.y, DELAY);
				TweenMax.delayedCall(DELAY, ReloadCollectables);
			}
			else
			{
				//trace("Game Over");
				Registry.gameOver = true;
				DisplayGameOverScreen();
			}
			
		}
		
		protected function ReloadCollectables():void
		{
			throw "Sector:ReloadCollectables() --> Override this function";
		}

		private function FuelGathered(og1:FlxBasic, og2:FlxBasic):void
		{
			//trace("Fuel gathered");
			var f:Fuel;
			var p:Player;
			
			if (og1 is Fuel) f = og1 as Fuel;
			if (og2 is Fuel) f = og2 as Fuel;
			
			if(f)
			{
				Registry.player.CollectFuel(Fuel.FUEL_AMOUNT);
				Registry.fuelCollectEmitter.at(f);
				Registry.fuelCollectEmitter.start(true, 0.40);
				
				Registry.score += 100;
				
				f.PlayFuelCollectSound();
				_collectableGroup.remove(f);
			}
			
		}

		public function Update():void
		{
			/*
			if(Registry.gameOver)
			{
				if (FlxG.mouse.justPressed() || FlxG.keys.justPressed("SPACE") )
				{
					FlxG.switchState(new Gameplay());
				}
			}
			*/
			
			if (Registry.player.ready)
			{
				FlxG.collide(Registry.player.GetCollisionSprite(), _collisionLayer, PlayerCollided);
				FlxG.collide(Registry.player.GetCollisionSprite(), _collectableGroup, FuelGathered);
			}

			FlxG.collide(Registry.playerDeadEmitter, _collisionLayer);
			UpdateSpawnPoint();
		}
		
		public function Destroy():void
		{
			//trace("Sector Destroyed");
			
			if (_collisionLayer) _state.remove(_collisionLayer);
			if (_visualLayer)_state.remove(_collisionLayer);
		}
		
		protected function LoadLayer(X:int, Y:int, LayerData:String, TileMap:Class):FlxTilemap
		{
			var layer:FlxTilemap = new FlxTilemap();
			layer.loadMap(LayerData, TileMap, 16, 16);
			layer.x = X;
			layer.y = Y;
			return layer;
		}
		
		public function ParseCollectables(collectablesMap:FlxTilemap):void 
		{
			_collectableGroup = new FlxGroup();
			_state.add(_collectableGroup);
			
			for (var ty:int = 0; ty < collectablesMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < collectablesMap.widthInTiles; tx++)
				{
					if (collectablesMap.getTile(tx, ty) == 162)
					{
						_collectableGroup.add(new Fuel(_collisionLayer.x + tx * 16, _collisionLayer.y + ty * 16));
					}
				}
			}
		}

		public function ParseSpawnPoints(spawnPointsMap:FlxTilemap):void 
		{
			_spawnPointList = new Array();

			for (var ty:int = 0; ty < spawnPointsMap.heightInTiles; ty++)
			{
				for (var tx:int = 0; tx < spawnPointsMap.widthInTiles; tx++)
				{
					if (spawnPointsMap.getTile(tx, ty) == 163)
					{
						var p:FlxPoint = new FlxPoint(_collisionLayer.x + tx * 16, _collisionLayer.y + ty * 16);
						_spawnPointList.push(p);
						
						//var lbl:FlxText = new FlxText(p.x-20, p.y+14, 60, "checkpoint");
						//lbl.size = 8;
						//lbl.alpha = 0.3;
						//lbl.alignment = "center";
						//_state.add(lbl);
					}
				}
			}
		}
		
		public function UpdateSpawnPoint():void 
		{
			if (Registry.player == null) return;
			
			for (var i:int = 0; i < _spawnPointList.length; i++)
			{
				var sp:FlxPoint = _spawnPointList[i] as FlxPoint;
				if(sp.x < Registry.player.GetX())
				{
					if (_currentSpawnPoint.x <= sp.x && _currentSpawnPoint != sp)
					{	
						_currentSpawnPoint = sp;
						//trace("Spawn Point updated");
						AnimateSpawnPoint();
					}
				}
			}
		}
		
		public function GetCurrentSpawnPoint():FlxPoint
		{
			return _currentSpawnPoint;
		}
		
		public function GetWidth():int
		{
			return _collisionLayer.width;
		}

		public function GetHeight():int 
		{
			return _collisionLayer.height;
		}

		public function SetX(x:int):void
		{
			
		}
		
		private function AnimateSpawnPoint():void
		{
			[Embed(source = "../../../../../assets/art/current_spawn_point.png")] var CurrentSpawnPointGFX:Class;
			var s:FlxSprite = new FlxSprite(_currentSpawnPoint.x, _currentSpawnPoint.y, CurrentSpawnPointGFX);
			s.alpha = 0.0;
			_state.add(s);
			TweenMax.to(s, 0.5, {alpha:0.4, ease:Cubic.easeOut});
			
			Registry.spawnPointEmitter.at(s);
			Registry.spawnPointEmitter.start(true, 0.40);
				
			[Embed(source = "../../../../../assets/sound/checkpoint.mp3")] var CheckpointGFX:Class;
			FlxG.play(CheckpointGFX, 0.3);
		}
		
		private function DisplayGameOverScreen():void
		{	
			
			// Submit Mindjolt score
			
			var shared:SharedObject;
			var highScoreFLag:Boolean = false;
			if(Registry.score > Registry.BEST_SCORE)
			{
				Registry.BEST_SCORE = Registry.score;
				shared = SharedObject.getLocal("BEST_SCORE");
				if (shared.data.bestScore==undefined) {
					shared.data.bestScore = 0;
				}
				shared.data.bestScore = Registry.BEST_SCORE;
				
				highScoreFLag = true;
				//HighScoreEmmiter();
				
				[Embed(source = "../../../../../assets/sound/high_score.mp3")] var HighScoreGFX:Class;
				FlxG.play(HighScoreGFX);
			}
			
			var X:int = -80;
			
			[Embed(source = "../../../../../assets/art/gameOverScreen_BG.png")] var GameOverScreenBG:Class;
			var bg:FlxSprite = new FlxSprite(172 + X, 60, GameOverScreenBG);
			bg.alpha = 0.96;
			bg.scrollFactor = new FlxPoint(0, 0);
			_state.add(bg);
			
			var lbl:FlxText = new FlxText(330 + X, 100, 300, "Game Over");
			lbl.size = 20;
			lbl.shadow = 0xff000000;
			lbl.scrollFactor = new FlxPoint(0, 0);
			_state.add(lbl);
			
			if (highScoreFLag)
			{
				lbl = new FlxText(330 + X, 135, 200, "High Score:");
				lbl.alpha = 0;
				TweenMax.to(lbl, .75, {startAt:{alpha:0}, alpha:1, repeat:100});
				lbl.size = 20;
			}
			else 
			{
				lbl = new FlxText(370 + X, 135, 200, "Score:");	
				lbl.size = 16;
			}
			
			lbl.shadow = 0xff000000;
			lbl.scrollFactor = new FlxPoint(0, 0);
			_state.add(lbl);
			
			lbl = new FlxText(0, 160, 640, "" + Registry.score);
			if(highScoreFLag)
			{
				TweenMax.to(lbl, .75, {startAt:{alpha:0}, alpha:1, repeat:100});	
			}
			lbl.size = 40;
			lbl.shadow = 0xff000000;
			lbl.alignment = "center";
			lbl.scrollFactor = new FlxPoint(0, 0);
			_state.add(lbl);
			
			shared = SharedObject.getLocal("FACEBOOK_LIKE_CLICKED");
			if (shared.data.facebookLikeClicked==undefined) {
				lbl = new FlxText(180 + X, 230, 450, "Like us to win 3 extra lives :");
				lbl.size = 20;
				lbl.alignment = "center";
				lbl.shadow = 0xff000000;
				lbl.scrollFactor = new FlxPoint(0, 0);
				_state.add(lbl);
				lbl.alpha = 0;
				TweenMax.to(lbl, 1.5, {delay:0.7, alpha:1.0, ease:Elastic.easeOut});
			}
			
			//[Embed(source = "../../../../../assets/art/sponsor_logo_small.png")] var SponsorLogoSmallGFX:Class;
			//var logo:FlxSprite = new FlxSprite(FlxG.width/2+30, 270, SponsorLogoSmallGFX);
			//_state.add(logo);
			
			var sponsorBtn:FlxButton = new FlxButton(FlxG.width/2+30 + X, 270, null, OnSponsorBtn);
			[Embed(source = "../../../../../assets/art/FB_FindUsOnFacebook-100.png")] var SponsorLogoSmallGFX:Class;
			sponsorBtn.loadGraphic(SponsorLogoSmallGFX);
			sponsorBtn.scrollFactor = new FlxPoint(0, 0);
			_state.add(sponsorBtn);
			
			lbl = new FlxText(140 + X, 355, 100, "click to retry");
			lbl.size = 16;
			lbl.alignment = "center";
			lbl.scrollFactor = new FlxPoint(0, 0);
			lbl.shadow = 0xff000000;
			//_state.add(lbl);
			
			var retryBtn:FlxButton = new FlxButton(360 + X, 350, "RETRY", OnRetryBtn);
			retryBtn.scrollFactor = new FlxPoint(0, 0);
			_state.add(retryBtn);
			
		}
		
		private function OnSponsorBtn():void 
		{
			SoundManager.Get().StopAllMusic();
			Registry.clickedSponsorLogo = true;
			Registry.MAX_LIVES = 6;
			
			var shared:SharedObject = SharedObject.getLocal("FACEBOOK_LIKE_CLICKED");
			if (shared.data.facebookLikeClicked==undefined) {
				shared.data.facebookLikeClicked = true;
			}
			shared.data.facebookLikeClicked = true;
			
			navigateToURL(new URLRequest("https://www.facebook.com/gamesbyfakhir"), "_blank");
			DAnalytics.Get().ReportMetric("Facebook_Like_Btn_Clicked");
		}
		
		private function OnRetryBtn():void 
		{
			DAnalytics.Get().ReportMetric("Retry_Btn_Clicked");
			FlxG.switchState(new Gameplay())
			//MindJoltAPI.service.submitScore(Registry.score, null, FlxG.switchState(new MainMenu()));
		}

		private function HighScoreEmmiter():void
		{
			var OFF:int = 0;
			var X:int = Math.random() * (FlxG.width - OFF) + OFF;
			var Y:int = Math.random() * (FlxG.height - OFF) + OFF;
			
			var sp:FlxSprite = new FlxSprite(X, Y);
			
			Registry.highScoreEmitter.at(sp);
			Registry.highScoreEmitter.start(true, 7.0);
			
			TweenMax.delayedCall(1.0, HighScoreEmmiter);
		}
	}

}
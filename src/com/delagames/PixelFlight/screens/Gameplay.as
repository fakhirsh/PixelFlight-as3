package com.delagames.PixelFlight.screens 
{
	import com.delagames.PixelFlight.objects.*;
	import com.delagames.PixelFlight.Registry;
	import com.delagames.PixelFlight.sectors.*;
	import com.delagames.PixelFlight.SoundManager;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import flash.ui.Mouse;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	import org.flixel.plugin.photonstorm.FX.StarfieldFX;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class Gameplay extends FlxState 
	{

		private var _sectorOrder:Array;
		
		private var _previousSector:Sector;
		private var _currentSector:Sector;
		private var _nextSector:Sector;
		
		private var _sectorIndex:int;
		private var _nextSectorLoaded:Boolean;
		
		private var _starfield:StarfieldFX;
		private var _stars:FlxSprite;
		
		private var _bgGroup:FlxGroup;
		private var _fgGroup:FlxGroup;
		private var _gameOver:Boolean;
		private var _pauseMenu:PauseMenu;
		
		private var _abouToResume:Boolean = false;
		private var _getReadyLbl:FlxText;
		//private var _gameplayMusicPtr:FlxSound;
		
		public function Gameplay() 
		{
			
		}
		
		override public function create():void
		{
			DAnalytics.Get().ReportMetric("Gameplay_Started");
			
			super.create();
			//FlxG.visualDebug = true;
			
			Registry.gameOver = false;
			Registry.lives = Registry.MAX_LIVES;
			Registry.score = 0;
			
			_bgGroup = new FlxGroup();
			_fgGroup = new FlxGroup();
			
			FlxG.pauseSounds();
			
			if (FlxG.getPlugin(FlxSpecialFX) == null)
			{
				FlxG.addPlugin(new FlxSpecialFX);
			}
			
			_starfield = FlxSpecialFX.starfield();
			_stars = _starfield.create(0, 0, FlxG.width, FlxG.height, 250);
			_stars.scrollFactor = new FlxPoint(0,0);
			_bgGroup.add(_stars);
			
			InitSectorOrder();
			
			_previousSector = null;
			_currentSector = null;
			_nextSector = null;
			_sectorIndex = 0;
			_nextSectorLoaded = false;
			
			LoadFirstSector();
			
			Registry.player = new Player(_bgGroup);
			Registry.player.SetPosition(55, 128);	
			
			Registry.hud = new HUD(_fgGroup);
			
			InitEmitters();
			
			FlxG.worldBounds.x = 0;
			FlxG.worldBounds.y = 0;
			FlxG.worldBounds.width = 999999999;
			FlxG.worldBounds.height = 10000;
			
			add(_bgGroup);
			add(_fgGroup);
			
			_pauseMenu = new PauseMenu();
			
			_getReadyLbl = new FlxText(0, 150, FlxG.width, "Get Ready");
			_getReadyLbl.size = 30;
			_getReadyLbl.shadow = 0xff000000;
			_getReadyLbl.alignment = "center";
			_getReadyLbl.scrollFactor = new FlxPoint(0, 0);
			_getReadyLbl.alpha = 0;
			_fgGroup.add(_getReadyLbl);
			
			//[Embed(source = "../../../../../assets/sound/gameplay_music.mp3")] var GameplayMusicSFX:Class;
			//_gameplayMusicPtr = FlxG.play(GameplayMusicSFX, 0.32, true); 
			SoundManager.Get().StopAllMusic();
			SoundManager.Get().PlayGameplayMusic();
			
		}
		
		private function InitEmitters():void
		{
			Registry.playerDeadEmitter = new FlxEmitter();
			Registry.playerDeadEmitter.lifespan = 0;
			Registry.playerDeadEmitter.setXSpeed( -100, 100);
			Registry.playerDeadEmitter.setYSpeed( -100, 0);
			Registry.playerDeadEmitter.setRotation( -720, 720);
			Registry.playerDeadEmitter.gravity = 420 / 2;
			[Embed(source = "../../../../../assets/art/ship_destroy_particles.png")] var ShipDestroyParticlesGFX:Class;
			Registry.playerDeadEmitter.makeParticles(ShipDestroyParticlesGFX, 60, 15, true, 0.5); // no more createSprites
			Registry.playerDeadEmitter.bounce = 0.85; // bounce is a separated member variable
			_bgGroup.add(Registry.playerDeadEmitter);
			
			Registry.fuelCollectEmitter = new FlxEmitter();
			Registry.fuelCollectEmitter.lifespan = 0.05;
			Registry.fuelCollectEmitter.setXSpeed( -550, 550);
			Registry.fuelCollectEmitter.setYSpeed( -550, 550);
			Registry.fuelCollectEmitter.setSize(1, 1);
			Registry.fuelCollectEmitter.setRotation( -720, 720);
			//Registry.fuelCollectEmitter.gravity = 420 / 2;
			[Embed(source = "../../../../../assets/art/fuel_collect_particles.png")] var FuelCOllectParticlesGFX:Class;
			Registry.fuelCollectEmitter.makeParticles(FuelCOllectParticlesGFX, 30, 15, true, 0.5); // no more createSprites
			//Registry.fuelCollectEmitter.bounce = 0.85; // bounce is a separated member variable
			_bgGroup.add(Registry.fuelCollectEmitter);
			

			Registry.highScoreEmitter = new FlxEmitter();
			Registry.highScoreEmitter.lifespan = 0;
			Registry.highScoreEmitter.setXSpeed( -100, 100);
			Registry.highScoreEmitter.setYSpeed( -100, 0);
			Registry.highScoreEmitter.setRotation( -720, 720);
			Registry.highScoreEmitter.gravity = 420 / 2;
			Registry.highScoreEmitter.makeParticles(ShipDestroyParticlesGFX, 60, 15, true, 0.5); // no more createSprites
			Registry.highScoreEmitter.bounce = 0.85; // bounce is a separated member variable
			_fgGroup.add(Registry.highScoreEmitter);

			
			Registry.spawnPointEmitter = new FlxEmitter();
			Registry.spawnPointEmitter.lifespan = 0.05;
			Registry.spawnPointEmitter.setXSpeed( -550, 550);
			Registry.spawnPointEmitter.setYSpeed( -550, 550);
			Registry.spawnPointEmitter.setSize(1, 1);
			Registry.spawnPointEmitter.setRotation( -720, 720);
			[Embed(source = "../../../../../assets/art/spawn_point_particles.png")] var SpawnPointParticlesGFX:Class;
			Registry.spawnPointEmitter.makeParticles(SpawnPointParticlesGFX, 30, 15, true, 0.5); // no more createSprites
			_bgGroup.add(Registry.spawnPointEmitter);
			
		}
		
		override public function update():void
		{
			Mouse.show();
			
			if (FlxG.keys.justPressed("P"))
			{
				_getReadyLbl.alpha = 0;
				if (!FlxG.paused)
				{
					FlxG.paused = true;
					FlxG.mute = true;
					add(_pauseMenu);
				}
				else if(!_abouToResume)
				{
					FlxG.mute = Registry.MUTE;
					remove(_pauseMenu);
					TweenMax.delayedCall(1, ResumeGameDelay);
					TweenMax.to(_getReadyLbl, 0.4, { alpha:1.0, ease:Cubic.easeOut } );
					_abouToResume = true;
				}
			}
			
			if (FlxG.paused) {
				_pauseMenu.Update();
				return;
			}
			
			if(FlxG.keys.justPressed("M"))
			{
				Registry.MUTE = !Registry.MUTE;
				FlxG.mute = Registry.MUTE;
				//if(FlxG.mute == false)
				//	FlxG.mute = true;
				//else
				//	FlxG.mute = false;
			}
			
			if (Registry.player)
			{	
				if (Registry.player.ready)
				{
					Registry.score += 3;
					if(Registry.score > Registry.MAX_SCORE_LIMIT)
					{
						Registry.score = Registry.MAX_SCORE_LIMIT;
					}
				}
				Registry.player.Update();
				
				_currentSector.Update();
				
				ManageSectors();
				
				var sx:Number = -((Registry.player.GetVelocityX() / Player.MAX_SPEED) * 1.6);
				var sy:Number = -((Registry.player.GetVelocityY() / Player.MAX_SPEED) * 1.6);
				_starfield.setStarSpeed(sx, 0);
				
			}
			
			UpdateHUD();
			
			super.update();
		}
		
		private function ResumeGameDelay():void
		{
			_getReadyLbl.alpha = 0;
			FlxG.paused = false;
			_abouToResume = false;
		}
		
		private function UpdateHUD():void
		{
			Registry.hud.SetFuelBar(Registry.player.GetFuelLeft());
			Registry.hud.SetScore(Registry.score);
			Registry.hud.SetLives(Registry.lives);
		}
		
		private function ManageSectors():void
		{
			if((Registry.player.GetX() > ((_sectorIndex + 1) * _currentSector.GetWidth() - 640)) && !_nextSectorLoaded)
			{
				trace("Load next sector");
				LoadNextSector();
				_nextSectorLoaded = true;
			}
			
			if (Registry.player.GetX() > ((_sectorIndex + 1) * _currentSector.GetWidth()) && _nextSectorLoaded)
			{
				_previousSector = _currentSector;
				_currentSector = _nextSector;
				_sectorIndex++;
				_nextSectorLoaded = false;
				
				trace("Sector: " + _sectorIndex);
			}
			
			
		}
		
		private function LoadFirstSector():void
		{
			var SectorClass:Class = _sectorOrder[_sectorIndex] as Class;				
			_currentSector = new SectorClass(0, 0, _bgGroup);
		}
		
		private function LoadNextSector():void
		{
			if (_previousSector)
			{
				trace("Previous sector destroyed");
				_previousSector.Destroy();
			}
			
			var i:int;
			if (_sectorIndex < _sectorOrder.length-1)
			{
				i = _sectorIndex + 1;
			}
			else
			{
				i = 1 + Math.random() * (_sectorOrder.length-1);
			}
			trace(i);
			var SectorClass:Class = _sectorOrder[i] as Class;
			_nextSector = new SectorClass((_sectorIndex + 1) * _currentSector.GetWidth(), 0, _bgGroup);
		}
		
		private function InitSectorOrder():void
		{
			_sectorOrder = new Array();
			
			_sectorOrder.push(Sector1);
			_sectorOrder.push(Sector2);
			_sectorOrder.push(Sector7);
			_sectorOrder.push(Sector3);
			_sectorOrder.push(Sector4);
			_sectorOrder.push(Sector5);
			_sectorOrder.push(Sector6);
			
		}
		
		override public function destroy():void
		{
			//_gameplayMusicPtr.stop();
			SoundManager.Get().PlayGameplayMusic();
			_stars.destroy();
			_starfield.destroy();
			
			_fgGroup.destroy();
			_bgGroup.destroy();
			
			super.destroy();
		}
		
	}

}
package com.delagames.PixelFlight.objects 
{
	import com.delagames.PixelFlight.Registry;
	import com.greensock.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class Player 
	{
		public static const ACCELERATION:int = 300;
		public static const DRAG:int = 100;
		public static const MAX_SPEED:int = 200;
		public static const SPEED:int = 150;
		
		public const FUEL_DEPLETE_RATE:Number = 14;
		public const FUEL_WARNING_LIMIT:int = 30;
		public const FUEL_CAPACITY:int = 100;
		
		public var ready:Boolean;
		
		private var _fuelLeft:Number;
		private var _state:FlxGroup;
		
		private var _shipSprite:FlxSprite;
		private var _cameraStubSprite:FlxSprite;
		private var _leftExhaustSprite:FlxSprite;
		private var _bottomExhaustSprite:FlxSprite;
		
		private var _leftExhaustSoundPtr:FlxSound;
		private var _bottomExhaustSoundPtr:FlxSound;
		
		private var _dead:Boolean;
		private var _resetPoint:FlxPoint;
		
		public function Player(state:FlxGroup) 
		{
			_state = state;
			
			_fuelLeft = FUEL_CAPACITY;
			_dead = false;
			ready = false;
			
			_shipSprite = new FlxSprite();
			[Embed(source = "../../../../../assets/art/ship.png")] var ShipGFX:Class;
			_shipSprite.loadGraphic(ShipGFX, true, false, 57, 31);
			_shipSprite.offset.x = 8;
			_shipSprite.offset.y = 8;
			_shipSprite.width = 36;
			_shipSprite.height = 13;
			_shipSprite.maxVelocity = new FlxPoint(MAX_SPEED, MAX_SPEED);
			_state.add(_shipSprite);
			
			_leftExhaustSprite = new FlxSprite();
			[Embed(source = "../../../../../assets/art/exhaust_left.png")] var ExhaustLeftGFX:Class;
			_leftExhaustSprite.loadGraphic(ExhaustLeftGFX, true, false, 9, 11);
			_leftExhaustSprite.addAnimation("LeftExhaustON", [1, 2, 3], 15);
			_leftExhaustSprite.addAnimation("LeftExhaustOFF", [0], 15, true);
			_state.add(_leftExhaustSprite);
			
			_bottomExhaustSprite = new FlxSprite();
			[Embed(source="../../../../../assets/art/exhaust_bottom.png")] var ExhaustBottomGFX:Class;
			_bottomExhaustSprite.loadGraphic(ExhaustBottomGFX, true, false, 11, 9);
			_bottomExhaustSprite.addAnimation("BottomExhaustON", [1, 2, 3], 30);
			_bottomExhaustSprite.addAnimation("BottomExhaustOFF", [0], 30, true);
			_state.add(_bottomExhaustSprite);
			
			_cameraStubSprite = new FlxSprite();
			_cameraStubSprite.loadGraphic(ShipGFX, true, false, 57, 31);
			_cameraStubSprite.alpha = 0;
			_state.add(_cameraStubSprite);
			
			FlxG.camera.follow(_cameraStubSprite, FlxCamera.STYLE_PLATFORMER);
			
			[Embed(source="../../../../../assets/sound/left_exhaust.mp3")] var LeftExhaustSoundSFX:Class;
			_leftExhaustSoundPtr = FlxG.play(LeftExhaustSoundSFX, 0.5, true); 
			_leftExhaustSoundPtr.stop();
			
			[Embed(source="../../../../../assets/sound/bottom_exhaust.mp3")] var BottomExhaustSoundSFX:Class;
			_bottomExhaustSoundPtr = FlxG.play(BottomExhaustSoundSFX, 1.0, true); 
			_bottomExhaustSoundPtr.stop();
		}
		
		public function Update():void
		{
			if (_dead) return;
			
			_cameraStubSprite.x = _shipSprite.x + 190;
			_cameraStubSprite.y = _shipSprite.y - 10;
			_leftExhaustSprite.x = _shipSprite.x - 10;
			_leftExhaustSprite.y = _shipSprite.y + 1;
			_bottomExhaustSprite.x = _shipSprite.x + 10;
			_bottomExhaustSprite.y = _shipSprite.y + 17;
			
			if(ActionKeyJustPressed() && !ready)
			{
				ready = true;
				LeftExhaustON();
			}
			
			if (!ready) return;
			
			SetVelocityX(SPEED);
			
			if(ActionKeyPressed())
			{

				_fuelLeft -= Number(FUEL_DEPLETE_RATE * FlxG.elapsed);
				if(_fuelLeft <= FUEL_WARNING_LIMIT)
				{
					//trace("Warning: Low fuel");
				}
				
				if(_fuelLeft > 0)
				{
					if (ActionKeyJustPressed()) {
						BottomExhaustON();
					}
				}
				
				if(_fuelLeft <= 0)
				{
					_fuelLeft = 0;
					BottomExhaustOFF();
					LeftExhaustOFF();
				}
			}
			else
			{
				BottomExhaustOFF();
			}
		}
		
		public function Destroy():void
		{
			_dead = true;
			ready = false;
			_shipSprite.velocity = new FlxPoint(0, 0);
			_shipSprite.acceleration = new FlxPoint(0, 0);
			
			_shipSprite.alpha = 0.0;
			_leftExhaustSprite.alpha = 0.0;
			_bottomExhaustSprite.alpha = 0.0;
			
			[Embed(source = "../../../../../assets/sound/ShipDestroy.mp3")] var DestroySFX:Class;
			FlxG.play(DestroySFX);
			
			FlxG.shake(0.005, 0.35);
			FlxG.flash(0xffDB3624, .35);
			Registry.playerDeadEmitter.at(_shipSprite);
			Registry.playerDeadEmitter.start(true, 7.80);
			
			FlxG.camera.follow(null);
			
			LeftExhaustOFF();
			BottomExhaustOFF();
			
		}
		
		public function CollectFuel(fuel:int):void
		{
			_fuelLeft += fuel;
			
			if(_fuelLeft > 100)
			{
				_fuelLeft = 100;
			}
		}
		
		public function GetFuelLeft():int
		{
			return _fuelLeft;
		}
	
		public function SetPosition(X:int, Y:int):void
		{
			_shipSprite.x = X;
			_shipSprite.y = Y;
		}
		
		public function GetX():int
		{
			return _shipSprite.x;
		}

		public function GetY():int
		{
			return _shipSprite.y;
		}
		
		public function GetVelocityX():int
		{
			return _shipSprite.velocity.x;
		}
		
		public function GetVelocityY():int
		{
			return _shipSprite.velocity.y;
		}
		
		public function SetVelocityX(vx:int):void
		{
			_shipSprite.velocity.x = vx;
		}
		
		public function SetVelocityY(vy:int):void
		{
			_shipSprite.velocity.y = vy;
		}

		public function SetAccelerationX(ax:int):void
		{
			_shipSprite.acceleration.x = ax;
		}
		
		public function SetAccelerationY(ay:int):void
		{
			_shipSprite.acceleration.y = ay;
		}
		
		public function GetCollisionSprite():FlxSprite
		{
			return _shipSprite;
		}
		
		public function LeftExhaustON():void
		{
			_leftExhaustSprite.play("LeftExhaustON");
			_leftExhaustSoundPtr.play(true);
		}
		
		public function LeftExhaustOFF():void
		{
			_leftExhaustSprite.play("LeftExhaustOFF");
			_leftExhaustSoundPtr.stop();
		}
		
		public function BottomExhaustON():void
		{
			_bottomExhaustSprite.play("BottomExhaustON");
			_bottomExhaustSoundPtr.play(true);
			SetAccelerationY( -ACCELERATION);
		}
		
		public function BottomExhaustOFF():void
		{
			_bottomExhaustSprite.play("BottomExhaustOFF");
			_bottomExhaustSoundPtr.stop();
			SetAccelerationY(ACCELERATION);
		}
		
		public function ResetPlayer(X:int, Y:int, delay:Number):void
		{
			TweenMax.delayedCall(delay, ResetDelayFn);
			_resetPoint = new FlxPoint(X, Y);
		}
		
		private function ResetDelayFn():void
		{
			_shipSprite.x = _resetPoint.x;
			_shipSprite.y = _resetPoint.y;
			_shipSprite.alpha = 1.0;
			_leftExhaustSprite.alpha = 1.0;
			_bottomExhaustSprite.alpha = 1.0;
			_dead = false;
			_fuelLeft = 100;
			FlxG.camera.follow(_cameraStubSprite, FlxCamera.STYLE_PLATFORMER);
			ready = false;
			SetVelocityX(0);
			SetVelocityY(0);
			SetAccelerationX(0);
			SetAccelerationY(0);
		}
		
		public function Dead():Boolean
		{
			return _dead;
		}
		
		public function ActionKeyPressed():Boolean
		{
			if (FlxG.mouse.pressed()) return true;
		
			if (FlxG.keys.SPACE) return true;
			
			return false;
		}
		
		public function ActionKeyJustPressed():Boolean
		{
			if (FlxG.mouse.justPressed()) return true;
			
			if (FlxG.keys.justPressed("SPACE")) return true;
			
			return false;
		}
		
	}

}
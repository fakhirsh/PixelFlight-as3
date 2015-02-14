package com.delagames.PixelFlight.objects 
{
	import com.delagames.PixelFlight.Registry;
	import com.greensock.TweenMax;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class HUD 
	{
		
		private var _state:FlxGroup;
		private var _scoreLbl:FlxText;
		private var _fuelBar:FlxBar;
		private var _livesLbl:FlxText;
		
		private var _fuelBarBorder:FlxBar;
		private var barLbl:FlxText;
		private var _livesLblTEXT:FlxText;
		
		private var _lowFuelSoundPtr:FlxSound;
		private var _alreadyBlinking:Boolean;
		
		public function HUD(state:FlxGroup) 
		{
			_state = state;
			_alreadyBlinking = false;
			
			_scoreLbl = new FlxText(170, 10, 300, "000000000");
			_scoreLbl.scrollFactor = new FlxPoint(0, 0);
			_scoreLbl.size = 20;
			_scoreLbl.shadow = 0xFF000000;
			_state.add(_scoreLbl);
			_scoreLbl.alignment = "center";
		
			_fuelBarBorder = new FlxBar(10, 25, FlxBar.FILL_LEFT_TO_RIGHT, 130, 10);
			[Embed(source="../../../../../assets/art/healthbar_border.png")] var healthBarBorderPNG:Class;
			_fuelBarBorder.createImageBar(null, healthBarBorderPNG, 0x00000000, 0x00000000);
			_fuelBarBorder.scrollFactor = new FlxPoint(0, 0);
			_state.add(_fuelBarBorder);
			_fuelBarBorder.percent = 100;
			
			_fuelBar = new FlxBar(_fuelBarBorder.x, _fuelBarBorder.y - 10, FlxBar.FILL_LEFT_TO_RIGHT, 130, 30);
			[Embed(source = "../../../../../assets/art/healthbar.png")] var healthBarPNG:Class;
			_fuelBar.createImageBar(null, healthBarPNG, 0x00000000, 0x00000000);
			_fuelBar.scrollFactor = new FlxPoint(0, 0);
			_state.add(_fuelBar);
			
			barLbl = new FlxText(10, 10, 100, "Fuel remaining:");
			barLbl.scrollFactor = new FlxPoint(0, 0);
			_state.add(barLbl);
			
			SetFuelBar(100);
			
			_livesLblTEXT = new FlxText(580, 10, 100, "Lives:");
			_livesLblTEXT.scrollFactor = new FlxPoint(0, 0);
			_state.add(_livesLblTEXT);
			
			_livesLbl = new FlxText(_livesLblTEXT.x + 30, 10, 100, "" + 0);
			_livesLbl.scrollFactor = new FlxPoint(0, 0);
			_state.add(_livesLbl);
			
			[Embed(source = "../../../../../assets/sound/low_fuel.mp3")] var LowFuelSFX:Class;
			_lowFuelSoundPtr = FlxG.play(LowFuelSFX, 0.5, true);
			_lowFuelSoundPtr.stop();
		}
		
		static public function zeroPad(number:int, width:int):String {
		   var ret:String = ""+number;
		   while( ret.length < width )
			   ret="0" + ret;
		   return ret;
		}
		
		public function SetScore(score:int):void
		{
			_scoreLbl.text = "" + score;
		}
		
		public function SetLives(lives:int):void
		{
			_livesLbl.text = "" + lives;
		}
		
		
		public function SetFuelBar(percent:Number):void
		{
			_fuelBar.percent = percent;
			
			if (percent <= 0 || percent > Registry.LOW_FUEL_LIMIT)
			{
				StopBlinking();
			}
			else
			{
				StartBlinking();
			}
		}
		
		public function StartBlinking():void
		{
			if (_alreadyBlinking) return;
			
			TweenMax.to(_fuelBar, .25, { startAt: { alpha:0 }, alpha:1, repeat: -1 } );
			_alreadyBlinking = true;
			_lowFuelSoundPtr.play(true);
		}
		
		public function StopBlinking():void
		{
			TweenMax.killTweensOf(_fuelBar);
			_fuelBar.alpha = 1.0;
			_alreadyBlinking = false;
			if (_lowFuelSoundPtr) _lowFuelSoundPtr.stop();
		}
		
		public function Destroy():void
		{
			_state.remove(_fuelBar);
			_state.remove(_fuelBarBorder);
			_state.remove(_scoreLbl);
			_state.remove(_livesLbl);
			_state.remove(barLbl);
			_state.remove(_livesLblTEXT);
		}
		

	}

}
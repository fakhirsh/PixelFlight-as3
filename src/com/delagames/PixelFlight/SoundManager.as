package com.delagames.PixelFlight 
{
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author Fakhir
	 */
	public class SoundManager 
	{
		private var _mainMenuMusicPtr:FlxSound;
		private var _gameplayMusicPtr:FlxSound;
		
		static private var _instance:SoundManager;
		
		public function SoundManager() 
		{
			
		}
		
		static public function Get():SoundManager
		{
			if(!_instance)
			{
				_instance = new SoundManager();
				
				//[Embed(source="../../../../assets/sound/mainMenu_music.mp3")] var MainMenuMusicSFX:Class;
				//_instance._mainMenuMusicPtr = FlxG.play(MainMenuMusicSFX, 0.9, true);
				//_instance._mainMenuMusicPtr.stop();
			}
			return _instance;
		}
		
		public function PlayMainMenuMusic():void
		{
			//_mainMenuMusicPtr.play(true);
			[Embed(source="../../../../assets/sound/mainMenu_music.mp3")] var MainMenuMusicSFX:Class;
			_instance._mainMenuMusicPtr = FlxG.play(MainMenuMusicSFX, 0.9, true);
		}
		
		public function StopMainMenuMusic():void
		{
			if(_mainMenuMusicPtr != null)
				_mainMenuMusicPtr.stop();
		}
		
		public function PlayGameplayMusic():void
		{
			//_mainMenuMusicPtr.play(true);
			[Embed(source = "../../../../assets/sound/gameplay_music.mp3")] var GameplayMusicSFX:Class;
			_gameplayMusicPtr = FlxG.play(GameplayMusicSFX, 0.32, true);
		}
		
		public function StopGameplayMusic():void
		{
			if(_gameplayMusicPtr != null)
				_gameplayMusicPtr.stop();
		}
		
		public function StopAllMusic():void
		{
			StopMainMenuMusic();
			StopGameplayMusic();
		}
	}

}
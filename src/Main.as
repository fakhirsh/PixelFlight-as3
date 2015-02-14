package 
{
	import com.delagames.PixelFlight.screens.*;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import org.flixel.*;

	
	/**
	 * ...
	 * @author fakhir
	 */
	[SWF(width="640", height="400")]
	[Frame(factoryClass="Preloader")]
	public class Main extends FlxGame 
	{
		
		public function Main():void 
		{
			DAnalytics.Get().InitAPI(this);
			
			super(640, 400, AddTransition, 1);
			//FlxG.mouse.show();
		}
		
	}
	
}
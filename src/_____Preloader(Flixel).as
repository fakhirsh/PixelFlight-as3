package
{
	import com.delagames.PixelFlight.Registry;
	import flash.events.Event;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import org.flixel.system.FlxPreloader;
	
	/**
	 * ...
	 * @author fakhir
	 */
	public class Preloader extends FlxPreloader
	{
		private var domainList:Vector.<String> = new Vector.<String>;
		
		public function Preloader()
		{
			//Registry.ads = new FGLAds(stage, "FGL-20027589");
			//Registry.ads.addEventListener(FGLAds.EVT_API_READY, showStartupAd);
			
			className = "Main";
			super();
		}
				
		public function showStartupAd(e:Event):void
		{
			Registry.ads.showAdPopup();
		}
	
	}

}
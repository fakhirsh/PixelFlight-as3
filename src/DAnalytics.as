package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.*;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Fakhir
	 * 
	 * A cuatom Analytics class. Records and updates game metrics and stats on a custom DB hosted
	 * on delagames.com. 
	 * 
	 * Singleton class. Can be accessed from anywhere.
	 */
	public class DAnalytics 
	{
		private var _analyticsEnabled:Boolean;
		private var _loader:URLLoader;
		private var _container:Sprite;
		
		static private var _instance:DAnalytics;
		
		public function DAnalytics() 
		{
			
		}
		/**
		 * Gets the singleton instance. It also automatically initializes it if it is not already so.
		 * 
		 * @return singleton instance
		 */
		static public function Get():DAnalytics
		{
			if(!_instance)
			{
				_instance = new DAnalytics();
				_instance._analyticsEnabled = false;
			}
			return _instance;
		}
		
		/**
		 * Initializes the Analytics API. Checks remote DB whether analytics are enabled 
		 * for the current game or not. In case of success it also calls a function to 
		 * register current Domain in the DB.
		 * 
		 * @param	container	Instance of the top level Main stripe.
		 */
		public function InitAPI(container:Sprite):void
		{
			_container = container;
			
			trace("Initializing DAnalytics API....");
			FlxG.log("Initializing DAnalytics API....");
			
			var urlVars:URLVariables = new URLVariables();
			urlVars.gameName = 'Pixel_Flight';
			
			// Check whether analytics are enabled for the current game.
			SendRequest("http://delagames.com/services/PixelFlight/validateAnalytics.php", urlVars, onAnalyticsAPIInitializeRequest);
		}
		
		/**
		 * Utility function that sends custom POST variables to the service.
		 * 
		 * @param	url				URL of the service to be accessed. PHP page hosted on server.
		 * @param	urlVars			List of POST variables that are to be passed to the PHP service
		 * @param	callBackFn		Function to be called when operation completes.
		 */
		private function SendRequest(url:String, urlVars:URLVariables, callBackFn:Function = null):void
		{
			var urlReq:URLRequest = new URLRequest(url);
			
			// Set the method to POST
			urlReq.method = URLRequestMethod.POST;
			
			// Add the variables to the URLRequest
			urlReq.data = urlVars;  
						
			// Add the URLRequest data to a new Loader
			_loader = new URLLoader(urlReq);
		 
			// Set a listener function to run when completed
			if(callBackFn != null)
				_loader.addEventListener(Event.COMPLETE, callBackFn);
		 
			// Set the loader format to variables and post to the PHP
			_loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			_loader.load(urlReq); 
		}
		
		/**
		 * Private Method.
		 * @param	e	Event containing status information.
		 */
		private function onAnalyticsAPIInitializeRequest(e:Event):void 
		{
			_loader.removeEventListener(Event.COMPLETE, onAnalyticsAPIInitializeRequest);
			
			if(e.target.data.enable_analytics == "true"){
				trace("Analytics Enabled");
				
				_analyticsEnabled = true;
				
				// Adding domain
				var urlVars:URLVariables = new URLVariables();
				urlVars.domainName = GetDomain();
				
				// Increments domain visits on the server. Register a new domain if it doesn't already exist.
				SendRequest("http://delagames.com/services/PixelFlight/PixelFlight_AddDomain.php", urlVars, null);
			}
			else
			{
				trace("Analytics Disabled");
				_analyticsEnabled = false;
			}
		}
		
		/**
		 * Returns domain of the server game is running on.
		 * @return	Domain of the current server
		 */
		private function GetDomain():String
		{
			var domain:String = _container.root.loaderInfo.url.split("/")[2];
			var url:String;
			if (domain == "")
			{
				url = "localhost";
			}
			else {
				url = domain;
			}
			trace("Current domain: " + url);
			return url;
		}
		
		/**
		 * Increments metric access count on the server. If it doesn't exist then automatically 
		 * creates a new one.
		 * 
		 * @param	metric	Name of the metric to be reported.
		 */
		public function ReportMetric(metric:String):void
		{
			if (!_analyticsEnabled) return;
			
			trace("Reporting metric: " + metric);
			
			var urlVars:URLVariables = new URLVariables();
			urlVars.metricName = metric;
			
			// No need for a callback function here.
			SendRequest("http://delagames.com/services/PixelFlight/PixelFlight_ReportMetrics.php", urlVars, null);
		}
	}

}
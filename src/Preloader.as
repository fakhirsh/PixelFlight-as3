package
{
	import com.greensock.easing.BackOut;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	public dynamic class Preloader extends MovieClip
	{
		// Keep track to see if an ad loaded or not
		private var did_load:Boolean;
		private var ad_finished:Boolean;
		
		// Change this class name to your main class
		public static var MAIN_CLASS:String = "Main";
		
		public function Preloader()
		{
			
			[Embed(source="../assets/art/preloaderBG.jpg")]
			var PreloaderBGGFX:Class;
			var bgBmp:Bitmap = new PreloaderBGGFX();
			addChild(bgBmp);
			
			var f:Function = function(ev:IOErrorEvent):void
			{
				// Ignore event to prevent unhandled error exception
			}
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, f);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			addEventListener(Event.ENTER_FRAME, checkFrame);
			
			var opts:Object = {};
			
			opts.ad_started = function():void
			{
				did_load = true;
			}
			
			opts.ad_finished = function():void
			{
				ad_finished = true;
			}
			
			ProgressBar.Init(this);
			
			//MindJoltAPI.service.connect("RPVTPMTLPPTY8FKE", this);
			//MindJoltAPI.ad.showPreGameAd({clip: this, ad_started: opts.ad_started, ad_finished: opts.ad_finished});
		
		}
		
		private function progress(e:ProgressEvent):void 
		{
			var percent:Number = Math.round(e.bytesLoaded / e.bytesTotal * 100);
			ProgressBar.SetProgress(percent);
		}
		
		private function checkFrame(e:Event):void
		{
			if (framesLoaded == totalFrames && (!did_load || ad_finished))
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				
				// don't directly reference the class, otherwise it will be
				// loaded before the preloader can begin
				var mainClass:Class = Class(getDefinitionByName(MAIN_CLASS));
				var app:Object = new mainClass();
				
				addChild(app as DisplayObject);
			}
		}
	}
}
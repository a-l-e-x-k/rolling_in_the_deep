package  
{
    import fl.containers.UILoader;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    import viral.DummyNetworker;
    import viral.FacebookNetworker;
    import viral.ISocial;

    /**
	 * ...
	 * @author Alexey Kuznetsov
	 */
	public final class Networking
	{
		public static const FB:String = "FB";

		public static var flashVars:Object;
		public static var eventDispatcher:EventDispatcher = new EventDispatcher();
		public static var avatars:Dictionary = new Dictionary(); //UI loaders for each kind of avatar
		public static var socialNetworker:ISocial; //just substitute it for another VKNetworker when publishing app on VK or DummyNetworker when testing locally
		
		public static function parseFlashvars($flashVars:Object):void
		{			
			flashVars = $flashVars;
			t.obj(flashVars);

			if (flashVars.fb_user_id)
				socialNetworker = new FacebookNetworker();
			else
				socialNetworker = new DummyNetworker();

			socialNetworker.init(flashVars);
		}
		
		public static function fillAvatar(link:String, uiloader:UILoader, targetWidth:int, targetHeight:int):void
		{
			if (link != null)
			{
				if (avatars[link] == null) 
				{
					var loader:Loader = new Loader();
					loader.load(new URLRequest(link));
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt:Event) //all that business is to avoid security sandbox violation when loading from some domains without crossdomain.xml. Using not an image but a bytes of it
					{
						var lInfo:LoaderInfo = LoaderInfo(evt.target);
						var ba:ByteArray = lInfo.bytes;
						
						var reloader:Loader = new Loader();
						reloader.loadBytes(ba);
						reloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
						reloader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
						reloader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(ev:Event) { reloaderComplete(ev, uiloader, link, targetWidth, targetHeight); } );
					});			
				}
				else
				{
					var pic:Bitmap = dualResize(avatars[link] as Bitmap, targetWidth, targetHeight);
					pic.name = "pic";
					uiloader.addChild(pic);
				}
			}
			else 
			{
				//var questionMC:MovieClip = new ssss();
				//avatar.addChild(questionMC);
			}
		}
		
		static private function securityErrorHandler(e:SecurityErrorEvent):void 
		{
			trace("SecurityError at loading avatar");
		}
		
		static private function ioErrorHandler(e:Event):void 
		{
			trace("IO Error at loading avatar");
		}
		 
		private static function reloaderComplete(evt:Event, avatar:UILoader, link:String, targetWidth:int, targetHeight:int):void
		{
			var imageInfo:LoaderInfo = LoaderInfo(evt.target);
			var bmd:BitmapData = new BitmapData(imageInfo.width,imageInfo.height);
			bmd.draw(imageInfo.loader);
			var resultBitmap:Bitmap = new Bitmap(bmd);

			dualResize(resultBitmap, targetWidth, targetHeight);

			avatar.addChild(resultBitmap);
			avatars[link] = resultBitmap;
		}

		private static function dualResize(bitmap:Bitmap, targetWidth:int, targetHeight:int):Bitmap
		{
			var resizeRatio:Number = targetWidth / bitmap.width;
			bitmap.width *= resizeRatio;
			bitmap.height *= resizeRatio;

			if (bitmap.height < targetHeight) //increase size if got too little due to width resize
			{
				resizeRatio = targetHeight / bitmap.height;
				bitmap.width *= resizeRatio;
				bitmap.height *= resizeRatio;
			}

			return bitmap;
		}
	}
}
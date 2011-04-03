package ru.k0t0vich.core.resource
{
	import flash.display.Bitmap;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import ru.k0t0vich.core.resource.BitmapLoaderEvent;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	/**
	 * загружены все ресурсы из очереди
	 */
	[Event(name = "ALL_COMPLETE", type = "ru.k0t0vich.core.resource.BitmapLoaderEvent")]
	
	/**
	 * ресурс загружен
	 */
	[Event(name="COMPLETE",type="ru.k0t0vich.core.resource.BitmapLoaderEvent")]
	
	public class BitmapLoader extends EventDispatcher implements IBitmapLoader
	{
		
		private var assetQueue:Array = [];
		private static const _HASH:Object={};
		
		public function BitmapLoader()
		{
			super();
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			trace("Error: " + e);
			var contentLoaderInfo: LoaderInfo = e.target as LoaderInfo;
			contentLoaderInfo.removeEventListener(Event.COMPLETE, loadNewAssetListener);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loadNext();
		}
		
		/**
		 * Загрузить ресурс
		 * @param	path
		 */
		public function load(path: String): void {
		
			assetQueue.push(path);	
			if (assetQueue.length == 1)
			{
				loadAsset(path);
			}
		}
		
		private function loadAsset(path: String): void {
			trace("BitmapLoader.loadAsset > path : " + path);
			var contentLoaderInfo: LoaderInfo = null;	
			//var contentLoaderInfo: LoaderInfo;	
			if (_HASH[path]) 
			{
				trace("asset always loading");
				// если уже загружен
				if (_HASH[path].content)
				{
				contentLoaderInfo = (_HASH[path] as Loader).contentLoaderInfo;
				dispatchBitmapLoaderEvent(contentLoaderInfo);
				}
				else
				{
					//throw(new Error("Asset not loaded"));
					trace("waiting");
					waiting(path);
					//loadNext();
					//loadNewAsset(path);
				}
			}
			else
			{
				loadNewAsset(path);
			}
		}
		
			
		
		/**
		 * Диспатчим событие при загрузке или существовании ресурса
		 * @param	contentLoaderInfo
		 */
		private function dispatchBitmapLoaderEvent(contentLoaderInfo:LoaderInfo=null):void
		{			
			var assetEvent: BitmapLoaderEvent = new BitmapLoaderEvent( BitmapLoaderEvent.COMPLETE );
			assetEvent.contentLoaderInfo = contentLoaderInfo;
					
				// если картинка, то создаём новую битмап 
				if (contentLoaderInfo.content is Bitmap)
				{
					//var bitmap:Bitmap = new Bitmap((contentLoaderInfo.content as Bitmap).bitmapData);
					var bitmap:Bitmap = contentLoaderInfo.content as Bitmap;
					assetEvent.bitmap = bitmap;
				}
				
			dispatchEvent( assetEvent );
			loadNext();	
		}
		
		private function loadNext():void
		{
			if (assetQueue.length > 0)
			{
				var path:String = assetQueue.shift();
				loadAsset(path);
			}
			else
			{
				dispatchEvent(new BitmapLoaderEvent( BitmapLoaderEvent.ALL_COMPLETE)); 
			}
			
		}
		
		
		private function waiting(path:String):void
		{
			var loader: Loader = _HASH[path];
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadNewAssetListener);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);	
		}
		
		
		
		/**
		 * Загрузить  новый файл
		 * @param	path - путь к ресурсу
		 **/
		private function loadNewAsset(path: String): void {
			trace("loadNewAsset: "+path);
			var loader: Loader = new Loader();
			//var loader: Loader = ResourceDictionary.instance.loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadNewAssetListener);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load( new URLRequest(path) );
			_HASH[path] = loader;
		}
		
		/**
		 * Хэндлер загрузки ресурса
		 * @param	e
		 */
		private function loadNewAssetListener(e:Event):void 
		{
			var contentLoaderInfo: LoaderInfo = e.target as LoaderInfo;
			contentLoaderInfo.removeEventListener(Event.COMPLETE, loadNewAssetListener);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatchBitmapLoaderEvent(contentLoaderInfo);
			
		}
		

		
		public static function getResource(path:String):Bitmap
		{
			return new Bitmap(((_HASH[path] as Loader).content as Bitmap).bitmapData);
		}
		
		public static function deleteResource(path:String, dispose:Boolean = false ):void
		{
			if (dispose) {
				(((_HASH[path] as Loader).content as Bitmap).bitmapData).dispose();
				delete _HASH[path];
				_HASH[path] = null;
			}
		}

	}
}
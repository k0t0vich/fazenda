package ru.k0t0vich.fazenda.resource 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import ru.k0t0vich.core.resource.ResourceLoader;
	import ru.k0t0vich.core.resource.ResourceLoaderEvent;
	/**
	 * ...
	 * @author k0t0vich
	 */
	[Event(name="complete", type="flash.events.Event")]
	public class TileManager extends EventDispatcher
	{
		private static const _HASH:Object ={};
		private var imagePath:String;
		
		private var loader:ResourceLoader = new ResourceLoader();
		
		private var tilesXML:XML;
		private var tilesBitmapData:BitmapData;
		private var zeroPoint:Point = new Point();
		
		
		public function TileManager(xml:XML):void
		{	
			tilesXML = xml;
			imagePath = xml.@imagePath;
			loader.addEventListener(ResourceLoaderEvent.COMPLETE,init)
			loader.load(imagePath);
		}
		
		private function init(e:ResourceLoaderEvent):void 
		{
			tilesBitmapData = ResourceLoader.getResource(imagePath).bitmapData;
			
			var node:XML;
			var nodes:XMLList = tilesXML..SubTexture;

			for each ( node in nodes )
			{
				var bmpdX:int = int( node.@x );
				var bmpdDX:int = int( node.@dx );
				var bmpdY:int = int( node.@y );
				var bmpdDY:int = int( node.@dy );
				var bmpdWidth:int = int( node.@width );
				var bmpdHeight:int = int( node.@height );
				var bmpdName:String = String(node.@name);
				var bmpd:BitmapData = new BitmapData(bmpdWidth, bmpdHeight);
				
				bmpd.copyPixels(tilesBitmapData, new Rectangle(bmpdX, bmpdY, bmpdWidth, bmpdHeight), zeroPoint);
				_HASH[bmpdName] = {bmpd:bmpd,dx:bmpdDX,dy:bmpdDY};
				
			}
			
			dispatchEvent(new Event(Event.COMPLETE, true));
			
		}
		
		public static function getTileByName(name:String):DisplayObject
		{
			var bmp:Bitmap = new Bitmap(_HASH[name].bmpd as BitmapData);
			bmp.x = -_HASH[name].dx;
			for (var i:String in _HASH[name]) trace("key : " + i + ", value : " + _HASH[name][i]);
			bmp.y = -_HASH[name].dy;
			return bmp;
		}
		
		public static function deleteResource(path:String):void
		{
			delete _HASH[path];
			_HASH[path] = null;
		}
		
	}

}
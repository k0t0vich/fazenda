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
	import ru.k0t0vich.core.resource.BitmapLoader;
	import ru.k0t0vich.core.resource.BitmapLoaderEvent;
	/**
	 * ...
	 * @author k0t0vich
	 */
	[Event(name="complete", type="flash.events.Event")]
	public class TileManager extends EventDispatcher
	{
		private static const _HASH:Object ={};
		private var imagePath:String;
		
		private var loader:BitmapLoader = new BitmapLoader();
		
		private var tilesXML:XML;
		private var tilesBitmapData:BitmapData;
		private var zeroPoint:Point = new Point();
		
		
		public function TileManager():void
		{	
			
		}
		
		/**
		 * Добавить атлас в хранилище
		 * @param	xml
		 */
		public function addAtlas(xml:XML):void
		{
			tilesXML = xml;
			imagePath = xml.@imagePath;
			loader.addEventListener(BitmapLoaderEvent.COMPLETE,init)
			loader.load(imagePath);
		}
		
		
		private function init(e:BitmapLoaderEvent):void 
		{
			tilesBitmapData = BitmapLoader.getResource(imagePath).bitmapData;
			
			var node:XML;
			var nodes:XMLList = tilesXML..SubTexture;

			for each ( node in nodes )
			{
				var tileX:int = int( node.@x );
				var tileDX:int = int( node.@dx );
				var tileY:int = int( node.@y );
				var tileDY:int = int( node.@dy );
				var tileWidth:int = int( node.@width );
				var tileHeight:int = int( node.@height );
				var tileName:String = String(node.@name);
				var tile:BitmapData = new BitmapData(tileWidth, tileHeight);
				
				tile.copyPixels(tilesBitmapData, new Rectangle(tileX, tileY, tileWidth, tileHeight), zeroPoint);
				_HASH[tileName] = new TileData(tileName, tile, tileDX, tileDY);
				
			}
			BitmapLoader.deleteResource(imagePath);
			dispatchEvent(new Event(Event.COMPLETE, true));
			
		}
		
		public static function getTileByName(name:String):DisplayObject
		{
			var tileData:TileData = _HASH[name] as TileData;
			var bmp:Bitmap = new Bitmap(tileData.tile as BitmapData);
			bmp.x = -tileData.dx;
			bmp.y = -tileData.dy;
			tileData.counter++;
			return bmp;
		}
		
		public static function deleteResource(name:String,dispose:Boolean = false):void
		{
			var tileData:TileData = _HASH[name] as TileData;
			tileData.counter--;
			if (tileData.counter == 0 && dispose)
			{
				tileData.dispose();
				delete _HASH[name];
				tileData = null;
			}
		}
		

	}

}
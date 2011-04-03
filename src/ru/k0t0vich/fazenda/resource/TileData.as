package ru.k0t0vich.fazenda.resource 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author k0t0vich
	 */
	public class TileData
	{
		private var _name:String;
		private var _tile:BitmapData;
		private var _dx:int;
		private var _dy:int;
		private var _counter:int = 0;
		
		public function TileData(name:String,tile:BitmapData,dx:int,dy:int) 
		{
			this._dy = dy;
			this._dx = dx;
			this._tile = tile;
			this._name = name;	
			
		}
		
		public function get name():String { return _name; }
		
		public function get tile():BitmapData { return _tile; }
		
		public function get dx():int { return _dx; }
		
		public function get dy():int { return _dy; }
		
		public function get counter():int { return _counter; }
		
		public function set counter(value:int):void 
		{
			if (value < 0) value = 0;
			_counter = value;
		}
		
		public function dispose():void
		{
			tile.dispose();
		}
		
	}

}
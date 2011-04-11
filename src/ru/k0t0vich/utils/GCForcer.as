package ru.k0t0vich.utils 
{
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
 
	/**
	 * утитилита для принудительного вызова GC за счет 10-чного unloadAndStop<br>
	 *: грузим-выгружаем, походу запускается GC
	 * @author silin
	 */
	public class GCForcer 
	{
		private static const LOADER:Loader = new Loader();
		private static const GIF:Array = [
			71, 73, 70, 56, 57, 97, 1, 0, 1, 0, -128, 0, 0, -1, -1, -1, 0, 0, 0, 33, -7,
			4, 0, 7, 0, -1, 0, 44, 0, 0, 0, 0, 1, 0, 1, 0, 0, 2, 2, 68, 1, 0, 59
		];
 
		public function GCForcer() 
		{
			trace ("GCForcer is a static class and should not be instantiated.");
		}
 
		public static function force():void
		{
 
			LOADER.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplteteHandler);
 
			var ba:ByteArray = new ByteArray();
			for (var i:int = 0; i < GIF.length; i++) 
			{
				ba.writeByte(GIF[i]);
			}
 
			LOADER.loadBytes(ba);
		}
 
		static private function loaderComplteteHandler(evnt:Event):void 
		{
			LOADER.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderComplteteHandler);
			try 
			{
				LOADER.unloadAndStop();
				//LOADER.unload();
			}catch (err:Error) { };
 
		}
 
	}
}
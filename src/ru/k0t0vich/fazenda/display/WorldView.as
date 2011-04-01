package ru.k0t0vich.fazenda.display
{
	import flash.display.Sprite;
	import ru.k0t0vich.core.events.data.DataBaseEvent;
	import ru.k0t0vich.fazenda.data.GameData;
	
	/**
	 * ...
	 * @author k0t0vich
	 */
	public class WorldView extends Sprite
	{
		
		public function WorldView(gameData:GameData) 
		{
			super();
			gameData.addEventListener(DataBaseEvent.ADDED, init);
			
		}
		
		private function init(e:DataBaseEvent):void 
		{
			
		}
		
	}

}
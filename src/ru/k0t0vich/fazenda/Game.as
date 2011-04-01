package ru.k0t0vich.fazenda 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import ru.k0t0vich.core.controllers.BaseController;
	import ru.k0t0vich.core.data.DataBase;
	import ru.k0t0vich.fazenda.controllers.GameController;
	
	/**
	 * ...
	 * @author k0t0vich
	 */
	public class Game extends Sprite
	{
		private var gameController:GameController;
		
		public function Game() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			gameController = new GameController(this);
		}
		
	}
	
}
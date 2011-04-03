package ru.k0t0vich.fazenda 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import by.blooddy.core.controllers.BaseController;
	import by.blooddy.core.data.DataBase;
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
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			gameController = new GameController(this);
		}
		
	}
	
}
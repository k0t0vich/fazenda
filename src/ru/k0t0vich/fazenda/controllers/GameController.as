package ru.k0t0vich.fazenda.controllers 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import ru.k0t0vich.core.resource.BitmapLoader;
	import by.blooddy.core.controllers.BaseController;
	import by.blooddy.core.data.DataBase;
	import by.blooddy.core.net.ProxySharedObject;
	import ru.k0t0vich.core.resource.BitmapLoaderEvent;
	import ru.k0t0vich.fazenda.data.GameData;
	import ru.k0t0vich.fazenda.display.WorldView;
	import ru.k0t0vich.fazenda.resource.TileManager;
	/**
	 * ...
	 * @author k0t0vich
	 */
	public class GameController extends BaseController
	{
		private var gameData:GameData;
		private var world:WorldView;
		private var urloader:URLLoader;
		private var tileManager:TileManager;
		
		public function GameController(container:DisplayObjectContainer) {
			super( container, new DataBase(),ProxySharedObject.getLocal( 'ru.k0t0vich.fazenda'));
							
			//модель игры
			gameData =  new GameData();
			
			
			// вьюшка мира игры
			world = new WorldView(gameData);
			container.addChild(world);
			
			//TODO инициализация серверного контроллера. без сервера - будет заглушка.	
			
			
		
			
			urloader = new URLLoader();
			urloader.addEventListener(Event.COMPLETE, onXMLLoaded);
			urloader.load(new URLRequest("data/tiles.xml"));
		}
		
		private function onXMLLoaded(e:Event):void 
		{
			tileManager = new TileManager(new XML(urloader.data));
			tileManager.addEventListener(Event.COMPLETE, start);
		}
		
		private function start(e:Event):void 
		{
			//container.addChild(new Bitmap(TileManager.getTileByName("clover_4")));
			dataBase.addChild(gameData);
			
		}
		
		
	}

}
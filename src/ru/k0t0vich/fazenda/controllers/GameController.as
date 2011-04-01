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
	import flash.net.URLRequest;
	import ru.k0t0vich.core.resource.ResourceLoader;
	import ru.k0t0vich.core.controllers.BaseController;
	import ru.k0t0vich.core.data.DataBase;
	import ru.k0t0vich.core.net.ProxySharedObject;
	import ru.k0t0vich.core.resource.ResourceLoaderEvent;
	import ru.k0t0vich.fazenda.data.GameData;
	import ru.k0t0vich.fazenda.display.WorldView;
	/**
	 * ...
	 * @author k0t0vich
	 */
	public class GameController extends BaseController
	{
		private var gameData:GameData;
		private var world:WorldView;
		private var loader:ResourceLoader = new ResourceLoader();
		
		public function GameController(container:DisplayObjectContainer) {
			super( container, new DataBase(),ProxySharedObject.getLocal( 'ru.k0t0vich.fazenda'));
							
			//модель игры
			gameData =  new GameData();
			
			
			// вьюшка мира игры
			world = new WorldView(gameData);
			container.addChild(world);
			
			//TODO инициализация серверного контроллера. без сервера - будет заглушка.	
			dataBase.addChild(gameData);
			test();
		}
		
		private function test():void
		{
			//loader.addEventListener(ResourceLoaderEvent.COMPLETE,test_handler)
			loader.addEventListener(ResourceLoaderEvent.ALL_COMPLETE,test_handler)
			loader.load("data/potato/Image 10.png");
		}
		
		private function test_handler(e:ResourceLoaderEvent):void 
		{
			trace("GameController.test_handler > e : " + e);
			var b1:Bitmap = ResourceLoader.getResource("data/potato/Image 10.png");
			var b2:Bitmap = ResourceLoader.getResource("data/potato/Image 10.png");
			world.addChild(b1);
			var s2:Sprite = new Sprite;
			s2.addChild(b2);
			s2.x = 200;
			s2.addEventListener(MouseEvent.ROLL_OVER, filter_handler);
			s2.addEventListener(MouseEvent.ROLL_OUT, filter_out_handler);
			world.addChild(s2);
			
		}
		
		private function filter_out_handler(e:MouseEvent):void 
		{
			(e.currentTarget as Sprite).filters = [];
		}
		
		private function filter_handler(e:MouseEvent):void 
		{
			(e.currentTarget as Sprite).filters = [new GlowFilter()];
		}
		
	}

}
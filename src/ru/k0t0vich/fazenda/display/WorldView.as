package ru.k0t0vich.fazenda.display
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.enum.RenderStyleType;
	import as3isolib.geom.Pt;
	import as3isolib.graphics.SolidColorFill;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import ru.k0t0vich.core.events.data.DataBaseEvent;
	import ru.k0t0vich.fazenda.data.GameData;
	import ru.k0t0vich.fazenda.events.data.GameDataEvent;
	import ru.k0t0vich.fazenda.resource.TileManager;
	
	/**
	 * ...
	 * @author k0t0vich
	 */
	public class WorldView extends Sprite
	{
		//TODO: передавать ссылку на BG
		[Embed(source='../../../../../bin-debug/data/BG.jpg')]
		static private const BG_CLASS:Class;
		
		private var view:IsoView;
		private var panPt:Point;
		private var box:IsoBox= new IsoBox();
		
		public static const ROW:int = 13;
		public static const COL:int = 13;
		public static const CELL_SIZE:int = 50;
		private var scene:IsoScene;
		private var _gameData:GameData;
		private var bedsArray:Array = [];
		
		
		public function WorldView(gameData:GameData) 
		{
			super();
			this._gameData = gameData;
			gameData.addEventListener(DataBaseEvent.ADDED, init);	
		}
		
		private function checkSelectBox(e:GameDataEvent=null):void 
		{
			if (_gameData.select) showSelectBox();
			else hideSelectBox();
		}
		
		private function init(e:DataBaseEvent):void 
		{
		
			scene = new IsoScene();
			
			var grid:IsoGrid = new IsoGrid();
			grid.cellSize = CELL_SIZE;
			grid.showOrigin = false;
			grid.setGridSize(ROW, COL);
			
			scene.addChild(grid);	
			
			view = new IsoView();
			view.setSize(stage.stageWidth, stage.stageHeight);
			view.addScene(scene);
			
			var background:Bitmap = new BG_CLASS();
			
			//TODO: убрать магические цифры
			background.x = -742;
			background.y = -100;
			view.backgroundContainer.addChild(background);
			
			addChild(view);
			
			box.fills = [new SolidColorFill(0x00FF00, .5)];
			box.setSize(CELL_SIZE, CELL_SIZE, 0);
			_gameData.addEventListener(GameDataEvent.SELECT_CHANGED, checkSelectBox);
			checkSelectBox();
			
			stage.addEventListener(Event.RESIZE, resize);
			stage.addEventListener( MouseEvent.MOUSE_DOWN, onStartPan, false, 0, true );
			
			addBeds();
			
			view.render(true);
        }
		

		private var nameArray:Array = ["clover_", "potato_", "sunflower_"];		
		private function addBeds():void
		{
			for (var i:int = 0; i < ROW; i++) 
			for (var j:int = 0; j < COL; j++) 
			{
				var isoSprite:IsoSprite = new IsoSprite();
				var iName:String = nameArray[int(Math.random() * 3)] + String(int(Math.random() * 5) + 1);
				//var iName:String = "sunflower_5";
				
				var bmpd:DisplayObject = TileManager.getTileByName(iName);
				//bmpd.x -= CELL_SIZE / 2;
				isoSprite.sprites = [bmpd];
				isoSprite.x = i  * CELL_SIZE;
				isoSprite.y = j *  CELL_SIZE;
				isoSprite.setSize(CELL_SIZE, CELL_SIZE, CELL_SIZE);
				scene.addChild(isoSprite);
				//return;
				
			}
		}
		
		
		public function showSelectBox():void
		{
			//test - потом этот бокс будет использоваться для выбора
			//box.styleType = RenderStyleType.SHADED;
			scene.addChild(box);
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMoveSelectBox, false, 0, true );
			onMoveSelectBox();
		}
		
		public function hideSelectBox():void
		{
			//test - потом этот бокс будет использоваться для выбора
			//box.styleType = RenderStyleType.SHADED;
			scene.removeChild(box);
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMoveSelectBox);
		}
		
		private function resize(e:Event):void 
		{
			view.setSize(stage.stageWidth, stage.stageHeight);
		}
 
        private function onStartPan( e:MouseEvent ):void
        {
            panPt = new Point( stage.mouseX, stage.mouseY );
 
            removeEventListener( MouseEvent.MOUSE_DOWN, onStartPan );
 
            stage.addEventListener( MouseEvent.MOUSE_MOVE, onPan, false, 0, true );
            stage.addEventListener( MouseEvent.MOUSE_UP, onStopPan, false, 0, true );
        }
 
        private function onPan( e:MouseEvent ):void
        {
            view.panBy( panPt.x - stage.mouseX, panPt.y - stage.mouseY );
 
            panPt.x = stage.mouseX;
            panPt.y = stage.mouseY;
        }
 
        private function onStopPan( e:MouseEvent ):void
        {
            stage.removeEventListener( MouseEvent.MOUSE_MOVE, onPan );
            stage.removeEventListener( MouseEvent.MOUSE_UP, onStopPan );
 
            stage.addEventListener( MouseEvent.MOUSE_DOWN, onStartPan, false, 0, true );
        }

		private function onMoveSelectBox( e:MouseEvent=null ):void
        {
            var pt:Pt = view.localToIso( new Point( stage.mouseX, stage.mouseY ) );
            //box.moveTo( pt.x - _dragPt.x, pt.y - _dragPt.y, _dragObject.z );
			var px:int = int(pt.x / CELL_SIZE) *CELL_SIZE;
			var py:int = int(pt.y / CELL_SIZE) * CELL_SIZE;
			if (px >= 0 && px < CELL_SIZE*ROW && py >= 0 && py < CELL_SIZE*COL)
			{
				box.moveTo( px ,py , 0);
				view.render(true);
			}
        }	
	}

}
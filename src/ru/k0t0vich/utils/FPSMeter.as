package ru.k0t0vich.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;	
	
	/**
	 *      Very simple fps counter for everyday use.
	 * 
	 */
		 
	public class FPSMeter extends Sprite {			
		private var tf				:TextField;
		private var bmp				:BitmapData;
		private var tbmp			:BitmapData;

		private var otime			:int = 0;
		
		private var barWidth		:uint;
		private var barHeight		:uint = 16;
		private var scrollWidth		:int = 2;
		private var updateInterval	:uint;
		private var count			:uint = 0;
		private var ms				:uint = 0;
		
		/**
		 * 
		 *      @param  updateInterval  The number of frames to wait before updating
		 *      @param  barWidth        The width of the graph.
		 */
		public function FPSMeter(updateInterval:uint=10, barWidth:uint=30) {
				this.updateInterval = updateInterval;
				this.barWidth = barWidth;
				createAssets();
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function createAssets():void {
				bmp = new BitmapData(barWidth, barHeight, false, 0x000000);
				addChild(new Bitmap(bmp));      
				tbmp = new BitmapData(scrollWidth,barHeight, false);
				tf = new TextField();
				tf.x = barWidth;
				tf.y = -3;
				addChild(tf);
		}
		
		
		private function onEnterFrame(e:Event):void {
			if (count < updateInterval) {
					count++;
			} else {
					var d:uint = getTimer()-ms;
					var msf:Number = d/updateInterval;
					var fps:Number = 1000/msf;

					// Update the scroller
					bmp.scroll(-scrollWidth,0);
					var err:int = barHeight-Math.round((fps/stage.frameRate)*barHeight);
					var x:int; 
					var y:int;
					for (x=barWidth-scrollWidth; x<barWidth; x++) {
							for (y=0; y<err-1; y++) {
									bmp.setPixel(x,y,0xFF5500);     
							}
							for (y=err; y<barHeight; y++) {
									bmp.setPixel(x,y,0x00FF00);
							}
					}
					
					// Update text
					tf.text="ms "+msf.toFixed(1)+"  FPS: "+fps.toFixed(1)+"  /  "+stage.frameRate;
					
					// Reset
					count = 0;
					ms = getTimer();
			}                        
		}
	}
}
package ru.k0t0vich.utils {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * Creates a pseudo Output panel in a publish
	 * swf for displaying trace statements.
	 * For the output panel to capture trace 
	 * statements, you must use Output.trace()
	 * and add an instance to the stage:
	 * stage.addChild(new Output());
	 *
	 * Note: You may want to place Output in an
	 * unnamed package to make it easier to
	 * trace within your classes without having
	 * to import com.senocular.utils.Output.
	 */
	public class Output extends Sprite {
		private var output_txt:TextField;
		private var titleBar:Sprite;
		private static var instance:Output;
		private static var autoExpand:Boolean = false;
		private static var maxLength:int = 10000;
		
		public function Output(outputHeight:uint = 350){
			if (instance && instance.parent){
				instance.parent.removeChild(this);
			}
			
			instance = this;
			addChild(newOutputField(outputHeight));
			addChild(newTitleBar());
			
			addEventListener(Event.ADDED, added);
			addEventListener(Event.REMOVED, removed);
			toggleCollapse();
		}
		
		// public methods
		public static function trace(...arg:Array):void {
			if (!instance) return;
			for (var i:int = 0; i < arg.length; i++) 
			{	
				var str:String = arg[i];
				instance.output_txt.appendText(str + "  ");
				
				if (instance.output_txt.length > maxLength) {
					instance.output_txt.text = instance.output_txt.text.slice(-maxLength);
				}
			}
			instance.output_txt.appendText("\n");
			instance.output_txt.scrollV = instance.output_txt.maxScrollV;
			if (autoExpand && !instance.output_txt.visible) instance.toggleCollapse();
		}
		
		public static function clear():void {
			if (!instance) return;
			instance.output_txt.text = "";
		}
		
		private function newOutputField(outputHeight:uint):TextField {
			output_txt = new TextField();
			output_txt.type = TextFieldType.INPUT;
			output_txt.border = true;
			output_txt.borderColor = 0;
			output_txt.background= true;
			output_txt.backgroundColor = 0xFFFFFF;
			output_txt.height = outputHeight;
			var format:TextFormat = output_txt.getTextFormat();
			format.font = "_typewriter";
			output_txt.setTextFormat(format);
			output_txt.defaultTextFormat = format;
			return output_txt;
		}
		private function newTitleBar():Sprite {
			var barGraphics:Shape = new Shape();
			barGraphics.name = "bar";
			var colors:Array = new Array(0xE0E0F0, 0xB0C0D0, 0xE0E0F0);
			var alphas:Array = new Array(1, 1, 1);
			var ratios:Array = new Array(0, 50, 255);
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(18, 18, Math.PI/2, 0, 0);
			barGraphics.graphics.lineStyle(0);
			barGraphics.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, gradientMatrix);
			barGraphics.graphics.drawRect(0, 0, 18, 18);
			
			var barLabel:TextField = new TextField();
			barLabel.autoSize = TextFieldAutoSize.LEFT;
			barLabel.selectable = false;
			barLabel.text = "Output";
			var format:TextFormat = barLabel.getTextFormat();
			format.font = "_sans";
			barLabel.setTextFormat(format);
			
			titleBar = new Sprite();
			titleBar.addChild(barGraphics);
			titleBar.addChild(barLabel);
			return titleBar;
		}
		
		// Event handlers
		private function added(evt:Event):void {
			stage.addEventListener(Event.RESIZE, fitToStage);
			titleBar.addEventListener(MouseEvent.CLICK, toggleCollapse);
			fitToStage();
			toggleCollapse();
		}
		private function removed(evt:Event):void {
			stage.removeEventListener(Event.RESIZE, fitToStage);
			titleBar.removeEventListener(MouseEvent.CLICK, toggleCollapse);
		}
		private function toggleCollapse(evt:Event = null):void {
			if (!instance) return;
			output_txt.visible = !output_txt.visible;
			//fitToStage(evt);
		}
		private function fitToStage(evt:Event = null):void {
			if (!stage) return;
			output_txt.width = stage.stageWidth;
			output_txt.y = stage.stageHeight - output_txt.height;
			titleBar.y = (output_txt.visible) ? output_txt.y - titleBar.height : stage.stageHeight - titleBar.height;
			titleBar.getChildByName("bar").width = stage.stageWidth;
		}
	}
}
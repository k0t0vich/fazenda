package ru.k0t0vich.fazenda.events.data 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author k0t0vich
	 */
	public class GameDataEvent extends Event 
	{
		public static const SELECT_CHANGED:String = "selectChanged";
		public function GameDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new GameDataEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GameDataEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}
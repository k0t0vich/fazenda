package ru.k0t0vich.fazenda.data 
{
	import by.blooddy.core.data.DataContainer;
	import ru.k0t0vich.fazenda.events.data.GameDataEvent;
	
	/**
	 * ...
	 * @author k0t0vich
	 */
	[Event(name="selectChanged", type="ru.k0t0vich.fazenda.events.data.GameDataEvent")]
	public class GameData extends DataContainer
	{
		private var _select:Boolean=false;
		
		
		public function GameData() 
		{
			super();
		}
		
		public function get select():Boolean { return _select; }
		
		public function set select(value:Boolean):void 
		{
			if (_select === value) return;
			dispatchEvent(new GameDataEvent(GameDataEvent.SELECT_CHANGED, true));
			_select = value;
		}
		
	}

}
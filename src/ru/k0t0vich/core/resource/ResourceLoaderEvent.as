﻿package ru.k0t0vich.core.resource
{
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.events.Event;

	public class ResourceLoaderEvent extends Event
	{
		public static const COMPLETE: String = "COMPLETE";
		public static const ALL_COMPLETE: String = "ALL_COMPLETE";
		
		public var contentLoaderInfo: LoaderInfo = null;
		public var bitmap:Bitmap = null;
			
		public function ResourceLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	
		override public function clone(): Event 
		{
			var event: ResourceLoaderEvent = new ResourceLoaderEvent( type, bubbles, cancelable );
			event.contentLoaderInfo = contentLoaderInfo;
			event.bitmap = bitmap;
			return event;
		}
		
	}
}
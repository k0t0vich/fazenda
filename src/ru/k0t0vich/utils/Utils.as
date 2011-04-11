package ru.k0t0vich.utils 
{
	
	/**
	 * ...
	 * @author k0t0vich
	 */
	public class Utils 
	{
		
	private static var CLASS_NAME:String = "className";
	
	/**
	 * Returns a string representation of the object specified in "o" argument.
	 * @param	o	Object. An object to be described.
	 * @return	String. A Flash-debugger like string eg.:
	 * [%object name% %object property%="%property value%"]
	 */
	public static function formatToString(o:Object,...arg:Array):String 
	{
		var i:Number = 1;
		var l:Number = arg.length;
		var r_str:String = "[" + o[CLASS_NAME] + " ";
		for (i = 1; i < l; i++)
		{
			r_str += arg[i] + "=" + o[arg[i]] + " ";
		}
		return r_str + "]";
	}
		
		
	}
	
}
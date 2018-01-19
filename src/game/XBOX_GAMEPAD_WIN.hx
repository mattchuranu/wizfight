package game;

class XBOX_GAMEPAD_WIN
{
	public static var A_BUTTON:Int = 0;
	public static var B_BUTTON:Int = 1;
	public static var X_BUTTON:Int = 2;
	public static var Y_BUTTON:Int = 3;
	public static var LB_BUTTON:Int = 4;
	public static var RB_BUTTON:Int = 5;
	public static var BACK_BUTTON:Int = 6;
	public static var START_BUTTON:Int = 7;
	public static var LEFT_ANALOGUE_BUTTON:Int = 8;
	public static var RIGHT_ANALOGUE_BUTTON:Int = 9;
	public static var LEFT_ANALOGUE_X:Int = 0;
	public static var LEFT_ANALOGUE_Y:Int = 1;
	public static var RIGHT_ANALOGUE_X:Int = 4;
	public static var RIGHT_ANALOGUE_Y:Int = 3;

	/**
	* Keep in mind that if TRIGGER axis returns value > 0 then LT is being pressed, and if it's < 0 then RT is being pressed
	*/
	public static var TRIGGER:Int = 2;
}
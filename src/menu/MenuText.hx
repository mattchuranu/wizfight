package menu;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Draw;

class MenuText extends Entity 
{
	public var menuText:Text;
	private var oldScale:Int;
	private var sizeSet:Bool;
	private var c:Bool;

	public function new(_text:String, _x:Float, _y:Float, ?center:Bool, ?_size:Int, ?_font:String, ?_scale:Float)
	{
		super(_x, _y);
		//trace("super");

		menuText = new Text(_text);
		menuText.color = 0xFFFFFF;
		menuText.resizable = true;
		//oldScale = 1;
		//sizeSet = false;
		//c = center;

		if (_scale == null) {
			_scale = 1;
		}

		if (_size != null) {
			menuText.size = Std.int(_size * ((HXP.screen.scaleX / 4)) * _scale); // * (HXP.screen.scaleY / 4)));
		} else {
			menuText.size = Std.int(10 * ((HXP.screen.scaleX / 4)) * _scale); // * (HXP.screen.scaleY / 4)));
		}

		if (_font != null) {
			menuText.font = _font;
		}

		if (center == true) {
			menuText.centerOrigin();
		}

		graphic = menuText;
		x = _x;
		y = _y;
		layer = -10;
	}

	override public function update()
	{
		/*if (HXP.fullscreen) {
			if (!sizeSet) {
				menuText.size *= Std.int(HXP.screen.scaleX / 2);
				oldScale = Std.int(HXP.screen.scaleX / 2);
				//menuText.scaleY = HXP.screen.scaleY;
				this.graphic = menuText;
				
				if (c) {
					menuText.centerOrigin();
				}
				sizeSet = true;
			}
		} else {
			menuText.size = Std.int(menuText.size/oldScale);
			oldScale = 1;
			this.graphic = menuText;
			sizeSet = false;

			if (c) {
				menuText.centerOrigin();
			}
		}*/
		super.update();
	}

	public function updateAlpha(_alpha:Float) 
	{
		menuText.alpha = _alpha;
		this.graphic = menuText;
	}
}
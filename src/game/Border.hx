package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

class Border extends Entity
{
	private var sprite:Spritemap;

	public function new(xOff:Float, yOff:Float)
	{
		super(-780 + xOff, -420 + yOff);

		sprite = new Spritemap("gfx/border.png", 1920, 1080);

		graphic = sprite;
		layer = 0;
	}
}
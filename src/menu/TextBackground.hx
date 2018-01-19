package menu;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

class TextBackground extends Entity
{
	public var sprite:Spritemap;
	private var spawn:Int = 0;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/sidebar/textbg.png", 190, 40);
		graphic = sprite;
		layer = 0;
	}
}
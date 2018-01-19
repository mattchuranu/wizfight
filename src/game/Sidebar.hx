package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

class Sidebar extends Entity
{
	public var sprite:Spritemap;
	private var spawn:Int = 0;

	public function new(x:Float, y:Float, _map:String)
	{
		super(x, y);

		sprite = new Spritemap("gfx/sidebar/" + _map + ".png", 20, 240);
		graphic = sprite;
		layer = 0;
	}
}
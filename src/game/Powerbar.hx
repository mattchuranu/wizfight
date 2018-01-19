package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

class Powerbar extends Entity
{
	public var sprite:Spritemap;
	private var i:Int;

	public function new(x:Float, y:Float, _i:Int)
	{
		super(x, y);

		sprite = new Spritemap("gfx/sidebar/powerbar.png", 11, 4);
		sprite.centerOrigin();
		graphic = sprite;
		i = _i;
		layer = 0;
	}
	override public function update()
	{
		sprite.setFrame(Scores.POWER[i], 0);
		sprite.centerOrigin();
		super.update();
	}
}
package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.masks.Circle;

class UnicornRainbow extends Entity
{
	public var sprite:Spritemap;

	public function new(x:Float, y:Float, _facing:Int)
	{
		super(x, y);

		sprite = new Spritemap("gfx/powers/unicornrainbow.png", 32, 6);
		sprite.flipped = (_facing == 0) ? false : true;

		graphic = sprite;
		layer = 3;
	}
	override public function update()
	{
		super.update();
	}
}
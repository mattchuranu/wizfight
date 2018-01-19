package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class GoatTongue extends Entity
{
	public var sprite:Spritemap;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/powers/goattongue.png", 2, 2);
		graphic = sprite;
		layer = 1;
	}
	override public function update()
	{
		//super.update();
	}
}
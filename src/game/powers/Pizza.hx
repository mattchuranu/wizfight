package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;
import game.Types;

class Pizza extends Entity
{
	private var sprite:Spritemap;
	private var yGoal:Float;

	override public function new(x:Float, y:Float) 
	{
		super(x - 32, -16);
		sprite = new Spritemap("gfx/powers/pizza.png", 64, 16);
		graphic = sprite;
		type = "pizza_pow";
		setHitbox(64, 16);

		yGoal = y;
	}

	override public function update()
	{
		if (y >= yGoal) {
			scene.remove(this);
		} else {
			y += 4;
		}
	}

	override public function removed()
	{
		for (i in 0...Std.int(sprite.width / 16)) {
			Emitters.SHAKEEMITTER.rmvd(x + (i * 16), y);
		}
	}
}
package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class Orb extends Entity
{
	public var sprite:Spritemap;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/orb.png", 3, 7);
		sprite.add("anim", [0, 1, 2, 3, 4, 5], 3, true);
		graphic = sprite;
		type = "orb";
		layer = 4;
	}

	/*override public function added()
	{
		if (collide("orb", x, y) != null || collide("trap", x, y) != null) {
			scene.remove(this);
		}
	}*/

	override public function update()
	{
		sprite.play("anim");
		super.update();
	}

	override public function removed() {
		Emitters.DUSTEMITTER.explode(x + 1, y + 3);
	}
}
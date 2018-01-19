package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class Broom extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;
	private var dir:Int;

	public function new(x:Float, y:Float, _dir:Int)
	{
		super(x, y);

		timer = 300;
		dir = _dir;

		sprite = new Spritemap("gfx/powers/broom.png", 7, 10);
		sprite.add("sweep", [0, 1, 2, 1], 3, true);
		graphic = sprite;
		setHitbox(7, 10);
		type = "generic_pow";
		layer = 0;
	}
	override public function update()
	{
		sprite.play("sweep");

		var movMod = (dir == 0) ? -1 : 1;

		x += 1 * movMod;

		if (sprite.frame == 1) {
			Emitters.DUSTEMITTER.up(x - 3, y - 6);
		}

		if (timer <= 0) {
			scene.remove(this);
		} else {
			timer -= 1;
		}

		if (collide("solid", Std.int(x / 16) * 16, (Std.int(y / 16) + 1) * 16) == null || collide("solid", x + (1 * movMod), y) != null) {
			dir = 1 - dir;
		}
		
		super.update();
	}

	override public function removed() {
		Emitters.SHAKEEMITTER.rmvd(x, y);
	}
}
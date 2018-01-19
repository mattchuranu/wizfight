package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import game.part.Emitters;
import flash.geom.Point;

class Spike extends Entity
{
	private var sprite:Spritemap;
	private var dir:Float;
	private var activated:Bool;
	private var timer:Int;

	public function new(x:Float, y:Float, _dir:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/spike.png", 16, 16);
		sprite.setFrame(0, 0);

		dir = _dir;
		activated = false;

		timer = 120;
		setHitbox(16, 16);
		graphic = sprite;
		layer = 4;

		//type = "trap";
	}

	override public function update()
	{
		if (activated) {
			for (i in 0...Types.types.length) {
				if (collide(Types.types[i], x, y) != null) {
					var col = cast(collide(Types.types[i], x, y), Player);
					if (!col.dead) {
						col.dead = true;
						if (Scores.MODE < 2) {
							if (Scores.SCORES[i] > 0) {
								Scores.SCORES[i] -= 1;
								trace("Scores.SCORES[" + i + "], aka " + Types.types[i] + " = " + Scores.SCORES[i]);
							}
						}
					}
				}
			}

			if (timer <= 0) {
				activated = false;
			} else {
				timer -= 1;
			}
		} else {
			timer = 120;
		}

		if (activated) {
			sprite.setFrame(1, Std.int(dir));
		} else {
			sprite.setFrame(0, Std.int(dir));
		}
		super.update();
	}
}
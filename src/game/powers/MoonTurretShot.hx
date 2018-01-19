package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;

class MoonTurretShot extends Entity
{
	public var sprite:Spritemap;

	public function new(x:Float, y:Float, _f:Int, _t:String)
	{
		super(x, y);

		sprite = new Spritemap("gfx/powers/moonturretshot2.png", 3, 2);

		if (_f == 0) {
			sprite.flipped = true;
		}

		graphic = sprite;
		layer = 1;
		type = _t + "_pow"; //"moon_pow";

		setHitbox(3, 2);
	}

	override public function update()
	{
		if (sprite.flipped) {
			x -= 4;
		} else {
			x += 4;
		}

		if (collide("solid", x, y) != null) {
			scene.remove(this);
		}

		goneTooFarThisTime();
		super.update();
	}

	private function goneTooFarThisTime() {
		if (x <= 0 || x >= 320) {
			scene.remove(this);
		}
	}
}
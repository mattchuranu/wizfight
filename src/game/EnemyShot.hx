package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;

class EnemyShot extends Entity
{
	public var sprite:Spritemap;
	public var dir:Float;

	public function new(x:Float, y:Float, _dir:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/enemy/enemyshot.png", 5, 5);

		dir = _dir;

		sprite.centerOrigin();
		graphic = sprite;
		layer = 2;
		type = "enemyshot";

		setHitbox(5, 5, 2, 2);
	}

	override public function update()
	{

		x = x - 4*Math.cos(dir)*1;
		y = y + 4*Math.sin(dir)*1;

		if (collide("solid", x, y) != null) {
			scene.remove(this);
		}

		goneTooFarThisTime();
		super.update();
	}

	private function goneTooFarThisTime() {
		if (x <= 0 || x >= 320 || y <= 0 || y > 240) {
			scene.remove(this);
		}
	}
}
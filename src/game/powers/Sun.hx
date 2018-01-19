package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;
import flash.geom.Point;

class Sun extends Entity
{
	public var sprite:Spritemap;
	private var dir:Int;
	private var dirmod:Int;
	private var center:Point;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		dir = Std.random(360);
		dirmod = 2;
		center = new Point(x, y);

		sprite = new Spritemap("gfx/powers/sun.png", 24, 24);
		graphic = sprite;
		setHitbox(24, 24);
		type = "sun_pow";
		layer = 3;
	}

	override public function update()
	{
		x = center.x + 5*(dir * 3.14 / 180) * Math.cos(dir * 3.14 / 180);
		y = center.y + 5*(dir * 3.14 / 180) * Math.sin(dir * 3.14 / 180);

		dir += 5;

		if (x < -100 || x > 420) {
			scene.remove(this);
		}
		super.update();
	}
}
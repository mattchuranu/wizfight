package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class Blackhole extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		timer = 180;

		sprite = new Spritemap("gfx/powers/blackhole.png", 32, 32);
		setHitbox(32, 32, 16, 16);
		sprite.centerOrigin();
		graphic = sprite;
		type = "dark_pow";
		layer = 2;
	}
	override public function update()
	{
		if (timer <= 0) {
			scene.remove(this);
		} else {
			timer -= 1;
		}

		sprite.angle += 1;
		//super.update();
	}

	override public function removed() {
		Emitters.SHAKEEMITTER.rmvd(x, y);
	}
}
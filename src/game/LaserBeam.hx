package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import game.part.Emitters;

class LaserBeam extends Entity
{
	private var sprite:Spritemap;
	private var emitTimer:Int;
	private var timer:Int;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/emit/laseremit.png", 1, 1);
		sprite.alpha = 0;

		emitTimer = 5 + Std.random(5);
		timer = 120;

		//sprite.centerOrigin();
		graphic = sprite;
		layer = 9;
		type = "trap";

		setHitbox(1, 1);
	}

	override public function update()
	{
		if (emitTimer <= 0) {
			Emitters.LASEREMITTER.laser(x, y);
			emitTimer = 5 + Std.random(5);
		} else { emitTimer -= 1; }

		if (timer <= 0) {
			scene.remove(this);
		} else {
			timer -= 1;
		}
		super.update();
	}
}
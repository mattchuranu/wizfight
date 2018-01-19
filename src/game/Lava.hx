package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import game.part.Emitters;
//import com.haxepunk.bloom.BloomWrapper;

class Lava extends Entity
{
	private var sprite:Spritemap;
	private var emitTimer:Int;
	private var animSet:Bool;
	private var delay:Int;

	public function new(x:Float, y:Float, ?_delay:Int)
	{
		super(x, y);

		sprite = new Spritemap("gfx/lava.png", 4, 16);
		sprite.add("anim", [0, 1, 2, 1], 0.5, true);
		//var sprite_bloom = new BloomWrapper(sprite);

		emitTimer = Std.random(60);

		//sprite.centerOrigin();
		graphic = sprite;
		layer = 12;
		type = "lava";

		delay = 0;
		if (_delay != null) {
			delay = _delay;
		}

		animSet = false;

		setHitbox(4, 16);
		//sprite.play("anim");
	}

	override public function update()
	{
		if (delay <= 0) {
			if (!animSet) {
				sprite.play("anim");
				animSet = true;
			}
		} else {
			delay -= 1;
		}

		if (emitTimer <= 0) {
			Emitters.LAVAEMITTER.lava(x + Std.random(2), y + 8);
			emitTimer = 60 + Std.random(60);
		} else { emitTimer -= 1; }
		super.update();
	}
}
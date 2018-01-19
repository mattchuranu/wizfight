package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.PoisonEmitter;

class PoisonSpores extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;
	private var emitter:PoisonEmitter;

	public function new(x:Float, y:Float, _t:String)
	{
		super(x, y);

		timer = 300;

		emitter = new PoisonEmitter();

		setHitbox(16, 28);
		type= _t + "_pow";
		layer = 2;
	}

	override public function added() {
		scene.add(emitter);
	}

	override public function update()
	{
		if (timer <= 0) {
			scene.remove(emitter);
			scene.remove(this);
		} else {
			emitter.trail(x + Std.random(16), y + Std.random(28));
			timer -= 1;
		}
		
		super.update();
	}
}
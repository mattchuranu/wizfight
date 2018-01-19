package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class FirePillar extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;
	private var f:String;

	public function new(x:Float, y:Float, _f:Int)
	{
		super(x, y);

		timer = 300;
		f = Std.string(_f);

		sprite = new Spritemap("gfx/powers/firepillar.png", 16, 16);
		sprite.add("0", [0, 1, 2, 3], 8, true);
		sprite.add("1", [4, 5, 6, 7], 8, true);
		sprite.add("2", [7, 6, 5, 4], 8, true);
		//sprite.setFrame(_f, 0);
		setHitbox(16, 16);
		type="fire_pow";
		graphic = sprite;
		layer = 3;
	}

	override public function update()
	{
		sprite.play(f);

		if (timer <= 0) {
			scene.remove(this);
		} else {
			timer -= 1;
		}
		
		super.update();
	}

	override public function removed() {
		Emitters.SHAKEEMITTER.rmvd(x, y);
		Emitters.SHAKEEMITTER.rmvd(x, y + 16);
	}
}
package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class PeppermintStick extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		timer = 60;

		sprite = new Spritemap("gfx/powers/peppermint.png", 16, 32);
		setHitbox(16, 32);
		type="peppermint_pow";
		graphic = sprite;
		layer = 3;
	}

	override public function update()
	{
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
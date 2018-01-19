package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class Barnacled extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		timer = 600;

		sprite = new Spritemap("gfx/powers/barnacled.png", 16, 5);
		graphic = sprite;
		setHitbox(16, 5);
		type = "barnacled";
		layer = 3;
	}

	override public function update()
	{
		/*if (timer <= 0) {
			scene.remove(this);
		} else {
			timer -= 1;
		}*/
		super.update();
	}

	override public function removed() {
		Emitters.SHAKEEMITTER.rmvd(x, y);
	}
}
package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class CherryBlast extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;

	public function new(x:Float, y:Float, _t:String)
	{
		super(x, y);

		timer = 15;

		graphic = sprite;
		setHitbox(10, 10, 5, 5);
		type = _t + "_pow";
		layer = 2;
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
	}
}
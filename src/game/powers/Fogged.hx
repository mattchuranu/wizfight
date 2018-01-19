package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;
import game.Player;

class Fogged extends Entity
{
	public var sprite:Spritemap;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/powers/fogged.png", 16, 16);
		graphic = sprite;
		type = "fogged";
		layer = 0;
	}
	override public function update()
	{
		var near = null;

		if (scene.typeCount("fog") > 0) {
			near = scene.nearestToEntity("fog", this, true);
		} else if (scene.typeCount("mimic") > 0) {
			near = scene.nearestToEntity("mimic", this, true);
		}

		if (distance(near.x, x, near.y, y) < 32 && cast(near, Player).altType == "fog") {
			sprite.alpha = 0;
		} else {
			sprite.alpha = 1;
		}

		super.update();
	}

	private function distance(_x1:Float, _x2:Float, _y1:Float, _y2:Float) 
	{
		return Math.sqrt(Math.pow(_x2 - _x1, 2) + Math.pow(_y2 - _y1, 2));
	}
	/*override public function removed() {
		Emitters.SHAKEEMITTER.rmvd(x, y);
	}*/
}
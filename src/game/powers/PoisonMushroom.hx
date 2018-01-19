package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.Scores;
import game.part.Emitters;

class PoisonMushroom extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;
	private var activated:Bool;
	private var psn:PoisonSpores;
	private var t:String;

	public function new(x:Float, y:Float, _t:String)
	{
		super(x, y);

		//timer = 300;
		timer = 900;
		activated = false;
		psn = new PoisonSpores(x, y, _t);
		t = _t;

		sprite = new Spritemap("gfx/powers/mushroom.png", 16, 28);
		setHitbox(16, 28);
		type="poisonmushroom";
		graphic = sprite;
		layer = 3;
	}

	override public function update()
	{
		if (Scores.MODE != 4) {
			for (i in 0...Types.types.length) {
				if (Types.types[i] != t) { //"mushroom") {
					var _col = collide(Types.types[i], x, y);

					if (_col != null && !activated) {
						scene.add(psn);
						timer = 300;
						activated = true;
					}
				}
			}
		} else if (Scores.MODE == 4) {
			if (collide("enemy", x, y) != null && !activated) {
				scene.add(psn);
				timer = 300;
				activated = true;
			}
		}

		/*if (activated){
			if (timer <= 0) {
				scene.remove(this);
			} else {
				timer -= 1;
			}
		}*/

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
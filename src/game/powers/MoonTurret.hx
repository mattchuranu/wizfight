package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class MoonTurret extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;
	private var shotTimer:Int;
	private var f:Int;
	private var t:String;

	public function new(x:Float, y:Float, _f:Int, _t:String)
	{
		super(x, y);

		f = _f;
		t = _t;

		timer = 300;
		shotTimer = 0;

		sprite = new Spritemap("gfx/powers/moonturret.png", 16, 16);

		if (_f == 0) {
			sprite.flipped = true;
		}

		graphic = sprite;
		type = "moonturret";
		layer = 0;
	}
	override public function update()
	{
		if (shotTimer <= 0) {
			scene.add(new MoonTurretShot(x + 8, y + 9, f, t));
			shotTimer = 30;
		} else {
			shotTimer -= 1;
		}

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
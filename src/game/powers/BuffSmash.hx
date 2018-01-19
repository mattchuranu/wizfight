package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;
import game.Types;

class BuffSmash extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;
	private var shakeTimer:Int;
	private var f:Int;
	private var t:String;

	public function new(x:Float, y:Float, _f:Int, _t:String)
	{
		super(x, y);

		timer = 20;
		shakeTimer = 5;

		f = _f;
		t = _t;

		setHitbox(16, 16);
		type = t + "_pow";
		layer = 2;
	}

	override public function added() {
		Emitters.DUSTEMITTER.smash(x, y);
	}

	override public function update()
	{
		if (timer <= 0) {
			var aX = Std.int(x / 16);

			var d = (f == 0) ? -1 : 1;
			var i = 1;

			if (collide("solid", (aX + (i * d)) * 16, y) == null && collide("solid", (aX + (i * d)) * 16, y + 16) != null) {
				scene.add(new BuffSmash((aX + (i * d)) * 16, y, f, t));
			}

			scene.remove(this);
		} else {
			if (shakeTimer <= 0) {
				if (!HXP.fullscreen) {
					HXP.camera.x = -20;
					HXP.camera.y = 0;
				} else {
					HXP.camera.x = -20 + Types._xPos;
					HXP.camera.y = Types._yPos;
				}
			} else {
				if (!HXP.fullscreen) {
					HXP.camera.x = Std.int(randomRange(Std.int(-shakeTimer/2 - 20), Std.int(shakeTimer/2 - 20)));
					HXP.camera.y = Std.int(randomRange(Std.int(-shakeTimer/2), Std.int(shakeTimer/2)));
				} else {
					HXP.camera.x = Std.int(randomRange(Std.int(-shakeTimer/2 - 20 + Types._xPos), Std.int(shakeTimer/2 - 20 + Types._xPos)));
					HXP.camera.y = Std.int(randomRange(Std.int(-shakeTimer/2 + Types._yPos), Std.int(shakeTimer/2 + Types._yPos)));
				}
				shakeTimer -= 1;
			}

			timer -= 1;
		}
		
		super.update();
	}

	private function randomRange(min:Int, max:Int) {
		return min + (Math.random() * ((max - min) + 1));
	}

	/*override public function removed() {
		Emitters.SHAKEEMITTER.rmvd(x, y);
	}*/
}
package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class LaserPow extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;
	private var set:Bool;
	private var mod:Int;

	public function new(x:Float, y:Float, dir:Int)
	{
		super(x, y + 120);

		timer = 150;
		mod = (dir == 0) ? -1 : 1;

		sprite = new Spritemap("gfx/powers/laserbeam.png", 16, 240);
		graphic = sprite;
		sprite.scaleX = 0;
		sprite.centerOrigin();
		setHitbox(16, 240);
		set = false;
		type = "laser_pow";
		layer = 2;
	}
	override public function update()
	{
		if (set) {
			if (timer <= 0) {
				if (sprite.scaleX <= 0) {
					scene.remove(this);
				} else {
					sprite.scaleX -= 0.1;
				}
			} else {
				x += mod * 0.4;
				timer -= 1;
			}

			var arrX:Array<Int> = new Array();
			var arrY:Array<Int> = new Array();
			for (i in 0...15) {
				if (collide("solid", Math.floor(x / 16) * 16, i * 16) != null) {
					arrX.push(Math.floor(x / 16) * 16);
					arrY.push(i * 16);
					trace("x: " + arrX[i] + " / y: " + arrY[i]);
				}
			}

			for (i in 0...arrX.length) {
				/*if (mod > 0) {
					var dist = (x + 12) - arrX[i];

					for (j in 0...Std.int(dist / 4)) {
						if (collide("solid", (x + 12) - (j * 4), arrY[i] - 16) == null) {
							Emitters.DUSTEMITTER.up((x + 12) - (j * 4), arrY[i] - 1);
						}
						if (collide("solid", (x + 12) - (j * 4), arrY[i] + 17) == null) {
							Emitters.DUSTEMITTER.down((x + 12) - (j * 4), arrY[i] + 16);
						}
					}
				} else {
					var dist = arrX[i] + 16 - x;

					for (j in 0...Std.int(dist / 4)) {
						if (collide("solid", x + (j * 4), arrY[i] - 16) == null) {
							Emitters.DUSTEMITTER.up(x + (j * 4), arrY[i] - 1);
						}
						if (collide("solid", x + (j * 4), arrY[i] + 17) == null) {
							Emitters.DUSTEMITTER.down(x + (j * 4), arrY[i] + 16);
						}
					}
				}*/
				//Emitters.SHAKEEMITTER.rmvd(arrX[i], arrY[i]);
			}
		} else {
			if (sprite.scaleX >= 1) {
				set = true;
			} else {
				sprite.scaleX += 0.1;
			}
		}
		
		super.update();
	}

	override public function removed() {
		Emitters.SHAKEEMITTER.rmvd(x, y);
	}
}
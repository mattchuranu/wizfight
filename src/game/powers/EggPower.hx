package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import game.part.Emitters;
import flash.geom.Point;

class EggPower extends Entity
{
	private var sprite:Spritemap;
	private var emitTimer:Int;
	private var dir:Float;
	private var velocity:Point;
	private var onGround:Bool;
	private var onWall:Bool;
	private var moveSpeed:Int;
	private var gravity:Point;
	private var maxVel:Point;
	private var friction:Point;
	private var lndplyd:Bool;
	private var lndSnd:Sfx;
	private var timer:Int;
	private var angleMod:Int;
	private var t:String;

	public function new(x:Float, y:Float, _dir:Float, _t:String)
	{
		super(x, y);

		sprite = new Spritemap("gfx/powers/eggpower.png", 6, 8);

		dir = _dir;
		t = _t;
		sprite.centerOrigin();
		setHitbox(6, 8, 3, 4);
		//sprite.flipped = (dir == 0) ? true : false;
		angleMod = (dir == 0) ? 1 : -1;
		graphic = sprite;
		layer = 2;
		type = t + "_pow";
		timer = 150;

		lndplyd = false;

		gravity = new Point(0, 1.0); //original x = 0, y = 1.8
		maxVel = new Point(10, 12); //original x = 2, y = 12

		var mult = (dir == 0) ? -1 : 1;
		velocity = new Point(6 * mult, -8);

		friction = new Point(1.2, 0.6);
	}

	override public function update()
	{
		goneTooFarThisTime();

		sprite.angle += 2 * angleMod;

		if (velocity.y > 2) {
			lndplyd = false;
		}

		checkMaxVelocity();
		applyVelocity();
		applyGravity();
		applyFriction();

		super.update();
	}

	private function applyGravity() {
		velocity.x += gravity.x;
		velocity.y += gravity.y;
	}

	private function applyVelocity()
	{
		onGround = false;
		onWall = false;

		for (i in 0...Std.int(Math.abs(velocity.x) + 1)) {
			if (collide("solid", x + HXP.sign(velocity.x), y) != null) {
				onWall = true;
				velocity.x = 0;
				if (dir == 1) {
					dir = 0;
				} else {
					dir = 1;
				}
			}

			else {
				x += HXP.sign(velocity.x);
			}
		}

		for(i in 0...Std.int(Math.abs(velocity.y) + 1)) {
			if (collide("solid", x, y + HXP.sign(velocity.y)) != null) {
				if (HXP.sign(velocity.y) == HXP.sign(gravity.y)) {
					if (!lndplyd) {
						if (HXP.sign(velocity.y) > 0) {
							Emitters.DUSTEMITTER.up(x - 3, y - 10);

							var aX = Std.int(x / 16);
							var aY = Std.int(y / 16);

							for (i in 0...3) {
								var xMod = i;
								if (i == 2) {
									xMod = -1;
								}
								if (collide("solid", (aX + xMod) * 16, aY * 16) == null && collide("solid", (aX + xMod) * 16, (aY * 16) + 16) != null) {
									scene.add(new Egged((aX + xMod) * 16, aY * 16, t)); 
								}
							}

							scene.remove(this);
						}

						lndplyd = true;
					}
					onGround = true;
				}
				velocity.y = 0;
			}
			else {
				y += HXP.sign(velocity.y);
			}
		}
	}

	private function checkMaxVelocity()
	{
		if (maxVel.x > 0 && Math.abs(velocity.x) > maxVel.x) {
			velocity.x = maxVel.x * HXP.sign(velocity.x);
		}

		if (maxVel.y > 0 && Math.abs(velocity.y) > maxVel.y) {
			velocity.y = maxVel.y * HXP.sign(velocity.y);
		}
	}

	private function applyFriction() 
	{
		if (onGround && friction.x != 0) {
			if (velocity.x > 0) {
				velocity.x -= friction.x;

				if (velocity.x < 0) {
					velocity.x = 0;
				}
			}

			else if (velocity.x < 0) {
				velocity.x += friction.x;

				if (velocity.x > 0) {
					velocity.x = 0;
				}
			}
		}

		if (onWall && friction.y != 0) {
			if (velocity.y > 0) {
				velocity.y -= friction.y;

				if (velocity.y < 0) {
					velocity.y = 0;
				}
			}

			else if (velocity.y < 0) {
				velocity.y += friction.y;

				if (velocity.y > 0) {
					velocity.y = 0;
				}
			}
		}
	}

	private function goneTooFarThisTime() {
		if (x <= 0) {
			x = 320;
		} else if (x >= 320) {
			x = 0;
		}

		if (y >= 256) {
			scene.remove(this);
		}
	}

	private function randomRange(min:Int, max:Int) {
		return min + (Math.random() * ((max - min) + 1));
	}

	override public function removed() {
		Emitters.SHAKEEMITTER.rmvd(x, y);
	}
}
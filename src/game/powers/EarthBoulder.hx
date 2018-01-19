package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import game.part.Emitters;
import flash.geom.Point;

class EarthBoulder extends Entity
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

	public function new(x:Float, y:Float, _dir:Float, _t:String)
	{
		super(x, y);

		sprite = new Spritemap("gfx/powers/earthwizpow.png", 24, 24);

		dir = _dir;
		setHitbox(24, 24, 12, 12);
		sprite.centerOrigin();
		graphic = sprite;
		layer = 2;
		type = _t + "_pow";
		timer = 300;

		lndplyd = false;
		lndSnd = new Sfx("snd/bldlnd.wav");

		gravity = new Point(0, 2.0); //original x = 0, y = 1.8
		maxVel = new Point(1, 12); //original x = 2, y = 12
		velocity = new Point(0, 0);
		friction = new Point(1.2, 0.6);
	}

	override public function update()
	{
		if (timer <= 0) {
			scene.remove(this);
		} else {
			timer -= 1;
		}
		
		goneTooFarThisTime();

		if (velocity.y > 2) {
			lndplyd = false;
		}

		if (dir == 0) {
			if (onGround) {
				velocity.x -= 1;
			}
			sprite.angle += 4;
		} else {
			if (onGround) {
				velocity.x += 1;
			}
			sprite.angle -= 4;
		}

		if (onGround) {
			if (collide("solid", x, y + 1) != null) {
				Emitters.ROLLEMITTER.roll(x - (velocity.x * 2), y + 10);
			}
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
						lndSnd.play(0.5);
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
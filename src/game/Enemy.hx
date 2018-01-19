package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Joystick;
import com.haxepunk.Sfx;
import flash.geom.Point;
import game.part.Emitters;
//import game.part.TrailEmitter;
//import game.part.BlurEmitter;
//import game.powers.Outline;

class Enemy extends Entity
{
	private var sprite:Spritemap;
	private var onGround:Bool;
	private var onWall:Bool;
	private var moveSpeed:Float;
	private var gravity:Point;
	private var maxVel:Point;
	private var facing:Int; //0 = left, 1 = right
	private var velocity:Point;
	private var friction:Point;
	private var dim:Point;
	private var gamepad:Joystick;
	private var deathSmoke:Int;
	private var blurTimer:Int;
	//private var blurEmitter:BlurEmitter;
	private var spawnSet:Bool;
	private var nearSpawn:Entity;
	private var shotSnd:Sfx;
	private var grndSnd:Sfx;
	private var deathSnd:Sfx;
	private var trvlSnd:Sfx;
	private var jmpSnd:Sfx;
	private var lndSnd:Sfx;
	private var jmpPlyd:Bool;
	private var stunTimer:Int;
	private var float:Bool;
	private var bananaTimer:Int;
	private var gold:Bool;
	private var dust:Bool;
	//private var ol:Outline;
	private var normalFriction:Point;
	private var icedFriction:Point;
	private var bananaFriction:Point;
	private var normalMaxVel:Point;
	private var barnacledMaxVel:Point;
	private var bananaMaxVel:Point;
	private var normalGravity:Point;

	public function new(x:Float, y:Float, _type:String, _speed:Int, _w:Int, _h:Int, ?velx:Int, ?f:Bool)
	{
		super(x, y);

		sprite = new Spritemap("gfx/enemy/" + _type + ".png", _w, _h);
		//blur = _speed;
		graphic = sprite;
		layer = 1;
		type = "enemy";
		facing = Std.random(2);

		//blurEmitter = new BlurEmitter(_type);

		deathSnd = new Sfx("snd/death.wav");
		jmpSnd = new Sfx("snd/jump.wav");
		lndSnd = new Sfx("snd/land.wav");

		setHitbox(_w, _h);

		onGround = false;
		onWall = false;
		jmpPlyd = true;
		gold = false;
		dust = false;
		moveSpeed = 1;
		deathSmoke = 1;
		blurTimer = 10;
		stunTimer = 0;
		bananaTimer = 0;
		dim = new Point(12, 16);

		float = false;
		if (f != null) {
			float = f;
		}

		gravity = new Point(0, 0.97); //original x = 0, y = 1.6, new y = 0.97
		maxVel = new Point(2, 9); //original x = 2, y = 12, new y = 9
		friction = new Point(1.2, 0.05); //original x = 1.2, y = 0.6, new y = 0.05
		//ol = new Outline(x - 1, y - 1);

		if (_speed == 0) {
			gravity = new Point(0, 0.97);
			normalGravity = new Point(0, 0.97);

			maxVel = new Point(2, 9);
			normalMaxVel = new Point(2, 9);
			bananaMaxVel = new Point(5, 9);
			barnacledMaxVel = new Point(0.0005, 0);

			friction = new Point(1.2, 0.05);
			normalFriction = new Point(1.2, 0.05);
			icedFriction = new Point(0.02, 0.005);
			bananaFriction = new Point(0.02, 0.05);
		} else if (_speed == 1) {
			gravity = new Point(0, 1.6);
			normalGravity = new Point(0, 1.6);

			maxVel = new Point(2, 12);
			normalMaxVel = new Point(2, 12);
			bananaMaxVel = new Point(5, 12);
			barnacledMaxVel = new Point(0.0005, 0);

			friction = new Point(1.2, 0.6);
			normalFriction = new Point(1.2, 0.6);
			icedFriction = new Point(0.02, 0.06);
			bananaFriction = new Point(0.02, 0.6);
		}

		if (velx != null) {
			maxVel.x = velx;
			normalMaxVel.x = velx;
			bananaMaxVel.x = Math.floor((maxVel.x - velx) / maxVel.x) * bananaMaxVel.x;
			barnacledMaxVel.x = Math.floor((maxVel.x - velx) / maxVel.x) * barnacledMaxVel.x;
		}

		velocity = new Point(0, 0);
	}

	override public function added() {
		//scene.add(blurEmitter);
		//scene.add(ol);
	}

	override public function update()
	{
		if (type == "runner") {
			velocity.x = ((facing > 0) ? 1 : -1) * maxVel.x;
		}

		if (stunTimer > 0) {
			stunTimer -= 1;
		}

		if (bananaTimer > 0) {
			bananaTimer -= 1;
		}

		gravity = normalGravity;

		if (scene.typeCount("dark_pow") > 0) {
			var blackhole = scene.nearestToPoint("dark_pow", x, y, true);

			var dir = -Math.atan2((blackhole.y) - y, (blackhole.x) - x) - (180 * 0.017453292519);

			var newx = x - 3*Math.cos(dir)*1;
			var newy = y + 3*Math.sin(dir)*1;

			gravity = new Point(newx - x, newy - y);
		}

		if (stunTimer <= 0) {
			gold = false;
			/*if (ol.sprite.alpha > 0) {
				ol.updateSprite(0);
			}*/
		} else {
			/*if (ol.sprite.alpha < 1) {
				ol.updateSprite(1);
			}

			if (gold) {
				ol.updateSprite(1);
				ol.sprite.setFrame(0, 0);
			} else {
				ol.updateFrame(1);
			}*/
		}

		if (collide("bananapeel", x, y) != null) {
			bananaTimer = 120;
			velocity.x = ((facing > 0) ? 1 : -1) * bananaMaxVel.x;
			var peel = collide("bananapeel", x, y);
			scene.remove(peel);
		}

		if (cast(scene, Level).icedTimer > 0) {
			friction = icedFriction;
		}else if (bananaTimer > 0) {
			friction = bananaFriction;
		} else {
			friction = normalFriction;
		}

		if (cast(scene, Level).icedTimer > 0) {
			moveSpeed = 0.05;
		} else {
			moveSpeed = 1;
		}

		if (collide("barnacled", x, y) != null) {
			maxVel = barnacledMaxVel;
		}else if (bananaTimer > 0) {
			maxVel = bananaMaxVel;
		} else {
			maxVel = normalMaxVel;
		}

		//ol.sprite.flipped = sprite.flipped;
		//ol.x = x - 1;
		//ol.y = y - 1;

		if (velocity.y > 2) {
			jmpPlyd = false;
		}

		checkDeath();

		if (stunTimer <= 0 && !gold) {
			if (blurTimer <= 0) {
				//blurEmitter.blur(x + (sprite.width / 2), y + (sprite.height / 2), facing);
				blurTimer = 1;
			} else {
				blurTimer -= 1;
			}

			if (collide("gold", x, y) != null) {
				stunTimer = 300;
				gold = true;
			}
		}

		if (cast(scene, Level).chaosTimer > 0) {
			velocity.x = -velocity.x;
		}

		if (!float) {
			applyVelocity();
			applyGravity();
		}

		checkMaxVelocity();
		applyFriction();
		goneTooFarThisTime();

		super.update();
	}

	private function applyGravity() {
		velocity.x += gravity.x;
		velocity.y += gravity.y;
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

	private function applyVelocity()
	{
		onGround = false;
		onWall = false;

		for (i in 0...Std.int(Math.abs(velocity.x) + 1)) {
			if (collide("solid", x + HXP.sign(velocity.x), y) != null) {
				onWall = true;
				if (type == "runner") {
					velocity.x = -velocity.x;
				}
				//velocity.x = 0;
			}
			else {
				x += HXP.sign(velocity.x);
			}
		}

		for(i in 0...Std.int(Math.abs(velocity.y) + 1)) {
			if (collide("solid", x, y + HXP.sign(velocity.y)) != null) {
				if (HXP.sign(velocity.y) == HXP.sign(gravity.y)) {
					if (!jmpPlyd) {
						lndSnd.play(0.5);
						jmpPlyd = true;
					}
					onGround = true;
				}
				if (!dust) {
					if (HXP.sign(velocity.y) > 0) { 
						if (facing == 0) {
							Emitters.DUSTEMITTER.up(x + 1, y);
						} else {
							Emitters.DUSTEMITTER.up(x - 1, y);
						}
					} else {
						Emitters.DUSTEMITTER.down(x, y); 
					}
					dust = true;
				}
				velocity.y = 0;
			}
			else {
				dust = false;
				y += HXP.sign(velocity.y);
			}
		}
	}

	private function checkDeath() {
		if (collide("lava", x, y) != null) {
			deathSnd.play(0.5);
			scene.remove(this);
		}

		if (collide("trap", x, y) != null) {
			deathSnd.play();
			scene.remove(this);
		}

		for (i in 0...Types.types.length) {
			var _shot = collide(Types.types[i] + "_shot", x, y);
			var _pow = collide(Types.types[i] + "_pow", x, y);
			var _stun = collide(Types.types[i] + "_stun", x, y);

			if (_stun != null) {
				stunTimer = 150;
			}

			if (_shot != null || _pow != null) {
				if (_shot != null) scene.remove(_shot);

				deathSnd.play();
				scene.remove(this);
			}
		}

		if (type == "runner") {
			if (y > 240) {
				scene.remove(this);
			}
		}
	}

	private function goneTooFarThisTime() {
		if (x <= -12) {
			x = 320;
		}
		else if (x >= 320) {
			x = -12;
		}

		if (y <= -12) {
			y = 240;
		}
		else if (y >= 240) {
			y = -12;
		}
	}

	private function randomRange(min:Int, max:Int) {
		return min + (Math.random() * ((max - min) + 1));
	}
}
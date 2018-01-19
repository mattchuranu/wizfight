package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
//import com.haxepunk.masks.Grid;
//import com.haxepunk.ai.GridPath;
//import com.haxepunk.ai.PathNode;
import game.part.Emitters;
import game.part.BlurEmitter;
import flash.geom.Point;
import flash.display.BitmapData;
import game.powers.Orb;

class EnemyTwo extends Entity
{
	private var sprite:Spritemap;
	private var emitTimer:Int;
	private var dir:Float;
	private var velocity:Point;
	private var onGround:Bool;
	private var onWall:Bool;
	private var moveSpeed:Float;
	private var gravity:Point;
	private var maxVel:Point;
	private var friction:Point;
	private var lndplyd:Bool;
	private var lndSnd:Sfx;
	private var deathSnd:Sfx;
	private var normalFriction:Point;
	private var icedFriction:Point;
	private var bananaFriction:Point;
	private var normalMaxVel:Point;
	private var barnacledMaxVel:Point;
	private var bananaMaxVel:Point;
	private var normalGravity:Point;
	private var altType:String;
	private var health:Int;
	private var bananaTimer:Int;
	private var stunTimer:Int;
	private var blurTimer:Int;
	private var shotTimer:Int;
	private var knockbackTimer:Int;
	private var blurEmitter:BlurEmitter;
	private var knockback:Bool;
	private var knockbackAng:Float;
	private var jumpTimer:Int;
	private var chaseSpeed:Float;
	private var dest:Point;
	/*private var grid:Grid;
	private var gridPath:GridPath;
	private var path:Array<PathNode>;
	private var pathStart:Point;
	private var chasing:String;
	private var currentNode:PathNode;*/

	public function new(x:Float, y:Float, _type:String, _sprite:String, _speed:Int, _w:Int, _h:Int, ?hlth:Int, ?velx:Float, ?knckbck:Int)
	{
		super(x, y);

		sprite = new Spritemap(BitmapData.load("gfx/enemy/" + _sprite + ".png"), _w, _h);

		if (_type == "turret") sprite.centerOrigin();

		dir = Std.int(randomRange(0, 1));
		setHitbox(_w, _h);
		graphic = sprite;
		layer = 1;
		type = "enemy";
		altType = _type;

		health = 1;
		if (hlth != null) {
			health = hlth;
		}

		knockback = false;

		if (knckbck != null) {
			knockback = (knckbck == 0) ? false : true;
		}

		lndplyd = false;
		lndSnd = new Sfx("snd/land.wav");
		deathSnd = new Sfx("snd/death.wav");

		gravity = new Point(0, 2.0); //original x = 0, y = 1.8
		maxVel = new Point(1, 12); //original x = 2, y = 12
		velocity = new Point(0, 0);
		friction = new Point(1.2, 0.6);
		moveSpeed = 1;

		blurEmitter = new BlurEmitter("enemy/" + _sprite, _w, _h);
		blurTimer = 10;

		//timers...other than blur
		stunTimer = 0;
		bananaTimer = 0;
		if (_type == "turret") shotTimer = 120;
		if (_type == "jumper") jumpTimer = Std.random(120);
		knockbackTimer = 0;

		knockbackAng = 0;

		dest = new Point(Std.random(320), Std.random(240));

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
			//bananaMaxVel.x = Math.floor((maxVel.x - velx) / maxVel.x) * bananaMaxVel.x;
			//barnacledMaxVel.x = Math.floor((maxVel.x - velx) / maxVel.x) * barnacledMaxVel.x;
		}

		if (_type == "chaser" || _type == "flier") {
			maxVel = new Point(20, 20);
			chaseSpeed = velx;
		}
	}

	override public function added()
	{
		scene.add(blurEmitter);
	}

	override public function update()
	{
		goneTooFarThisTime();

		if (altType != "turret") sprite.setFrame(Std.int(1 - dir), 0);

		if (stunTimer > 0) {
			stunTimer -= 1;
		}

		if (bananaTimer > 0) {
			bananaTimer -= 1;
		}

		if (knockbackTimer > 0) {
			knockbackTimer -= 1;
		}

		if (velocity.y > 2) {
			lndplyd = false;
		}

		if (altType != "turret") {
			if (blurTimer <= 0) {
				blurEmitter.blur(x + (sprite.width / 2), y + (sprite.height / 2), Std.int(dir));
				blurTimer = 1;
			} else {
				blurTimer -= 1;
			}
		}

		if (altType == "jumper") {
			if (jumpTimer <= 0 && onGround && stunTimer <= 0 && bananaTimer <= 0) {
				velocity.y = -6 / ((sprite.width / 8) * (sprite.height / 8));
				jumpTimer = Std.random(120);
			} else {
				jumpTimer -= 1;
			}
		}

		if (altType == "flier") {
			if (distanceToPoint(dest.x, dest.y, false) < 10) {
				dest = new Point(Std.random(320), Std.random(240));
			} else {
				var ang = Math.atan2(dest.y - y, dest.x - x);

				var ang2 = -ang - degreeradian(180);

				if (cast(scene, Level).chaosTimer > 0) {
					x = x - chaseSpeed*Math.cos(ang2 - degreeradian(180))*1;
				} else {
					x = x - chaseSpeed*Math.cos(ang2)*1;
				}
				y = y + chaseSpeed*Math.sin(ang2)*1;

				if (dest.x > x) {
					dir = 1;
				} else {
					dir = 0;
				}
			}
		}

		if (altType == "chaser" || altType == "turret" || altType == "flier") {
			var near = "";

			for (i in 0...Types.types.length) {
				if (near == "") {
					if (scene.typeCount(Types.types[i]) > 0) {
						near = Types.types[i];
					}
				} else {
					if (scene.typeCount(Types.types[i]) > 0) {
						var current = scene.nearestToPoint(Types.types[i], x, y);
						var n = scene.nearestToPoint(near, x, y);

						if (distanceToPoint(current.x, current.y, true) < distanceToPoint(n.x, n.y, true) && !cast(current, Player).dead) {
							near = Types.types[i];
						}
					}
				}
			}

			if (near != "") {
				var plyr = scene.nearestToPoint(near, x, y);

				var ang = 0.01;
				if (cast(scene, Level).fogTimer <= 0 && cast(plyr, Player).invisiTimer <= 0) {
					ang = Math.atan2(plyr.y - y, plyr.x - x);
				} else {
					ang = Std.random(360);
				}

				if (knockbackTimer > 0) {
					ang = knockbackAng;
				}

				var ang2 = -ang - degreeradian(180);

				if (altType == "chaser" && stunTimer <= 0) {
					if (cast(scene, Level).chaosTimer > 0) {
						x = x - chaseSpeed*Math.cos(ang2 - degreeradian(180))*1;
					} else {
						x = x - chaseSpeed*Math.cos(ang2)*1;
					}
					y = y + chaseSpeed*Math.sin(ang2)*1;

					if (plyr.x > x) {
						dir = 1;
					} else {
						dir = 0;
					}
				} else if ((altType == "turret" || altType == "flier") && stunTimer <= 0) {
					if (altType == "turret") sprite.angle = -(ang * (180 / Math.PI)) + 90;
					if (shotTimer <= 0 && cast(scene, Level).zenTimer <= 0) {
						scene.add(new EnemyShot(x, y, ang2));
						shotTimer = 120;
					} else {
						shotTimer -= 1;
					}
				}
			}
		}

		if (altType == "fraidycat") {
			checkPlatform();
		}

		if (altType == "runner" || altType == "fraidycat" || altType == "jumper") {
			if (collide("bananapeel", x, y) != null) {
				bananaTimer = 150;
				velocity.x = ((dir > 0) ? 1 : -1) * bananaMaxVel.x;
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
			} else if (bananaTimer > 0) {
				maxVel = bananaMaxVel;
			} else {
				maxVel = normalMaxVel;
			}
		}

		if (collide("gold", x, y) != null) {
			stunTimer = 300;
		}

		if (bananaTimer <= 0 && stunTimer <= 0) {
			startMoving();
		}

		if (scene.typeCount("dark_pow") > 0) {
			var blackhole = scene.nearestToPoint("dark_pow", x, y, true);

			var direc = -Math.atan2((blackhole.y) - y, (blackhole.x) - x) - (180 * 0.017453292519);

			var newx = x - 3*Math.cos(direc)*1;
			var newy = y + 3*Math.sin(direc)*1;

			gravity = new Point((newx - x) / (sprite.width / 8), (newy - y) / (sprite.height / 8));
		} else {
			gravity = normalGravity;
		}

		if (cast(scene, Level).chaosTimer > 0) {
			velocity.x = -velocity.x;
		}

		checkMaxVelocity();

		if (Math.abs(velocity.x) > 0 || Math.abs(velocity.y) > 0) {
			applyVelocity();

			if (altType == "chaser" || altType == "turret") {
				if (Math.abs(velocity.x) < 0.2 * (sprite.width / 8)) {
					velocity.x = 0;
				} else {
					velocity.x -= HXP.sign(velocity.x) * 0.2 * (sprite.width / 8);
				}

				if (Math.abs(velocity.y) < 0.2 * (sprite.height / 8)) {
					velocity.y = 0;
				} else {
					velocity.y -= HXP.sign(velocity.y) * 0.2 * (sprite.height / 8);
				}
			}
		}

		if (altType == "runner" || altType == "fraidycat" || altType == "jumper" || scene.typeCount("dark_pow") > 0) {
			applyGravity();
		}

		applyFriction();
		checkDeath();

		super.update();
	}

	private function startMoving() {
		if (altType == "runner" || altType == "fraidycat" || altType == "jumper") {
			if (dir == 0) {
				if (onGround) {
					velocity.x -= 1 * moveSpeed;
				}
			} else {
				if (onGround) {
					velocity.x += 1 * moveSpeed;
				}
			}
		}
	}

	private function checkPlatform() {
		if (collide("solid", x + sprite.width, y + 2) == null || collide("solid", x - sprite.width, y + 2) == null) {
			dir = 1 - dir;
		}
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
				if (altType == "runner" || altType == "fraidycat" || altType == "jumper") {
					dir = 1 - dir;
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

	private function checkDeath() {
		if (collide("trap", x, y) != null || collide("lava", x, y) != null) {
			deathSnd.play();
			Emitters.DEATHEMITTER.death(x + (sprite.width / 2), y + (sprite.height / 2));
			scene.remove(this);
		}

		if (collide("spawn", x, y) != null) {
			if (cast(collide("spawn", x, y), SpawnPoint).velocity.x > 4 || cast(collide("spawn", x, y), SpawnPoint).velocity.y > 6) {
				deathSnd.play();
				Emitters.DEATHEMITTER.death(x + (sprite.width / 2), y + (sprite.height / 2));
				scene.remove(this);
			}
		}

		for (i in 0...Types.types.length) {
			var _shot = collide(Types.types[i] + "_shot", x, y);
			var _pow = collide(Types.types[i] + "_pow", x, y);
			var _stun = collide(Types.types[i] + "_stun", x, y);

			if (_stun != null) {
				stunTimer = 150;
			}

			if (_shot != null || _pow != null) {
				if (_shot != null) {
					Emitters.DUSTEMITTER.hit(_shot.x + 3, _shot.y + 3);

					if (knockback) {
						if (altType == "runner" || altType == "fraidycat") {
							var dist = maxVel.x / ((sprite.width / 8) * (sprite.height / 8));
							var mult = (_shot.x > x) ? -1 : 1;
							velocity.x = mult * dist;
							velocity.y = -4 / ((sprite.width / 8) * (sprite.height / 8));
							/*if (sprite.height < 16 && sprite.width < 16) {
								velocity.x = HXP.sign(x - _shot.x) * 6;
								velocity.y = -6;
							} else {
								velocity.x = HXP.sign(x - _shot.x) * 3;
								velocity.y = -3;
							}*/
						} 

						if (altType == "chaser" || altType == "flier") {
							var ang = Math.atan2(_shot.centerY - centerY, _shot.centerX - centerX);
							//knockbackAng = ang - degreeradian(180);
							//knockbackTimer = Std.int(30 / ((sprite.width / 8) * (sprite.height / 8)));
							var newx = ( 4 / ((sprite.width / 8) * (sprite.height / 8)) ) * Math.cos(ang - degreeradian(180));
							var newy = ( 4 / ((sprite.width / 8) * (sprite.height / 8)) ) * Math.sin(ang - degreeradian(180));

							//velocity = new Point((newx - x) / ((sprite.width / 8) * (sprite.height / 8)), (newy - y) / ((sprite.width / 8) * (sprite.height / 8)));
							velocity.x = newx;
							velocity.y = newy;
						}
					}

					scene.remove(_shot);
					health -= 1;
				}
			}

			if (_pow != null) {
				health = 0;
			}

			if (health <= 0) {
				Scores.SCORES[i] += 1;
			}
		}

		if (health <= 0) {
			scene.add(
				new Orb(
					(Std.int(x / 16) * 16) + 6,
					(Std.int(y / 16) * 16) + 9
					));
			deathSnd.play();
			Emitters.DEATHEMITTER.death(x + (sprite.width / 2), y + (sprite.height / 2));
			scene.remove(this);
		}
	}

	private function goneTooFarThisTime() {
		if (x <= 0) {
			x = 320;
		} else if (x >= 320) {
			x = 0;
		}

		/*if (y >= 256) {
			scene.remove(this);
		}*/

		if (y <= -12) {
			y = 240;
		} else if (y >= 240) {
			y = -12;
		}
	}

	private function randomRange(min:Int, max:Int) {
		return min + (Math.random() * ((max - min) + 1));
	}

	private function distanceTo(x1:Float, y1:Float, x2:Float, y2:Float) {
		return Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
	}

	private function degreeradian(a:Float)
	{
		return a * 0.017453292519;
	}
}
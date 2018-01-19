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
import game.part.TrailEmitter;
import game.part.BlurEmitter;
import game.powers.Outline;
import game.powers.EarthBoulder;
import game.powers.NakedRadius;
import game.powers.RainbowUnicorn;
import game.powers.Iced;
import game.powers.LightningBolt;
import game.powers.Barnacled;
import game.powers.FlowerBase;
import game.powers.PeppermintStick;
import game.powers.PoisonMushroom;
import game.powers.FirePillar;
import game.powers.Sun;
import game.powers.OceanWater;
import game.powers.BloodDrop;
import game.powers.BaconStrip;
import game.powers.Fogged;
import game.powers.EggPower;
import game.powers.Broom;
import game.powers.PotatoBomb;
import game.powers.BuffSmash;
import game.powers.Blackhole;
import game.powers.MoonTurret;
import game.powers.LaserPow;
import game.powers.BananaPeel;
import game.powers.CherryBomb;
import game.powers.GoatTongue;
import game.powers.Pizza;

class Player extends Entity
{
	private var sprite:Spritemap;
	private var up:Int;
	private var down:Int;
	private var l:Int;
	private var r:Int;
	private var hitone:Int;
	private var hittwo:Int;
	private var onGround:Bool;
	private var onWall:Bool;
	private var moveSpeed:Float;
	private var gravity:Point;
	private var maxVel:Point;
	private var facing:Int; //0 = left, 1 = right
	private var velocity:Point;
	private var friction:Point;
	private var dim:Point;
	public var dead:Bool;
	private var teleporting:Bool;
	private var blur:Int;
	private var gamepad:Joystick;
	private var deathTimer:Int;
	private var deathSmoke:Int;
	private var moveTimer:Int;
	private var blurTimer:Int;
	private var blurEmitter:BlurEmitter;
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
	private var floatTimer:Int;
	private var coffeeTimer:Int;
	public var invisiTimer:Int;
	private var bananaTimer:Int;
	public var power:Int;
	private var gold:Bool;
	private var naked:Bool;
	public var powerTimer:Int;
	private var dust:Bool;
	private var ol:Outline;
	private var normalFriction:Point;
	private var icedFriction:Point;
	private var coffeeFriction:Point;
	private var bananaFriction:Point;
	private var normalMaxVel:Point;
	private var barnacledMaxVel:Point;
	private var coffeeMaxVel:Point;
	private var bananaMaxVel:Point;
	private var normalGravity:Point;
	public var altType:String;
	private var goatTimer:Int;
	private var goatArr:Array<GoatTongue>;

	public function new(x:Float, y:Float, _type:String, _up:Int, _down:Int, _left:Int, _right:Int, _hitone:Int, _hittwo:Int, _speed:Int, ?_gamepad:Joystick)
	{
		super(x, y);

		sprite = new Spritemap("gfx/wiz/" + _type + "wiz.png", 12, 16);
		blur = _speed;
		graphic = sprite;
		layer = 1;
		type = _type;
		facing = 1;

		altType = _type;

		if (type == "thief") {
			altType = _type;
		}

		if (type == "mimic") {
			altType = Types.types[Std.int(randomRange(0, Types.types.length))];
		}

		blurEmitter = new BlurEmitter("wiz/" + _type + "wiz", 12, 16);

		shotSnd = new Sfx("snd/shoot.wav");
		grndSnd = new Sfx("snd/place.wav");
		deathSnd = new Sfx("snd/death.wav");
		trvlSnd = new Sfx("snd/travel.wav");
		jmpSnd = new Sfx("snd/jump.wav");
		lndSnd = new Sfx("snd/land.wav");

		setHitbox(12, 16);

		gamepad = null;
		if (_gamepad != null) {
			gamepad = _gamepad;
		}

		up = _up;
		down = _down;
		l = _left;
		r = _right;
		hitone = _hitone;
		hittwo = _hittwo;
		onGround = false;
		onWall = false;
		dead = false;
		teleporting = false;
		spawnSet = false;
		jmpPlyd = true;
		gold = false;
		naked = false;
		dust = false;
		moveSpeed = 1;
		deathSmoke = 1;
		deathTimer = 0;
		moveTimer = 90;
		blurTimer = 10;
		floatTimer = 0;
		stunTimer = 0;
		powerTimer = 0;
		coffeeTimer = 0;
		bananaTimer = 0;
		dim = new Point(12, 16);
		power = 3;

		goatTimer = 0;
		goatArr = new Array();

		gravity = new Point(0, 0.97); //original x = 0, y = 1.6, new y = 0.97
		maxVel = new Point(2, 9); //original x = 2, y = 12, new y = 9
		friction = new Point(1.2, 0.05); //original x = 1.2, y = 0.6, new y = 0.05
		ol = new Outline(x - 1, y - 1);

		if (_speed == 0) {
			gravity = new Point(0, 0.97);
			normalGravity = new Point(0, 0.97);

			maxVel = new Point(2, 9);
			normalMaxVel = new Point(2, 9);
			bananaMaxVel = new Point(5, 9);
			barnacledMaxVel = new Point(0.0005, 0);
			coffeeMaxVel = new Point(5, 9);

			friction = new Point(1.2, 0.05);
			normalFriction = new Point(1.2, 0.05);
			icedFriction = new Point(0.02, 0.005);
			coffeeFriction = new Point(0.2, 0.05);
			bananaFriction = new Point(0.02, 0.05);
		} else if (_speed == 1) {
			gravity = new Point(0, 1.6);
			normalGravity = new Point(0, 1.6);

			maxVel = new Point(2, 12);
			normalMaxVel = new Point(2, 12);
			bananaMaxVel = new Point(5, 12);
			barnacledMaxVel = new Point(0.0005, 0);
			coffeeMaxVel = new Point(5, 12);

			friction = new Point(1.2, 0.6);
			normalFriction = new Point(1.2, 0.6);
			icedFriction = new Point(0.02, 0.06);
			coffeeFriction = new Point(0.2, 0.6);
			bananaFriction = new Point(0.02, 0.6);
		}

		velocity = new Point(0, 0);
	}

	override public function added() {
		scene.add(blurEmitter);
		scene.add(ol);
	}

	override public function update()
	{
		/*for (i in 0...Types.types.length) {
			if (type == Types.types[i]) { 
				Scores.POWER[i] = 3;
			}
		}*/

		if (invisiTimer > 0) {
			invisiTimer -= 1;
		}

		if (deathTimer > 0 && invisiTimer <= 0) {
			sprite.alpha = 0.3;
			deathTimer -= 1;
		} else if (invisiTimer > 0) {
			sprite.alpha = 0;
		} else { sprite.alpha = 1; }

		if (floatTimer > 0) {
			floatTimer -= 1;
		}

		if (stunTimer > 0) {
			stunTimer -= 1;
		}

		if (coffeeTimer > 0) {
			coffeeTimer -= 1;
		}

		if (bananaTimer > 0) {
			bananaTimer -= 1;
		}

		if (powerTimer > 0) {
			for (i in 0...Types.types.length) {
				if (type == Types.types[i]) { 
					Emitters.POWEREMITTERS[i].trail(x + 2 + Std.random(8), y + 2 + Std.random(12));
				}
			}
			powerTimer -= 1;
		}

		gravity = normalGravity;

		if (scene.typeCount("dark_pow") > 0 && !dead && deathTimer <=0 && (type != "dark" && altType != "dark")) {
			var blackhole = scene.nearestToPoint("dark_pow", x, y, true);

			var dir = -Math.atan2((blackhole.y) - y, (blackhole.x) - x) - (180 * 0.017453292519);

			var newx = x - 3*Math.cos(dir)*1;
			var newy = y + 3*Math.sin(dir)*1;

			gravity = new Point(newx - x, newy - y);
		}

		if (goatTimer > 0) {
			if (!dead && deathTimer <=0) {
				var goat = scene.nearestToPoint("goat", x, y, true);

				facing = (goat.x > x) ? 0 : 1;
				sprite.flipped = (goat.x > x) ? true : false;

				if (cast(goat, Player).dead) {
					goatTimer = 0;
				}

 				var dir = -Math.atan2((goat.y) - y, (goat.x) - x) - (180 * 0.017453292519); //1, 7 or 10, 7
				var goatdist = Math.sqrt(Math.pow(centerX - (goat.centerX), 2) + Math.pow(centerY - (goat.y + 4), 2));
				var goatang = -Math.atan2((goat.y + 4) - centerY, (goat.centerX) - centerX) - degreeradian(180);

				if (goatArr[0] == null) {
					for (i in 0...20) {
						goatArr[i] = new GoatTongue(x, y);
						scene.add(goatArr[i]);
					}
				} else {
					for (i in 0...20) {
						goatArr[i].x = (goat.centerX) + Math.cos(goatang) * (goatdist * ((i + 1) / 20));
						goatArr[i].y = (goat.y + 4) - Math.sin(goatang) * (goatdist * ((i + 1) / 20));
					}
				}

				if (distanceFrom(goat, true) > 16) {
					var newx = x - 2*Math.cos(dir)*1;
					var newy = y + 2*Math.sin(dir)*1;
					gravity = new Point(newx - x, newy - y);
				}
			} else {
				goatTimer = 0;
			}

			goatTimer -= 1;
		} else {
			if (goatArr[0] != null) {
				for (i in 0...goatArr.length) {
					scene.remove(goatArr[i]);
					goatArr[i] = null;
				}
			}
		}

		if (stunTimer <= 0 && goatTimer <= 0) {
			gold = false;
			naked = false;
			if (ol.sprite.alpha > 0) {
				ol.updateSprite(0);
			}
		} else {
			if (ol.sprite.alpha < 1) {
				ol.updateSprite(1);
			}

			if (gold) {
				ol.updateSprite(1);
				ol.sprite.setFrame(0, 0);
			} else if (naked) {
				ol.updateFrame(2);
			} else {
				ol.updateFrame(1);
			}
		}

		if (collide("bananapeel", x, y) != null && (type != "banana" && altType != "banana")) {
			bananaTimer = 120;
			velocity.x = ((facing > 0) ? 1 : -1) * bananaMaxVel.x;
			var peel = collide("bananapeel", x, y);
			scene.remove(peel);
		}

		if (cast(scene, Level).icedTimer > 0 && type != "ice" && altType != "ice") {
			friction = icedFriction;
		} else if (coffeeTimer > 0) {
			friction = coffeeFriction;
		} else if (bananaTimer > 0) {
			friction = bananaFriction;
		} else {
			friction = normalFriction;
		}

		if (cast(scene, Level).icedTimer > 0 && type != "ice" && altType != "ice") {
			moveSpeed = 0.05;
		} else {
			moveSpeed = 1;
		}

		if (collide("barnacled", x, y) != null && type != "barnacle" && altType != "barnacle") {
			maxVel = barnacledMaxVel;
		} else if (coffeeTimer > 0) {
			maxVel = coffeeMaxVel;
			for (i in 0...Types.types.length) {
				if (type == Types.types[i]) { 
					Emitters.POWEREMITTERS[i].trail(x + 2 + Std.random(8), y + 2 + Std.random(12));
				}
			}
		} else if (bananaTimer > 0) {

			maxVel = bananaMaxVel;
		} else {
			maxVel = normalMaxVel;
		}

		//trace("vel: " + velocity.x + " / maxVel: " + maxVel.x + " / friction: " + friction.x);

		/*if (gold) {
			ol.updateSprite(1);
			ol.sprite.setFrame(0, 0);

			if (stunTimer <= 0) {
				gold = false;
			}
		} else {
			if (stunTimer <= 0) {
				naked = false;
				if (ol.sprite.alpha > 0) {
					ol.updateSprite(0);
				}
			} else {
				if (ol.sprite.alpha < 1) {
					ol.updateSprite(1);
				}
				if (naked)	ol.updateFrame(2);
				else ol.updateFrame(1);
			}
		}*/

		ol.sprite.flipped = sprite.flipped;
		ol.x = x - 1;
		ol.y = y - 1;

		if (velocity.y > 2) {
			jmpPlyd = false;
		}

		checkDeath();

		if (!dead) {
			if (stunTimer <= 0 && !gold) {
				if (blurTimer <= 0 && invisiTimer <= 0) {
					blurEmitter.blur(x + 6, y + 8, facing);
					blurTimer = 1;
				} else {
					blurTimer -= 1;
				}

				if (gamepad == null) {
					if (Input.check(l) && floatTimer <= 0 && bananaTimer <= 0) {
						if (!sprite.flipped) { sprite.flipped = true; }
						facing = 0;
						velocity.x -= moveSpeed;
						checkMaxVelocity();
					}
					if (Input.check(r) && floatTimer <= 0 && bananaTimer <= 0) {
						if (sprite.flipped) { sprite.flipped = false; }
						facing = 1;
						velocity.x += moveSpeed;
						checkMaxVelocity();
					}
					if (Input.pressed(up) && floatTimer <= 0 && bananaTimer <= 0) {
						if (onGround) {
							jmpSnd.play(0.5);
							jmpPlyd = false;
							velocity.y = -maxVel.y;
						}
					}

					if (floatTimer > 0) {
						if (Input.check(l)) {
							if (!sprite.flipped) { sprite.flipped = true; }
							facing = 0;
							if (collide("solid", x - 2, y) == null) {
								x -= 2;
							}
						}

						if (Input.check(r)) {
							if (sprite.flipped) { sprite.flipped = false; }
							facing = 1;
							if (collide("solid", x + 2, y) == null) { 
								x += 2;
							}
						}

						if (Input.check(up)) {
							if (collide("solid", x, y - 2) == null) {
								y -= 2;
							}
						}

						if (Input.check(down)) {
							if (collide("solid", x, y + 2) == null) { 
								y += 2;
							}
						}
					}

					if (Input.pressed(hittwo) && (cast(scene, Level).zenTimer <= 0 || type == "zen" || altType == "zen")) {
						for (i in 0...Types.types.length) {
							if (type == Types.types[i]) {
								if (Scores.POWER[i] == 3) {
									activatePower();
								}
							}
						}
					}

					if (Input.pressed(hitone) && deathTimer <= 0 && powerTimer <= 0 && (cast(scene, Level).zenTimer <= 0 || type == "zen" || altType == "zen")) {
						var shots = 0;
						if (scene.typeCount(type + "_shot") != null) {
							shots += scene.typeCount(type + "_shot");
						}

						if (shots < 3) {
							shotSnd.play(0.3);
							scene.add(new Shot(x + sprite.width / 2, y + sprite.height / 2, type, facing, blur));
						}
					}
				}
				else {
					if (gamepad.pressed(up) && floatTimer <= 0 && bananaTimer <= 0) {
						if (onGround) {
							jmpSnd.play(0.5);
							jmpPlyd = false;
							velocity.y = -maxVel.y;
						}
					}

					if (Math.abs(gamepad.getAxis(l)) > Joystick.deadZone + 0.2 && floatTimer <= 0 && bananaTimer <= 0) {
						if (gamepad.getAxis(l) < 0) {
							if (!sprite.flipped) { sprite.flipped = true; }
							facing = 0;
							velocity.x -= moveSpeed;
							checkMaxVelocity();
						} else if (gamepad.getAxis(l) > 0) {
							if (sprite.flipped) { sprite.flipped = false; }
							facing = 1;
							velocity.x += moveSpeed;
							checkMaxVelocity();
						}
					}

					if (gamepad.pressed(hitone) && deathTimer <= 0 && powerTimer <= 0 && (cast(scene, Level).zenTimer <= 0 || type == "zen" || altType == "zen")) {
						var shots = 0;
						if (scene.typeCount(type + "_shot") != null) {
							shots += scene.typeCount(type + "_shot");
						}

						if (shots < 3) {
							shotSnd.play(0.3);
							scene.add(new Shot(x + sprite.width / 2, y + sprite.height / 2, type, facing, blur));
						}
					}

					if (gamepad.pressed(hittwo) && (cast(scene, Level).zenTimer <= 0 || type == "zen" || altType == "zen")) {
						for (i in 0...Types.types.length) {
							if (type == Types.types[i]) {
								if (Scores.POWER[i] == 3) {
									activatePower();
								}
							}
						}
					}

					if (floatTimer > 0) {
						if (Math.abs(gamepad.getAxis(down)) > Joystick.deadZone + 0.2) {
							if (gamepad.getAxis(down) > 0) {
								if (collide("solid", x, y + 2) == null) { 
									y += 2;
								}
							} else if (gamepad.getAxis(down) < 0) {
								if (collide("solid", x, y - 2) == null) {
									y -= 2;
								}
							}
						}

						if (Math.abs(gamepad.getAxis(l)) > Joystick.deadZone + 0.2) {
							if (gamepad.getAxis(l) > 0) {
								if (sprite.flipped) { sprite.flipped = false; }
								facing = 1;
								if (collide("solid", x + 2, y) == null) {
									x += 2;
								}
							} else if (gamepad.getAxis(l) < 0) {
								if (!sprite.flipped) { sprite.flipped = true; }
								facing = 0;
								if (collide("solid", x - 2, y) == null) { 
									x -= 2; 
								}
							}
						}
					}
				}

				if (type != "gold" && deathTimer <= 0) {
					if ((collide("gold", x, y) != null && cast(collide("gold", x, y), Player).powerTimer > 0) || (collide("mimic", x, y) != null && cast(collide("mimic", x, y), Player).powerTimer > 0 && cast(collide("mimic", x, y), Player).altType == "gold")) {
						stunTimer = 300;
						gold = true;
					}
				}
			}

			var orb = collide("orb", x, y);

			if (orb != null) {
				for (i in 0...Types.types.length) {
					if (type == Types.types[i]) {
						if (Scores.POWER[i] < 3) {
							Scores.POWER[i] += 1;
							scene.remove(orb);
						}
					}
				}
			}

			if (cast(scene, Level).chaosTimer > 0) {
				if (type != "chaos" && altType != "chaos") {
					velocity.x = -velocity.x;
				}
			}

			if (floatTimer <= 0) {
				applyVelocity();
				applyGravity();
			} else {
				if (type == "cloud" || altType == "cloud") {
					Emitters.CLOUDEMITTER.cloud(_x, y + sprite.height);
				}
			}

			checkMaxVelocity();
			applyFriction();
			goneTooFarThisTime();
		}

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
				velocity.x = 0;
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
		if (!dead) {
			if (collide("lava", x, y) != null) {
				for (i in 0...Types.types.length) {
					if (type == Types.types[i]) {
						if (Scores.SCORES[i] > 0) {
							Scores.SCORES[i] -= 1;
						}
					}
				}
				deathSnd.play(0.5);
				gold = false;
				naked = false;
				stunTimer = 0;
				coffeeTimer = 0;
				powerTimer = 0;
				dead = true;
			}

			if (deathTimer <= 0) {
				if (collide("trap", x, y) != null) {
					deathSnd.play();
					gold = false;
					naked = false;
					stunTimer = 0;
					coffeeTimer = 0;
					powerTimer = 0;
					dead = true;
					for (i in 0...Types.types.length) {
						if (type == Types.types[i]) {
							if (Scores.SCORES[i] > 0) {
								Scores.SCORES[i] -= 1;
							}
						}
					}
				}
			}

			if (Scores.MODE == 4) {
				if ((collide("enemy", x, y) != null || collide("enemyshot", x, y) != null) && cast(scene, Level).zenTimer <= 0 && deathTimer <= 0 && powerTimer <= 0) {
					deathSnd.play();
					gold = false;
					naked = false;
					stunTimer = 0;
					coffeeTimer = 0;
					powerTimer = 0;
					dead = true;
				}

				if (deathTimer <= 0 && powerTimer > 0 && (type == "love" || altType == "love")) {
					var _shot = collide("enemyshot", x, y);

					if (_shot != null) {
						cast(_shot, EnemyShot).dir = -cast(_shot, EnemyShot).dir - 90;
					}
				}
			}

			for (i in 0...Types.types.length) {
				if (type != Types.types[i] && deathTimer <= 0 && powerTimer <= 0) {
					var _shot = null;
					if (Scores.MODE < 4) _shot = collide(Types.types[i] + "_shot", x, y);
					var _pow = collide(Types.types[i] + "_pow", x, y);
					var _stun = collide(Types.types[i] + "_stun", x, y);

					if (_stun != null) {
						stunTimer = 150;
					}

					if (_shot != null || _pow != null) {
						if (_shot != null) scene.remove(_shot);

						if (_pow != null) {
							if (_pow.type == "dark_pow") {
								if (altType == "dark") {
									break;
								}
							}
						}

						if (Scores.MODE < 2) {
							Scores.SCORES[i] += 1;
						}

						/*if (Scores.POWER[i] < 3) {
							Scores.POWER[i] += 1;
						}*/
						if (_shot != null) {
							if (_shot.type == "thief_shot") {
								if (type == "mimic") {
									cast(scene.nearestToEntity("thief", this, true), Player).altType = altType;
								} else {
									cast(scene.nearestToEntity("thief", this, true), Player).altType = type;
								}
							}
						}
						trace("not the thief's fault");

						deathSnd.play();
						gold = false;
						naked = false;
						stunTimer = 0;
						coffeeTimer = 0;
						powerTimer = 0;
						dead = true;
						trace("made it to the end of the death part");
					}
				} else if (type != Types.types[i] && deathTimer <= 0 && powerTimer > 0 && (type == "love" || altType == "love")) {
					var _shot = collide(Types.types[i] + "_shot", x, y);

					if (_shot != null) {
						cast(_shot, Shot).sprite.flipped = !cast(_shot, Shot).sprite.flipped;
						cast(_shot, Shot).type = type + "_shot";
					}
				}
			}
		}
		else if (dead) {
			velocity.x = velocity.y = 0;
			goatTimer = 0;

			if (sprite.alpha > 0) { sprite.alpha = 0; }

			if (deathSmoke > 0) {
				Emitters.DEATHEMITTER.death(x + sprite.width / 2, y + sprite.height / 2);
				deathSmoke -= 1;
			}

			if (Scores.MODE < 4) {
				for (i in 0...Types.types.length) {
					if (type == Types.types[i]) { 
						Emitters.TRAILEMITTERS[i].trail(x + 2 + Std.random(8), y + 4 + Std.random(8));
					}
				}


				if (moveTimer <= 0) {
					var xreached = false;
					var yreached = false;

					if (!spawnSet) {
						nearSpawn = findSpawn();
						cast(nearSpawn, SpawnPoint).heading = true;
						trvlSnd.play(0.2);
						spawnSet = true;
					}
					var ang = Math.atan2((nearSpawn.y - y), (nearSpawn.x - x));

					if (Math.abs(nearSpawn.x - x) > Math.abs(3*Math.cos(ang)*1)) {
						x += 3*Math.cos(ang)*1;
					} else {
						x += nearSpawn.x - x;
						xreached = true;
					}
					if (Math.abs(nearSpawn.y - y) > Math.abs(3*Math.sin(ang)*1)) {
						y += 3*Math.sin(ang)*1;
					} else {
						y += nearSpawn.y - y;
						yreached = true;
					}

					if (xreached && yreached) {
						sprite.alpha = 1;
						deathSmoke = 1;
						if (!teleporting) {
							deathTimer = 60;
						}
						moveTimer = 90;
						teleporting = false;
						cast(nearSpawn, SpawnPoint).heading = false;
						spawnSet = false;

						for (i in 0...Types.types.length) {
							if (type == Types.types[i]) {
								//Scores.POWER[i] = 0;
								if (Scores.POWER[i] >= Types.orbLoss) {
									Scores.POWER[i] -= Types.orbLoss;
								} else if (Scores.POWER[i] > 0 && Scores.POWER[i] < Types.orbLoss) {
									Scores.POWER[i] = 0;
								}
							}
						}

						floatTimer = 0;
						dead = false;
					}
				} else {
					moveTimer -= 1;
				}
			} else {
				for (i in 0...Types.types.length) {
					if (type == Types.types[i]) { 
						Emitters.TRAILEMITTERS[i].trail(x + 2 + Std.random(8), y + 4 + Std.random(8));
					}

					if (collide(Types.types[i], x, y) != null && Types.types[i] != type) {
						deathTimer = 60;
						floatTimer = 0;
						dead = false;
					}
				}
			}
		}
	}

	private function findSpawn():Entity {
		var spawn:Entity = null;
		var found = false;
		var wd = HXP.screen.width / 16;
		var ht = HXP.screen.height / 16;
		var n = 0;

		var posArray:Array<Entity> = new Array();

		scene.getType("spawn", posArray);

		for (i in 0...posArray.length) {
			if (cast(posArray[i], SpawnPoint).allClear(type) && !cast(posArray[i], SpawnPoint).heading) {
				spawn = posArray[i];
				found = true;
				break;
			}
		}

		if (!found) {
			var spawnArray:Array<Entity> = new Array();
			scene.getType("spawn", spawnArray);

			spawn = spawnArray[Std.random(spawnArray.length - 1)];
		}

		return spawn;
	}

	private function activatePower() {
		var activated = false;
		var _type = type;

		if (_type == "mimic") {
			HXP.randomizeSeed();
			var rand = Std.random(Types.types.length - 3);
			altType = Types.types[rand];
			_type = altType;
		} else if (_type == "thief") {
			if (altType == "goat") {
				altType = "thief";
			}
			_type = altType;
		}

		trace(_type);

		switch (_type) {
			case "bacon" :
				for (i in 0...3) { var b = scene.add(new BaconStrip(x, y, (i == 0) ? 1 - facing : facing, (i == 2) ? true : false)); b.type = type + "_pow"; } activated = true;
			case "banana" :
				scene.add(new BananaPeel(x, y, facing));
				activated = true;
			case "barnacle" :
				//&& scene.collidePoint("solid", Std.int(x / 16) * 16, y + 16) != null
				//if (onGround) { barnaclePlatform(); activated = true; }
				if (cast(scene, Level).barnacleTimer <= 0) {
					barnacleLevel();
				}
				cast(scene, Level).barnacleTimer = 600;
				activated = true;
			case "blood" :
				for (i in 0...5) { scene.add(new BloodDrop(x, y, i, type)); } activated = true;
			case "buff" :
				if (onGround) { addSmash(facing, type); activated = true; }
			case "chaos" :
				cast(scene, Level).chaosTimer = 600;
				activated = true;
			case "cherry" :
				scene.add(new CherryBomb(x, y, facing, type));
				activated = true;
			case "cloud" :
				velocity.x = 0;
				velocity.y = 0;
				floatTimer = 600;
				activated = true;
			case "coffee" :
				coffeeTimer = 600;
				activated = true;
			case "dark" :
				if (scene.typeCount("dark_pow") == null || scene.typeCount("dark_pow") <= 0) { scene.add(new Blackhole(x + 6, y + 8)); activated = true; }
			case "earth" :
				scene.add(new EarthBoulder(x + 6, y + 4, facing, type));
				activated = true;
			case "egg" :
				scene.add(new EggPower(x, y, facing, type));
				activated = true;
			case "fire" :
				firePillar();
				velocity.x = 0;
				stunTimer = 300;
				activated = true;
			case "flower" :
				if (onGround) { scene.add(new FlowerBase(Std.int(x / 16) * 16, (Std.int(y / 16) * 16) + 10, type)); activated = true; }
			case "fog" :
				cast(scene, Level).fogTimer = 600;
				fogLevel();
				activated = true;
			case "generic" :
				var b = scene.add(new Broom(x, y + 6, facing));
				b.type = type + "_pow";
				activated = true;
			case "goat" :
				var goated = goatSomething();
				if (goated) activated = true;
			case "gold" :
				powerTimer = 300;
				activated = true;
			case "ice" :
				cast(scene, Level).icedTimer = 1200;
				iceLevel();
				activated = true;
			case "invisi" :
				invisiTimer = 300;
				activated = true;
			case "laser" :
				var l = scene.add(new LaserPow(x, 0, facing));
				l.type = type + "_pow";
				activated = true;
			case "lightning" :
				var l = scene.add(new LightningBolt(Std.int(x / 16) * 16, -240, y + 16));
				l.type = type + "_pow";
				activated = true;
			case "love" :
				powerTimer = 600;
				activated = true;
			case "moon" :
				if (onGround) { scene.add(new MoonTurret(Std.int(x / 16) * 16, (Std.int(y / 16) * 16), facing, type)); activated = true; }
			case "mushroom" :
				if (onGround) { var shrooms = 0; if (scene.typeCount("poisonmushroom") != null) { shrooms += scene.typeCount("poisonmushroom"); } if (shrooms < 3) { scene.add(new PoisonMushroom(Std.int(x / 16) * 16, (Std.int(y / 16) * 16) - 12, type)); activated = true; } }
			case "naked" :
				stunTimer = 300;
				naked = true;
				var n = scene.add(new NakedRadius(x + 6, y + 8, type));
				n.type = type + "_stun";
				activated = true;
			case "ocean" :
				raiseOcean();
				activated = true;
			case "peppermint" :
				if (onGround) { peppermintPlatform(facing); activated = true; }
			case "pizza" :
				if (onGround) { scene.add(new Pizza(x, y)); }
				activated = true;
			case "potato" :
				scene.add(new PotatoBomb(Std.int(x / 16) * 16, Std.int(y / 16) * 16, type)); 
				activated = true;
			case "rainbow" :
				scene.add(new RainbowUnicorn(x + 6, y + 8, facing, type)); //y - 4, facing));
				activated = true;
			case "sun" :
				var s = scene.add(new Sun(x, y));
				s.type = type + "_pow";
				activated = true;
			case "zen" :
				cast(scene, Level).zenTimer = 300;
				Emitters.ZENEMITTER.zen(x + 6, y + 8);
				activated = true;
		}

		if (activated) {
			for (i in 0...Types.types.length) {
				if (type == Types.types[i]) {
					Scores.POWER[i] = 0;
				}
			}
		}
	}

	private function iceLevel() {
		for (_x in 0...20) {
			for (_y in 0...15) {
				if (collide("solid", (_x * 16), (_y * 16)) != null) {
					if (collide("solid", (_x * 16), ((_y - 1) * 16)) == null)
						scene.add(new Iced(_x * 16, _y * 16));
				}
			}
		}
	}

	private function addSmash(_d:Int, _t:String) {
		var aX = Std.int(x / 16);

		var d = (_d == 0) ? -1 : 1;
		var i = 1;

		if (collide("solid", (aX + (i * d)) * 16, y) == null && collide("solid", (aX + (i * d)) * 16, y + 16) != null) {
			scene.add(new BuffSmash((aX + (i * d)) * 16, y, facing, _t));
		}
	}
	/*private function barnaclePlatform() {
		var aX = Std.int(x / 16);
		var aY = y + 11;

		for (i in 0...20) {
			if (collide("solid", (aX + i) * 16, y) == null && collide("solid", (aX + i) * 16, y + 16) != null) {
				scene.add(new Barnacled((aX + i) * 16, aY));
			} else {
				break;
			}
		}

		for (i in 0...20) {
			if (collide("solid", (aX - i) * 16, y) == null && collide("solid", (aX - i) * 16, y + 16) != null) {
				scene.add(new Barnacled((aX - i) * 16, aY));
			} else {
				break;
			}
		}
	}*/

	private function barnacleLevel() {
		for (_x in 0...20) {
			for (_y in 0...15) {
				if (collide("solid", (_x * 16), (_y * 16)) != null) {
					if (collide("solid", (_x * 16), ((_y - 1) * 16)) == null)
						scene.add(new Barnacled(_x * 16, ((_y - 1) * 16) + 11));
				}
			}
		}
	}

	private function peppermintPlatform(_d:Int) {
		var aX = Std.int(x / 16);
		var aY = y - 16;

		var d = (_d == 0) ? -1 : 1;

		for (i in 1...4) {
			if (collide("solid", (aX + (i * d)) * 16, y) == null && collide("solid", (aX + (i * d)) * 16, y + 16) != null) {
				var p = scene.add(new PeppermintStick((aX + (i * d)) * 16, aY));
				p.type = type + "_pow";
			}
		}
		/*for (i in 0...20) {
			if (collide("solid", (aX + i) * 16, y) == null && collide("solid", (aX + i) * 16, y + 16) != null) {
				if (Math.random() > 0.7) {
					scene.add(new PeppermintStick((aX + i) * 16, aY));
				}
			} else {
				break;
			}
		}

		for (i in 0...20) {
			if (collide("solid", (aX - i) * 16, y) == null && collide("solid", (aX - i) * 16, y + 16) != null) {
				if (Math.random() > 0.7) {
					scene.add(new PeppermintStick((aX - i) * 16, aY));
				}
			} else {
				break;
			}
		}*/
	}

	private function firePillar() {
		var aX = Std.int((x + 6) / 16);
		var aY = Std.int(y / 16);

		for (i in 0...15) {
			if (collide("solid", aX * 16, (aY - i) * 16) == null && (aY - i) * 16 >= 0) {
				var f = scene.add(new FirePillar(aX * 16, (aY - i) * 16, 0));
				f.type = type + "_pow";
			} else {
				break;
			}
		}

		for (i in 0...20) {
			if (collide("solid", (aX - i) * 16, aY * 16) == null && (aX - i) * 16 >= 0) {
				var f = scene.add(new FirePillar((aX - i) * 16, aY * 16, 2));
				f.type = type + "_pow";
			} else {
				break;
			}
		}

		for (i in 0...20) {
			if (collide("solid", (aX + i) * 16, aY * 16) == null && (aX + i) * 16 <= 320) {
				var f = scene.add(new FirePillar((aX + i) * 16, aY * 16, 1));
				f.type = type + "_pow";
			} else {
				break;
			}
		}
	}

	private function raiseOcean() {
		for (_y in 0...5) {
			for (_x in 0...20) {
				var o = scene.add(new OceanWater(_x * 16, 240 + (_y * 16)));
				o.type = type + "_pow";
			}
		}
	}

	private function fogLevel() {
		for (_y in 0...15) {
			for (_x in 0...20) {
				scene.add(new Fogged(_x * 16, _y * 16));
			}
		}
	}

	private function goatSomething() {
		var num = 0;
		var arr:Array<Entity> = new Array();

		for (i in 0...Types.types.length) {
			if (type != Types.types[i] && scene.typeCount(Types.types[i]) > 0 && distanceFrom(scene.nearestToEntity(Types.types[i], this, true), true) < 16) {
				arr[num] = scene.nearestToEntity(Types.types[i], this, true);
				num++;
			}
		}

		var spawnArr:Array<Entity> = new Array();
		scene.getType("spawn", spawnArr);

		for (i in 0...spawnArr.length) {
			if (distanceFrom(spawnArr[i], true) < 16) {
				arr[num] = spawnArr[i];
				num++;
			}
		}

		var rand = Std.int(randomRange(0, arr.length - 1));

		if (arr[rand] != null) {
			if (arr[rand].type == "spawn") {
				cast(arr[rand], SpawnPoint).goatTimer = 600;
			} else {
				cast(arr[rand], Player).goatTimer = 600;
			}
			return true;
		}

		return false;
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

	private function degreeradian(a:Float) {
		return a * 0.017453292519;
	}
}
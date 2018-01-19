package game;

//import com.haxepunk.blur.BlurredGraphic;
//import com.haxepunk.blur.BlurCanvas;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import flash.geom.Point;
import game.part.Emitters;
import game.part.TrailEmitter;
import game.part.BlurEmitter;
import com.haxepunk.utils.Joystick;

class OldPlayer extends Entity
{
	private var sprite:Spritemap;
	//private var sprite_blur:BlurredGraphic;
	private var up:Int;
	private var down:Int;
	private var l:Int;
	private var r:Int;
	private var hitone:Int;
	private var hittwo:Int;
	private var onGround:Bool;
	private var onWall:Bool;
	private var moveSpeed:Int;
	private var gravity:Point;
	private var maxVel:Point;
	private var facing:Int; //0 = left, 1 = right
	private var velocity:Point;
	private var friction:Point;
	private var dim:Point;
	//private var types:Array<String>;
	public var dead:Bool;
	private var teleporting:Bool;
	//private var blur:BlurCanvas;
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
	//public var TRAIL:TrailEmitter;

	public function new(x:Float, y:Float, _type:String, _up:Int, _down:Int, _left:Int, _right:Int, _hitone:Int, _hittwo:Int, _blur:Int, ?_gamepad:Joystick)
	{
		super(x, y);

		sprite = new Spritemap("gfx/wiz/" + _type + "wiz.png", 12, 16);
		//sprite_blur = new BlurredGraphic(sprite, _blur);
		//blur = _blur;
		//sprite.centerOrigin();
		blur = _blur;
		graphic = sprite;
		layer = 1;
		type = _type;
		facing = 1;

		blurEmitter = new BlurEmitter(_type);

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
		moveSpeed = 1;
		//deathTimer = 60;
		deathSmoke = 1;
		deathTimer = 0;
		moveTimer = 90;
		blurTimer = 10;
		dim = new Point(12, 16);
		gravity = new Point(0, 1.6); //original x = 0, y = 1.8
		maxVel = new Point(2, 12); //original x = 2, y = 12
		velocity = new Point(0, 0);
		friction = new Point(1.2, 0.6); //original x = 1.2, y = 0.6
		//TRAIL = new TrailEmitter(type);
		//types = new Array();
		//types[0] = "earth";
		//types[1] = "fire";
		//types[2] = "ice";
		//types[3] = "psy";
	}

	override public function added() {
		scene.add(blurEmitter);
	}

	override public function update()
	{
		if (deathTimer > 0) {
			sprite.alpha = 0.3;
			deathTimer -= 1;
		} else { sprite.alpha = 1; }

		if (velocity.y > 2) {
			jmpPlyd = false;
		}

		checkDeath();
		//trace(velocity.x);

		if (!dead) {
			if (blurTimer <= 0) {
				blurEmitter.blur(x + 6, y + 8, facing);
				blurTimer = 1;
			} else {
				blurTimer -= 1;
			}

			if (gamepad == null) {
				if (Input.check(l)) {
					if (!sprite.flipped) { sprite.flipped = true; }
					facing = 0;
					velocity.x -= moveSpeed;
					checkMaxVelocity();
					//trace(velocity.x);
				}
				if (Input.check(r)) {
					if (sprite.flipped) { sprite.flipped = false; }
					facing = 1;
					velocity.x += moveSpeed;
					checkMaxVelocity();
					//trace(velocity.x);
				}
				if (Input.check(up)) {
					if (onGround) {
						jmpSnd.play(0.5);
						jmpPlyd = false;
						velocity.y = -maxVel.y;
					}
				}

				if (Input.pressed(hitone) && deathTimer <= 0) {
					var shots = 0;
					if (scene.typeCount(type + "_ground") != null)  {
						shots += scene.typeCount(type + "_ground");
					}
					if (scene.typeCount(type + "_shot") != null) {
						shots += scene.typeCount(type + "_shot");
					}

					if (Input.check(down)) {
						var col = collide("solid", x, y + 1);

						if (col != null) {
							//if (scene.typeCount(type + "_ground") < 3 || scene.typeCount(type + "_ground") == null) {
							if (shots < 3 && col.x >= 0 && col.x < 320) {
								grndSnd.play();
								scene.add(new GroundShot(Math.floor(x / 16) * 16, y + 8, type));
							}
							//trace(type);
						}
					} else {
						//trace(scene.typeCount(type + "_shot"));
						//if (scene.typeCount(type + "_shot") < 3 || scene.typeCount(type + "_shot") == null) {
						if (shots < 3) {
							shotSnd.play(0.3);
							scene.add(new Shot(x + sprite.width / 2, y + sprite.height / 2, type, facing, blur));
						}
					}
				}

				/*if (Input.pressed(hittwo) && deathTimer <= 0) {
					deathSmoke = 0;
					moveTimer = 0;
					teleporting = true;
					dead = true;
				}*/
			}
			else {
				/*if (Math.abs(gamepad.getAxis(up)) > Joystick.deadZone + 0.2) {
					if (gamepad.getAxis(up) < 0) {
						if (onGround) {
							velocity.y = -maxVel.y;
						}
					}
				}*/

				if (gamepad.check(up)) {
					if (onGround) {
						jmpSnd.play(0.5);
						jmpPlyd = false;
						velocity.y = -maxVel.y;
					}
				}

				if (Math.abs(gamepad.getAxis(l)) > Joystick.deadZone + 0.2) {
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

				if (gamepad.pressed(hitone) && deathTimer <= 0) {
					var shots = 0;
					if (scene.typeCount(type + "_ground") != null)  {
						shots += scene.typeCount(type + "_ground");
					}
					if (scene.typeCount(type + "_shot") != null) {
						shots += scene.typeCount(type + "_shot");
					}

					if (Math.abs(gamepad.getAxis(down)) > Joystick.deadZone + 0.2) {
						if (gamepad.getAxis(down) > 0) {
							var col = collide("solid", x, y + 1);

							if (col != null) {
								//if (scene.typeCount(type + "_ground") < 3 || scene.typeCount(type + "_ground") == null) {
								if (shots < 3 && col.x >= 0 && col.x < 320) {
									grndSnd.play();
									scene.add(new GroundShot(Math.floor(x / 16) * 16, y + 8, type));
								}
							}
						} else {
							//if (scene.typeCount(type + "_shot") < 3 || scene.typeCount(type + "_shot") == null) {
							if (shots < 3) {
								shotSnd.play(0.3);
								scene.add(new Shot(x + sprite.width / 2, y + sprite.height / 2, type, facing, blur));
							}
						}
					} else {
						//if (scene.typeCount(type + "_shot") < 3 || scene.typeCount(type + "_shot") == null) {
						if (shots < 3) {
							shotSnd.play(0.3);
							scene.add(new Shot(x + sprite.width / 2, y + sprite.height / 2, type, facing, blur));
						}
					}
				}

				/*if (gamepad.pressed(hittwo) && deathTimer <= 0) {
					deathSmoke = 0;
					moveTimer = 0;
					teleporting = true;
					dead = true;
				}*/
			}

			applyVelocity();
			applyGravity();
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
			/*var col, col2;

			if (velocity.x > 0) {
				col = collide("solid", x + 12 + HXP.sign(velocity.x), y + 11);
				col2 = collide("solid", x + 12 + HXP.sign(velocity.x), y + 1);
			} else {
				col = collide("solid", x + HXP.sign(velocity.x), y + 11);
				col2 = collide("solid", x + HXP.sign(velocity.x), y + 1);
			}

			if (col != null || col2 != null)*/
			if (collide("solid", x + HXP.sign(velocity.x), y) != null) {
				onWall = true;
				velocity.x = 0;
			}

			else {
				x += HXP.sign(velocity.x);
			}

			/*var col = null;

			if (velocity.x > 0) {
				for (i in 0...Std.int(dim.y) + 1) {
					col = collide("solid", x + 12 + HXP.sign(velocity.x), y + i);

					if (col != null) {
						break;
					}
				}
				if (col != null) {
					onWall = true;
					velocity.x = 0;
				}

				else {
					x += HXP.sign(velocity.x);
				}
			} else {
				for (i in 0...Std.int(dim.y) + 1) {
					col = collide("solid", x+ HXP.sign(velocity.x), y + i);

					if (col != null) {
						break;
					}
				}
				if (col != null) {
					onWall = true;
					velocity.x = 0;
				}

				else {
					x += HXP.sign(velocity.x);
				}
			}*/
		}

		for(i in 0...Std.int(Math.abs(velocity.y) + 1)) {
			/*var col, col2;

			if (velocity.y > 0) {
				col = collide("solid", x, y + 16 + HXP.sign(velocity.y));
				col2 = collide("solid", x + 12, y + 16 + HXP.sign(velocity.y));
			} else {
				col = collide("solid", x, y + HXP.sign(velocity.y));
				col2 = collide("solid", x + 12, y + HXP.sign(velocity.y));
			}

			if(col != null || col2 != null) {*/
			if (collide("solid", x, y + HXP.sign(velocity.y)) != null) {
				if (HXP.sign(velocity.y) == HXP.sign(gravity.y)) {
					if (!jmpPlyd) {
						lndSnd.play(0.5);
						jmpPlyd = true;
					}
					onGround = true;
				}
				velocity.y = 0;
			}
			else {
				y += HXP.sign(velocity.y);
			}

			/*var col = null;

			if (velocity.y > 0) {
				for (i in 0...Std.int(dim.x) + 1) {
					col = collide("solid", x + i, y + 16 + HXP.sign(velocity.y));

					if (col != null) {
						break;
					}
				}

				if(col != null) {
					if (HXP.sign(velocity.y) == HXP.sign(gravity.y)) {
						onGround = true;
					}
					velocity.y = 0;
				}
				else {
					y += HXP.sign(velocity.y);
				}
			} else {
				for (i in 0...Std.int(dim.x) + 1) {
					col = collide("solid", x + i, y + HXP.sign(velocity.y));

					if (col != null) {
						break;
					}
				}

				if(col != null) {
					if (HXP.sign(velocity.y) == HXP.sign(gravity.y)) {
						onGround = true;
					}
					velocity.y = 0;
				}
				else {
					y += HXP.sign(velocity.y);
				}
			}*/
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
				dead = true;
			}

			if (deathTimer <= 0) {
				if (collide("trap", x, y) != null) {
					deathSnd.play();
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

			for (i in 0...Types.types.length) {
				if (type != Types.types[i] && deathTimer <= 0) {
					var _shot = collide(Types.types[i] + "_shot", x, y);
					var _ground = collide(Types.types[i] + "_ground", x, y);

					if (_shot != null) { //|| _ground != null) {
						if (_shot != null) {
							scene.remove(_shot);
						} /*else if (_ground != null) {
							scene.remove(_ground);
						}*/

						if (Scores.MODE < 2) {
							Scores.SCORES[i] += 1;
							trace("Scores.SCORES[" + i + "], aka " + Types.types[i] + " = " + Scores.SCORES[i]);
						}
						deathSnd.play();
						dead = true;
					}
				}
			}
		}
		else if (dead) {
			/*velocity.x = velocity.y = 0;

			if (deathTimer > 0) {
				if (sprite.alpha > 0) { sprite.alpha -= 0.05; }
				if (deathTimer > 40) { Emitters.DEATHEMITTER.death(x + sprite.width / 2, y + sprite.height / 2); }
				deathTimer -= 1;
			} else {
				var nearSpawn = scene.nearestToEntity("spawn", this, true);

				x = nearSpawn.x;
				y = nearSpawn.y;
				sprite.alpha = 1;
				dead = false;
				deathTimer = 60;
			}*/

			velocity.x = velocity.y = 0;

			if (sprite.alpha > 0) { sprite.alpha = 0; }

			if (deathSmoke > 0) {
				Emitters.DEATHEMITTER.death(x + sprite.width / 2, y + sprite.height / 2); //deathTimer -= 1;
				deathSmoke -= 1;
			}

			for (i in 0...Types.types.length) {
				if (type == Types.types[i]) { 
					Emitters.TRAILEMITTERS[i].trail(x + 2 + Std.random(8), y + 4 + Std.random(8));
					//trace("emitted something");
				}
			}


			if (moveTimer <= 0) {
				var xreached = false;
				var yreached = false;

				//var nearSpawn = scene.nearestToEntity("spawn", this, true);
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
					dead = false;
				}
			} else {
				moveTimer -= 1;
			}
		}
	}

	private function findSpawn():Entity {
		var spawn:Entity = null;
		var found = false;
		var wd = HXP.screen.width / 16;
		var ht = HXP.screen.height / 16;
		var n = 0;

		//var posArray:Array<Array<Int>> = new Array();
		var posArray:Array<Entity> = new Array();

		/*for (i in 0...Std.int(ht)) {
			posArray[i] = new Array();

			for (j in 0...Std.int(wd)) {
				posArray[i][j] = 0;

				if (collide("spawn", (j * 16) + 8, (i * 16) + 8) != null) {
					posArray[i][j] = 1;
					//trace(posArray[i][j]);
				}

				if (collide("solid", (j * 16) + 8, (i * 16) + 8) != null) {
					posArray[i][j] = 3;
					//trace(posArray[i][j]);
				}

				for (k in 0...types.length) {
					if (types[k] != type) {
						if (collide(types[k], (j * 16), (i * 16)) != null || collide(types[k], (j * 16) + 8, (i * 16) + 8) != null) {
							posArray[i][j] = 2;
						}
					}
				}
			}
		}

		for (i in 0...Std.int(ht)) {
			var p = 0;

			for (j in 0...Std.int(wd)) {
				if (posArray[i][j] == 1) {
					p += 1;
					trace(p);
				} else if (posArray[i][j] == 2) {
					p = -30;
				}
			}

			trace(p);

			if (p > 0) {
				for (j in 0...Std.int(wd)) {
					if (collide("spawn", (j * 16) + 8, (i * 16) + 8) != null) {
						trace("spawn found at x=" + (j * 16 + 8) + " y=" + (i * 16 + 8));
						if (!cast(collide("spawn", (j * 16) + 8, (i * 16) + 8), SpawnPoint).heading) {
							spawn = collide("spawn", (j * 16) + 8, (i * 16) + 8);
							found = true;
							break;
						}
					}
				}
			}

			if (found) {
				break;
			}
		}*/

		/*for (i in 0...Std.int(ht)) {
			for (j in 0...Std.int(wd)) {
				if (collide("spawn", (j * 16) + 8, (i * 16) + 8) != null) {
					posArray[n] = collide("spawn", (j * 16) + 8, (i * 16) + 8);
					n++;
					//trace(posArray[i][j]);
				}
			}
		}*/

		scene.getType("spawn", posArray);

		for (i in 0...posArray.length) {
			trace("spawn at " + posArray[i].x + " " + posArray[i].y);
			if (cast(posArray[i], SpawnPoint).allClear(type) && !cast(posArray[i], SpawnPoint).heading) {
				spawn = posArray[i];
				found = true;
				break;
			}
		}

		if (!found) {
			var spawnArray:Array<Entity> = new Array();
			scene.getType("spawn", spawnArray);
			trace("random");

			spawn = spawnArray[Std.random(spawnArray.length - 1)];
		}

		return spawn;
	}

	private function goneTooFarThisTime() {
		if (x <= -12) {
			x = 320;
			//y -= 1;
		}
		else if (x >= 320) {
			x = -12;
			//y -= 1;
		}

		if (y <= -12) {
			y = 240;
		}
		else if (y >= 240) {
			y = -12;
		}
	}
}
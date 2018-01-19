package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import flash.geom.Point;
import game.part.Emitters;
import game.powers.GoatTongue;

class SpawnPoint extends Entity
{
	public var sprite:Spritemap;
	private var emitTimer:Int;
	public var heading:Bool;
	public var goatTimer:Int;
	private var goatArr:Array<GoatTongue>;
	private var gravity:Point;
	private var normalGravity:Point;
	public var velocity:Point;
	private var friction:Point;
	private var onGround:Bool;
	private var onWall:Bool;
	private var dust:Bool;
	//private var types:Array<String>;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/spawn.png", 16, 16);

		emitTimer = 5 + Std.random(5);

		goatArr = new Array();
		goatTimer = 0;

		//sprite.centerOrigin();
		heading = false;
		graphic = sprite;
		layer = 9;
		type = "spawn";

		/*types = new Array();
		types[0] = "earth";
		types[1] = "fire";
		types[2] = "ice";
		types[3] = "psy";*/

		gravity = new Point(0, 0.97);
		normalGravity = new Point(0, 0.97);
		velocity = new Point(0, 0);
		friction = new Point(1.2, 0.6);
		onGround = false;
		onWall = false;
		dust = false;

		setHitbox(16, 16);
	}

	override public function update()
	{
		if (goatTimer > 0) {
			var goat = scene.nearestToPoint("goat", x, y, true);

			if (cast(goat, Player).dead) {
				goatTimer = 0;
			}

			var dir = -Math.atan2((goat.y) - y, (goat.x) - x) - (180 * 0.017453292519);
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
				var newx = x - 1*Math.cos(dir)*1;
				var newy = y + 1*Math.sin(dir)*1;
				gravity = new Point(newx - x, newy - y);
			}
			
			goatTimer -= 1;
		} else {
			if (goatArr[0] != null) {
				for (i in 0...goatArr.length) {
					scene.remove(goatArr[i]);
					goatArr[i] = null;
				}
			}
			gravity = normalGravity;
		}

		applyGravity();
		applyFriction();
		applyVelocity();
		goneTooFarThisTime();

		if (emitTimer <= 0) {
			Emitters.SPAWNEMITTER.flame(x + 8 + Std.int(randomRange(-2, 1)), y + 8);
			emitTimer = 5 + Std.random(5);
		} else { emitTimer -= 1; }
		Emitters.SPAWNEMITTER.spawn(x + 8, y + 8);
		super.update();
	}

	private function randomRange(min:Int, max:Int) {
		return min + (Math.random() * ((max - min) + 1));
	}

	public function allClear(_type:String):Bool {
		var distl = -1; 
		var distr = -1;
		var lclear = true;
		var rclear = true;

		for (i in 0...HXP.screen.width + 10) {
			if (distl == -1 || distr == -1) {
				if (collide("solid", x - i, y) != null) {
					//trace("solid at " + (x - i) + " " + y);
					distl = i;
					//trace("spawn point at " + x + " " + y + "set distl to" + distl);
				}

				if (x - i < 0) {
					distl = i;
				}

				if (collide("solid", x + i, y) != null) {
					//trace("solid at " + (x + i) + " " + y);
					distr = i;
					//trace("spawn point at " + x + " " + y + "set distr to" + distr);
				}

				if (x + i > 320) {
					distr = i;
				}
			}

			/*if (distr == -1) {
				if (collide("solid", x + i, y) != null) {
					trace("solid at " + (x + i) + " " + y);
					distr = i;
					trace("spawn point at " + x + " " + y + "set distr to" + distr);
				}

				if (x + i > 320) {
					distr = i;
					trace("spawn point at " + x + " " + y + " right side hit boundary");
				}
			}*/

			if (distl > -1 && distr > -1) {
				//trace("distl " + distl + " and distr " + distr + " found");
				break;
			}
		}

		for (j in 0...distl) {
			for (k in 0...Types.types.length) {
				if (collide(Types.types[k], x - j, y) != null) {
					if (Types.types[k] != _type) {
						//trace("left not clear");
						lclear = false;
						break;
					}
				}
			}
		}

		for (l in 0...distr) {
			for (k in 0...Types.types.length) {
				if (collide(Types.types[k], x + l, y) != null) {
					if (Types.types[k] != _type) {
						//trace("right not clear");
						rclear = false;
						break;
					}
				}
			}
		}

		var ret = false;

		if (distl != -1 && distr != -1) {
			if (lclear && rclear) {
				//trace("all clear!");
				ret = true;
			}
		}

		trace(ret);

		if (!lclear || !rclear) {
			ret = false;
		}

		return ret;
	}

	private function applyGravity() {
		velocity.x += gravity.x;
		velocity.y += gravity.y;
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
					onGround = true;
				}
				if (!dust) {
					if (HXP.sign(velocity.y) > 0) { 
						Emitters.DUSTEMITTER.up(x + 1, y);
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

	private function degreeradian(a:Float) {
		return a * 0.017453292519;
	}
}
package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import game.part.Emitters;
import flash.geom.Point;

class Puffer extends Entity
{
	private var sprite:Spritemap;
	private var dir:Float;
	private var activated:Bool;
	private var timer:Int;
	private var velocity:Float;
	private var maxVel:Float;
	private var friction:Float;
	private var dirs:Array<Int>;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/puffer.png", 14, 12);

		dirs = new Array();
		dirs[0] = 45;
		dirs[1] = 135;
		dirs[2] = 225;
		dirs[3] = 315;

		dir = dirs[Std.random(4)];

		timer = 60;
		velocity = 0;
		maxVel = 6;
		friction = 0.5;
		setHitbox(14, 12);
		graphic = sprite;
		layer = 4;

		type = "trap";
	}

	override public function update()
	{
		var newang:Float = degreeradian(dir) - degreeradian(90);

		//x = x - velocity*Math.cos(newang)*1;
		//y = y + velocity*Math.sin(newang)*1;

		if (timer <= 0) {
			velocity = maxVel;
			dir = dirs[Std.random(4)];
			timer = 60;
		} else { timer -= 1; }

		/*if (collide("solid", x, y) != null) {
			if (dir == 45 || dir == 315) {
				dir = modulozero(dir - 90, 360);
			} else if (dir == 135 || dir == 225) {
				dir = modulo(dir + 90, 360);
			}
		}*/

		if (dir == 225 || dir == 315) { 
			sprite.flipped = false; 
		} else {
			sprite.flipped = true;
		}

		/*if (collide("solid", x, y) != null) {
			trace("colliding");
		}*/

		for (i in 0...Std.int(Math.abs(velocity) + 1)) {
			if (velocity > 0) {

				if (collide("solid", x, y + HXP.sign(velocity*Math.sin(newang)*1)) != null && collide("solid", x + HXP.sign(velocity*Math.cos(newang)*1), y) != null)
				{
					dir = modulozero(dir - 180, 360);
					velocity = 0;
				}

				if (collide("solid", x, y + HXP.sign(velocity*Math.sin(newang)*1)) != null) {
					if (dir == 45 || dir == 225) {
						dir = modulo(dir + 90, 360);
					}
					else if (dir == 135 || dir == 315) {
						dir = modulozero(dir - 90, 360);
					} 
					//trace(dir);
				} else {
					y = y + 1*Math.sin(newang)*1;
				}

				if (collide("solid", x - HXP.sign(velocity*Math.cos(newang)*1), y) != null) {
					if (dir == 45 || dir == 225) {
						dir = modulozero(dir - 90, 360);
					} 
					else if (dir == 135 || dir == 315) {
						dir = modulo(dir + 90, 360);
					}
					//trace(dir);
				} else {
					x = x - 1*Math.cos(newang)*1;
				}
			}
		}

		for (i in 0...Types.types.length) {
			if (collide(Types.types[i], x, y) != null) {
				if (!cast(collide(Types.types[i], x, y), Player).dead) {
					Emitters.PUFFEREMITTER.emit(x + 9, y + 8);
					scene.remove(this);
				}
			}
		}

		if (x < 0 || y < 0 || x > 320 || y > 240) {
			scene.remove(this);
		}

		applyFriction();
		super.update();
	}

	private function applyFriction() 
	{
		if (velocity > 0) {
			velocity -= friction;

			if (velocity < 0) {
				velocity = 0;
			}
		}

		else if (velocity < 0) {
			velocity += friction;

			if (velocity > 0) {
				velocity = 0;
			}
		}
	}

	private function degreeradian(a:Float)
	{
		return a * 0.017453292519;
	}

	private function modulo(n : Float, d : Float)
	{
	    var r = n;
	    if(r > d) r-=d;
	    return r;
	}

	private function modulozero(n : Float, d : Float)
	{
	    var r = n;
	    if(r < 0) r+=d;
	    return r;
	}
}
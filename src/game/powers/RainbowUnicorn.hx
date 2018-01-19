package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.masks.Circle;
import game.Scores;

class RainbowUnicorn extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;
	private var rainbow:UnicornRainbow;
	private var dir:Float;
	private var facing:Int;
	private var t:String;

	public function new(x:Float, y:Float, _facing:Int, _t:String)
	{
		/*var x = 0;

		if (_facing == 0) {
			x = 320;
		} else if (_facing == 1) {
			x = -32;
		}*/

		facing = _facing;
		t = _t;

		super(x, y);

		timer = 300;

		//dir = _facing;

		sprite = new Spritemap("gfx/powers/unicorn.png", 32, 12);
		sprite.setFrame(Std.random(5), 0);
		//sprite.centerOrigin();
		//sprite.flipped = (_facing == 0) ? false : true;
		
		setHitbox(32, 12);
		type = t + "_pow";

		graphic = sprite;
		layer = 2;
	}

	override public function added() {
		rainbow = new UnicornRainbow(x, y, facing);
		scene.add(rainbow);

		var nearest:Entity = null;
		var wizards:Array<Entity> = new Array();

		var num = 0;

		if (Scores.MODE != 4) {
			for (i in 0...Types.types.length) {
				if (scene.typeCount(Types.types[i]) > 0 && Types.types[i] != t) { //"rainbow") {
					var arr:Array<Entity> = new Array();

					scene.getType(Types.types[i], arr);

					for (j in 0...arr.length) {
						wizards[num] = arr[j];
						num++;
					}
				}
			}
		} else if (Scores.MODE == 4) {
			if (scene.typeCount("enemy") > 0) {
				var arr:Array<Entity> = new Array();

				scene.getType("enemy", arr);

				for (j in 0...arr.length) {
					wizards[num] = arr[j];
					num++;
					trace(num);
				}
			}
		}

		if (wizards != null && wizards.length > 0) {
			for (i in 0...wizards.length) {
				if (i == 0) {
					nearest = wizards[i];
				} else {
					if (distance(wizards[i].x, x, wizards[i].y, y) < distance(nearest.x, x, nearest.y, y)) {
						nearest = wizards[i];
					}
				}
			}

			dir = -Math.atan2((nearest.y + 8) - y, (nearest.x + 6) - x) - (180 * 0.017453292519);
		} else {
			scene.remove(rainbow);
			scene.remove(this);
		}
	}

	override public function update()
	{
		x = x - 8*Math.cos(dir)*1;
		y = y + 8*Math.sin(dir)*1;

		var newang = -dir * (180/Math.PI);
		sprite.flipped = (newang < 90 || newang > 270) ? false : true;

		if (newang < 90 || newang > 270) { //(dir == 0) {
			//x -= 10;
			rainbow.x = x + 25;
			rainbow.y = y + 4;
		} else { //if (dir == 1) {
			//x += 10;
			rainbow.x = x - 25;
			rainbow.y = y + 4;
		}

		if (x > 340 || x < -40 || y < -40 || y > 340) {
			scene.remove(rainbow);
			scene.remove(this);
		}

		super.update();
	}

	private function distance(_x1:Float, _x2:Float, _y1:Float, _y2:Float) 
	{
		return Math.sqrt(Math.pow(_x2 - _x1, 2) + Math.pow(_y2 - _y1, 2));
	}
}
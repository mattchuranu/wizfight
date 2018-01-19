package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;
import game.Scores;
import flash.geom.Point;

class BloodDrop extends Entity
{
	public var sprite:Spritemap;
	private var dir:Int;
	private var moveTimer:Int;
	private var center:Point;
	private var nearest:Entity;
	private var angleSet:Bool;
	private var ang:Float;
	private var t:String;

	public function new(x:Float, y:Float, i:Int, _t:String)
	{
		super(x, y);

		dir = Std.random(360);
		//dir = HXP.rand(360);
		//HXP.randomizeSeed();
		moveTimer = (i + 1) * 60;
		center = new Point(x + 6, y + 8);
		angleSet = false;
		t = _t;

		sprite = new Spritemap("gfx/powers/blooddrop.png", 8, 8);
		graphic = sprite;
		sprite.centerOrigin();
		setHitbox(8, 8, 4, 4);
		type = t + "_pow";
		layer = 3;
	}

	override public function update()
	{
		var newang = dir * 0.017453292519;
		var rightang = newang - (90 * 0.017453292519);

		if (moveTimer <= 0) {
			if (!angleSet) {
				var wizards:Array<Entity> = new Array();

				var num = 0;

				if (Scores.MODE != 4) {
					for (i in 0...Types.types.length) {
						if (scene.typeCount(Types.types[i]) > 0 && Types.types[i] != t) { //"blood") {
							var arr:Array<Entity> = new Array();

							scene.getType(Types.types[i], arr);

							for (j in 0...arr.length) {
								wizards[num] = arr[j];
								num++;
								trace(num);
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

				for (i in 0...wizards.length) {
					if (i == 0) {
						nearest = wizards[i];
					} else {
						if (distance(wizards[i].x, x, wizards[i].y, y) < distance(nearest.x, x, nearest.y, y)) {
							nearest = wizards[i];
						}
					}
					trace(nearest.x);
				}
				if (nearest != null) {
					ang = Math.atan2(nearest.y - y, nearest.x - x); 
				} else {
					ang = Std.random(360);
				}
				angleSet = true;
			}

			var ang2 = -ang - degreeradian(180);

			x = x - 4*Math.cos(ang2)*1;
			y = y + 4*Math.sin(ang2)*1;
		} else {
			x = center.x - 4*Math.cos(newang)*1;
			y = center.y + 4*Math.sin(newang)*1;
			moveTimer -= 1;
			dir += 4;
		}

		if (x < -8 || x > 328 || y < -8 || y > 248) {
			scene.remove(this);
		}
		super.update();
	}

	private function degreeradian(a:Float)
	{
		return a * 0.017453292519;
	}

	private function distance(_x1:Float, _x2:Float, _y1:Float, _y2:Float) 
	{
		return Math.sqrt(Math.pow(_x2 - _x1, 2) + Math.pow(_y2 - _y1, 2));
	}
}
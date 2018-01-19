package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import game.part.Emitters;
import flash.geom.Point;

class RandomTrap extends Entity
{
	private var sprite:Spritemap;
	private var spawnpt:Point;
	private var trapType:String;
	private var dir:Int;
	private var min:Int;
	private var max:Int;
	private var delay:Point;
	private var timer:Float;
	public var spawned:Dynamic;
	private var activated:Bool;
	private var created:Bool;
	private var posArr:Array<Array<Int>>;

	public function new(_type:String, _min:Int, _max:Int)
	{
		super(0, 0);

		min = _min;
		max = _max;
		trapType = _type;
		timer = randomRange(min, max);
		graphic = sprite;
		layer = 9;

		posArr = new Array();
	}

	override public function added() {
		var wd = HXP.screen.width / 16;
		var ht = HXP.screen.height / 16;

		for (i in 0...Std.int(ht)) {
			posArr[i] = new Array();
			for (j in 0...Std.int(wd)) {
				if (collide("solid", (j * 16) + 8, (i * 16) + 8) != null) {
					posArr[i][j] = -10;
				} else {
					posArr[i][j] = j;
				}

				/*if (posArr[i] > 0) {
					trace(posArr[i] + ", " + i);
				}*/
			}
		}
	}

	override public function update()
	{
		if (timer <= 0) {
			var i = -10;
			var rand = -1;
			var rand2 = -1;

			while (i < 0) {
				rand = Std.random(posArr.length - 1);
				rand2 = Std.random(posArr.length - 1);

				i = posArr[rand][rand2];
			}

			if (trapType == "puffer") {
				scene.add(new Puffer(i * 16 + 1, rand * 16 + 1));
			}
			timer = randomRange(min, max);
		} else {
			timer -= 1;
		}

		super.update();
	}

	private function randomRange(min:Int, max:Int) {
		return min + (Math.random() * ((max - min) + 1));
	}
}
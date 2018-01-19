package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;
import game.Types;
import game.Scores;

class AttackFlower extends Entity
{
	public var sprite:Spritemap;
	private var spawner:FlowerBase;
	private var chain:Array<FlowerChain>;
	private var t:String;

	public function new(x:Float, y:Float, _spawner:FlowerBase, _t)
	{
		super(x, y);

		spawner = _spawner;
		t = _t;

		sprite = new Spritemap("gfx/powers/flower.png", 14, 16);
		sprite.add("chomp", [0, 1], 1, true);
		sprite.centerOrigin();
		graphic = sprite;
		setHitbox(14, 16, 7, 8);
		type = t + "_pow";
		layer = 0;
	}

	override public function added()
	{
		chain = new Array();
		for (i in 0...10) {
			chain[i] = new FlowerChain(x, y);
			scene.add(chain[i]);
		}
	}

	override public function update()
	{
		sprite.play("chomp");

		var nearest:Entity = null;
		var wizards:Array<Entity> = new Array();

		var num = 0;
		if (Scores.MODE != 4) {
			for (i in 0...Types.types.length) {
				if (scene.typeCount(Types.types[i]) > 0 && Types.types[i] != t) { //"flower") {
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

			var ang = Math.atan2(nearest.y - y, nearest.x - x); // - degreeradian(180);
			var rightang = -ang - degreeradian(180);
			var newang = ang * (180 / Math.PI);

			if (distance(spawner.x + (spawner.sprite.width / 2), x - 2*Math.cos(rightang)*1, spawner.y + (spawner.sprite.height / 2), y + 2*Math.sin(rightang)*1) < 24) {
				x = x - 2*Math.cos(rightang)*1;
				y = y + 2*Math.sin(rightang)*1;
			}

			if (-newang < 90 && -newang > -90) {
				sprite.flipped = false;
				sprite.angle = -newang;
			} else {
				sprite.flipped = true;
				sprite.angle = -newang - 180;
			}

			var spawndist = Math.sqrt(Math.pow(x - (spawner.x + 8), 2) + Math.pow(y - (spawner.y), 2));
			var spawnang = -Math.atan2((spawner.y) - y, (spawner.x + 8) - x) - degreeradian(180);

			for (i in 0...10) {
				chain[i].x = (spawner.x + 8) + Math.cos(spawnang) * (spawndist * ((i + 1) / 10));
				chain[i].y = (spawner.y) - Math.sin(spawnang) * (spawndist * ((i + 1) / 10));
			}
		}

		super.update();
	}

	override public function removed() {
		for (i in 0...chain.length) {
			scene.remove(chain[i]);
		}
		Emitters.SHAKEEMITTER.rmvd(x, y);
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
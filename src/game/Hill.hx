package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import game.part.Emitters;

class Hill extends Entity
{
	private var sprite:Spritemap;
	private var controlTimer:Int;
	private var scoreTimer:Int;
	private var controlStr:String;
	private var control:Int;
	private var types:Array<String>;
	private var typesGlobal:Array<String>;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/hill.png", 16, 10);
		sprite.setFrame(10, 0);

		//sprite.centerOrigin();
		graphic = sprite;
		layer = 3;
		type = "hill";

		controlTimer = 10;
		scoreTimer = 120;
		control = 10;
		controlStr = "neutral";

		types = new Array();
		types[0] = "neutral";
		
		for (i in 1...Types.types.length + 1) {
			types[i] = Types.types[i - 1];
		}

		/*typesGlobal = new Array();
		typesGlobal[0] = "earth";
		typesGlobal[1] = "fire";
		typesGlobal[2] = "ice";
		typesGlobal[3] = "psy";*/

		setHitbox(16, 16);
	}

	override public function update()
	{
		if (controlTimer <= 0) {
			for (i in 0...types.length) {
				if (collide(types[i], x, y) != null) {
					if (!cast(collide(types[i], x, y), Player).dead) {
						if (controlStr != types[i]) {
							if (control > 0) {
								control -= 1;
								controlTimer = 10;
							} 
							else if (control == 0) {
								controlStr = types[i];
							}
						}
						else if (controlStr == types[i]) {
							if (control < 10) {
								control += 1;
								controlTimer = 10;
							}
						}
					}
				}
			}
		} else {
			var c = 0;

			for (i in 0...types.length) {
				if (collide(types[i], x, y) != null) {
					if (!cast(collide(types[i], x, y), Player).dead) {
						c++;
					}
				}
			}

			if (c > 0) {
				controlTimer -= 1;
			} else {
				controlTimer = 10;
			}
		}

		if (control > 7) {
			if (scoreTimer <= 0) {
				for (i in 0...Types.types.length) {
					if (controlStr == Types.types[i]) {
						Scores.SCORES[i] += 1;
						//trace("Scores.SCORES[" + i + "], aka " + typesGlobal[i] + " = " + Scores.SCORES[i]);
						scoreTimer = 120;
					}
				}
			} else {
				scoreTimer -= 1;
			}
		} else {
			scoreTimer = 120;
		}

		for (i in 0...types.length) {
			if (types[i] == controlStr) {
				sprite.setFrame(control, i);
			}
		}

		super.update();
	}
}
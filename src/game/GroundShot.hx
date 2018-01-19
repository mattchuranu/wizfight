package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import game.Types;
import game.part.Emitters;

class GroundShot extends Entity
{
	private var sprite:Spritemap;
	public var hidden:Bool;
	private var t:String;
	//private var types:Array<String>;
	private var timer:Int;
	private var partTimer:Int;
	public var str:String;
	private var shakeTimer:Int;
	private var explode:Sfx;

	public function new(x:Float, y:Float, _type:String)
	{
		super(x, y);
		//trace("added at " + x + " " + y);
		sprite = new Spritemap("gfx/ground/" + _type + "wizground.png", 16, 8);
		sprite.add("hidden", [0], 1, true);
		sprite.add("active", [1], 1, true);
		graphic = sprite;
		layer = -10;
		type = _type + "_ground";
		t = _type;
		hidden = true;
		timer = 600;
		partTimer = 5 + Std.random(10);
		shakeTimer = 20;
		explode = new Sfx("snd/explode.wav");

		/*types = new Array();
		types[0] = "earth";
		types[1] = "fire";
		types[2] = "ice";
		types[3] = "psy";*/

		setHitbox(16, 8);
		sprite.play("hidden");
		str = "hi";
	}

	override public function update()
	{

		if (collide("solid", x, y + 1) == null) {
			scene.remove(this);
		}

		if (timer == 600) {
			if (collide(type, x, y) != null) {
				scene.remove(this);
			}
		}

		if (collide("spawn", x, y) != null) {
			scene.remove(this);
		}

		if (timer <= 0) {
			if (sprite.alpha <= 0) {
				scene.remove(this);
			} else {
				sprite.alpha -= 0.05;
			}
		} else {
			timer -= 1;
		}

		if (partTimer <= 0) {
			for (i in 0...Types.types.length) {
				if (t == Types.types[i]) { 
					Emitters.GROUNDEMITTERS[i].ground(x + Std.random(16), y + sprite.height, t);
				}
			}
			partTimer = 5 + Std.random(10);
		} else {
			partTimer -= 1;
		}
		
		if (hidden) {
			for (i in 0...Types.types.length) {
				if (t != Types.types[i]) { 
					if (collide(Types.types[i], x, y) != null) {
						var col = cast(collide(Types.types[i], x, y), Player);
						if (!col.dead) {
							sprite.play("active");
							col.dead = true;
							for (j in 0...Types.types.length) {
								if (t == Types.types[j]) {
									Emitters.GROUNDEMITTERS[j].explode(x + 8, y + 4);
									Emitters.SHAKEEMITTER.shake();
									if (Scores.MODE < 2) {
										Scores.SCORES[j] += 1;
										trace("Scores.SCORES[" + j + "], aka " + Types.types[j] + " = " + Scores.SCORES[j]);
									}
								}
							}
							explode.play(0.5);
							hidden = false;
						}
					}
				}
			}
		} else if (!hidden) {
			/*sprite.play("active");
			if (timer <= 0) {
				scene.remove(this);
			}
			else {
				for (i in 0...types.length) {
					if (t!= types[i]) {
						var col = collide(types[i], x, y);
						if (col != null) {
							//scene.remove(col);
						}
					}
				}
				sprite.alpha -= 0.05;
				timer -= 1;
			}*/
			//scene.remove(this);
			if (shakeTimer <= 0) {
				if (!HXP.fullscreen) {
					HXP.camera.x = -20;
					HXP.camera.y = 0;
				} else {
					HXP.camera.x = -20 + Types._xPos;
					HXP.camera.y = Types._yPos;
				}
				scene.remove(this);
			} else {
				if (!HXP.fullscreen) {
					HXP.camera.x = Std.int(randomRange(Std.int(-shakeTimer/2 - 20), Std.int(shakeTimer/2 - 20)));
					HXP.camera.y = Std.int(randomRange(Std.int(-shakeTimer/2), Std.int(shakeTimer/2)));
				} else {
					HXP.camera.x = Std.int(randomRange(Std.int(-shakeTimer/2 - 20 + Types._xPos), Std.int(shakeTimer/2 - 20 + Types._xPos)));
					HXP.camera.y = Std.int(randomRange(Std.int(-shakeTimer/2 + Types._yPos), Std.int(shakeTimer/2 + Types._yPos)));
				}
				trace(HXP.camera);
				if (sprite.alpha > 0) {
					sprite.alpha -= 0.1;
				}
				shakeTimer -= 1;
			}
		}

		super.update();
	}

	private function randomRange(min:Int, max:Int) {
		return min + (Math.random() * ((max - min) + 1));
	}
}
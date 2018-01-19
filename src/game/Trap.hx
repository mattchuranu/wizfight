package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import game.part.Emitters;
import flash.geom.Point;

class Trap extends Entity
{
	private var sprite:Spritemap;
	private var spawnpt:Point;
	private var trapType:String;
	private var dir:Int;
	private var delay:Float;
	private var delayTimer:Float;
	public var spawned:Dynamic;
	private var activated:Bool;
	private var created:Bool;

	public function new(x:Float, y:Float, _spawnx:Int, _spawny:Int, _type:String, ?_reset:Float, ?_dir:Int)
	{
		super(x, y);

		sprite = new Spritemap("gfx/trap.png", 16, 4);

		//sprite.centerOrigin();
		graphic = sprite;
		layer = 9;
		type = "trigger";

		if (_dir != null) {
			dir = _dir;
		}

		delay = 0;
		if (_reset != null) {
			delay = _reset;
		}

		delayTimer = 0;
		activated = false;
		created = false;

		trapType = _type;
		spawnpt = new Point(_spawnx, _spawny);
		trace("5");

		if (trapType == "laser") {
			spawned = new Laser(spawnpt.x, spawnpt.y, dir, this);
			trace("laser created");
		} else if (trapType == "spike") {
			spawned = new Spike(spawnpt.x, spawnpt.y, dir);
		}

		setHitbox(16, 4);
	}

	override public function update()
	{
		if (trapType != "boulder") {
			if (!created) {
				scene.add(spawned);
				created = true;
			}
		}
		
		for (i in 0...Types.types.length) {
			if (collide(Types.types[i], x, y) != null && !cast(collide(Types.types[i], x, y), Player).dead) {
				if (!activated) {
					if (trapType == "boulder") {
						spawned = new Boulder(spawnpt.x, spawnpt.y, dir, this);
						scene.add(spawned);
						delayTimer = delay;
						activated = true;
					}
					else {
						spawned.activated = true;
						delayTimer = delay;
						activated = true;
					}
				}
			}
		}

		if (trapType == "boulder") {
			if (spawned == null) {
				if (delayTimer <= 0) {
					activated = false;
				} else {
					delayTimer -= 1;
				}
			} else {
				activated = true;
			}
		} else {
			if (!spawned.activated) {
				if (delayTimer <= 0) {
					activated = false;
				} else {
					delayTimer -= 1;
				}
			} else {
				activated = true;
			}
		}

		if (activated) {
			sprite.setFrame(1, 0);
		} else {
			sprite.setFrame(0, 0);
		}

		super.update();
	}
}
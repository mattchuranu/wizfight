package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import game.part.Emitters;
import flash.geom.Point;

class Laser extends Entity
{
	private var sprite:Spritemap;
	private var dir:Float;
	private var activated:Bool;
	private var timer:Int;
	private var beamSet:Bool;
	private var dist:Int;
	private var centerpt:Point;
	private var spawner:Trap;

	public function new(x:Float, y:Float, _dir:Float, _spawner:Trap)
	{
		super(x, y);

		sprite = new Spritemap("gfx/laser.png", 16, 16);
		sprite.setFrame(0, 0);
		centerpt = new Point(7, 4);
		trace("1");

		if (_dir == 0) {
			sprite.setFrame(0, 0);
			centerpt = new Point(7, 4);
		} else if (_dir == 1) {
			sprite.setFrame(0, 1);
			centerpt = new Point(7, 12);
		} else if (_dir == 2) {
			sprite.setFrame(1, 0);
			centerpt = new Point(4, 8);
		} else if (_dir == 3) {
			sprite.setFrame(1, 1);
			centerpt = new Point(12, 8);
		}
		trace("2");

		dir = _dir;
		dist = 0;
		activated = false;
		beamSet = false;
		trace("3");

		timer = 120;
		//setHitbox(32, 32, 16, 16);
		//sprite.centerOrigin();
		spawner = _spawner;
		graphic = sprite;
		layer = 0;
		trace("5");
		//type = "trap";
	}

	override public function update()
	{
		if (activated) {
			if (!beamSet) {
				if (dir == 0) {
					for (i in 0...HXP.screen.height) {
						if (collide("solid", x + centerpt.x, y + centerpt.y + i) != null) {
							dist = i;
							break;
						}
						if (y + centerpt.y + i >= HXP.screen.height) {
							dist = i;
							break;
						}
					}
					/*for (i in 0...dist) {
						scene.add(new LaserBeam(x + centerpt.x, y + centerpt.y + i));
					}*/
					beamSet = true;
				}
				else if (dir == 1) {
					for (i in 0...HXP.screen.height) {
						if (collide("solid", x + centerpt.x, y + centerpt.y - i) != null) {
							dist = i;
							break;
						}
						if (y + centerpt.y - i <= 0) {
							dist = i;
							break;
						}
					}
					/*for (i in 0...dist) {
						scene.add(new LaserBeam(x + centerpt.x, y + centerpt.y - i));
					}*/
					beamSet = true;
				} else if (dir == 2) {
					for (i in 0...HXP.screen.width) {
						if (collide("solid", x + centerpt.x + i, y + centerpt.y) != null) {
							dist = i;
							break;
						}
						if (x + centerpt.x + i >= HXP.screen.width) {
							dist = i;
							break;
						}
					}
					/*for (i in 0...dist) {
						scene.add(new LaserBeam(x + centerpt.x + i, y + centerpt.y));
					}*/
					beamSet = true;
				} else if (dir == 3) {
					for (i in 0...HXP.screen.width) {
						//trace(i);
						if (collide("solid", x + centerpt.x - i, y + centerpt.y) != null) {
							dist = i;
							break;
						}
						if (x + centerpt.x - i <= 0) {
							dist = i;
							break;
						}
						/*for (i in 0...dist) {
							scene.add(new LaserBeam(x + centerpt.x - i, y + centerpt.y));
							trace("added Laserbeam at " + (x + centerpt.x - i) + " " + (y + centerpt.y));
						}*/
					}
					beamSet = true;
				}
			}


			if (dist != 0) {
				if (dir == 0) {
					for (i in 0...dist) {
						scene.add(new LaserBeam(x + centerpt.x, y + centerpt.y + i));
						//trace("added Laserbeam at " + (x + centerpt.x - i) + " " + (y + centerpt.y));
					}
					dist = 0;
				}
				else if (dir == 1) {
					for (i in 0...dist) {
						scene.add(new LaserBeam(x + centerpt.x, y + centerpt.y - i));
						//trace("added Laserbeam at " + (x + centerpt.x - i) + " " + (y + centerpt.y));
					}
					dist = 0;
				}
				else if (dir == 2) {
					for (i in 0...dist) {
						scene.add(new LaserBeam(x + centerpt.x + i, y + centerpt.y));
						//trace("added Laserbeam at " + (x + centerpt.x - i) + " " + (y + centerpt.y));
					}
					dist = 0;
				}
				else if (dir == 3) {
					for (i in 0...dist) {
						scene.add(new LaserBeam(x + centerpt.x - i, y + centerpt.y));
						//trace("added Laserbeam at " + (x + centerpt.x - i) + " " + (y + centerpt.y));
					}
					dist = 0;
				}
			}

			if (timer <= 0) {
				activated = false;
				beamSet = false;
			} else {
				timer -= 1;
			}
		} else {
			timer = 120;
		}

		super.update();
	}
}
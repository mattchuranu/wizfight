package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;
import flash.geom.Point;

class OceanWater extends Entity
{
	public var sprite:Spritemap;
	private var spawn:Point;
	private var state:Int;
	private var moveState:Int;
	private var moveTimer:Int;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		spawn = new Point(x, y);
		state = 0;
		moveState = 0;
		moveTimer = 30;

		sprite = new Spritemap("gfx/powers/oceanwater.png", 16, 16);
		setHitbox(16, 16);
		type="ocean_pow";
		graphic = sprite;
		layer = 3;
	}

	override public function update()
	{
		y = spawn.y - (moveState * 16);

		if (collide(type, x, y - 1) == null && collide(type, x, y - 17) == null) {
			sprite.setFrame(1, 0);
		} else {
			sprite.setFrame(0, 0);
		}

		if (state == 0) {
			if (moveTimer <= 0) {
				moveState += 1;
				moveTimer = 30;
			} else {
				moveTimer -= 1;
			}

			if (moveState == 4) {
				state += 1;
			}
		} else if (state == 1) {
			if (moveTimer <= 0) {
				moveState -= 1;
				moveTimer = 30;
			} else {
				moveTimer -= 1;
			}

			if (moveState == 0) {
				scene.remove(this);
			}
		}
		
		super.update();
	}
}
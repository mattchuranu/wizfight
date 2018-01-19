package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;
import flash.geom.Point;

class LightningBolt extends Entity
{
	public var sprite:Spritemap;
	private var velocity:Point;
	private var targetY:Float;

	public function new(x:Float, y:Float, _targetY:Float)
	{
		super(x, y);

		velocity = new Point(0, 8);
		targetY = _targetY;

		sprite = new Spritemap("gfx/powers/lightning.png", 16, 240);
		graphic = sprite;
		setHitbox(16, 240);
		type = "lightning_pow";
		layer = 3;
	}
	override public function update()
	{
		for(i in 0...Std.int(Math.abs(velocity.y) + 1)) {
			//if (collide("solid", x, y + HXP.sign(velocity.y)) != null) {
			if (y + 240 >= targetY) {
				velocity.y = 0;
			}
			else {
				y += HXP.sign(velocity.y);
			}
		}

		if (velocity.y == 0) {
			scene.remove(this);
		}

		super.update();
	}

	override public function removed() {
		Emitters.SHAKEEMITTER.rmvd(x, y + sprite.height - 8);
	}
}
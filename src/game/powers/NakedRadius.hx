package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.masks.Circle;

class NakedRadius extends Entity
{
	public var sprite:Spritemap;
	private var i:Int;
	private var timer:Int;
	private var t:String;

	public function new(x:Float, y:Float, _t:String)
	{
		super(x, y);

		timer = 300;
		t = _t;

		sprite = new Spritemap("gfx/powers/nakedradius.png", 96, 96);
		sprite.centerOrigin;

		//setHitboxTo(new Circle(32, Std.int(x - 64), Std.int(y - 64)));
		setHitbox(96, 96, 48, 48);
		type = _t + "_stun";

		graphic = sprite;
		layer = 2;
	}
	override public function update()
	{
		//com.haxepunk.utils.Draw.setTarget(HXP.buffer);
		//com.haxepunk.utils.Draw.hitbox(cast(this, Entity), true);
		if (timer <= 0) {
			scene.remove(this);
		} else {
			timer -= 1;
		}

		var col = collide(t, x, y);

		if (col == null || cast(col, game.Player).dead) {
			scene.remove(this);
		}

		if (timer / 2 == Std.int(timer / 2)) sprite.setFrame(Std.random(4), 0);
		sprite.centerOrigin();
		super.update();
	}
}
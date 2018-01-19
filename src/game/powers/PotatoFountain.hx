package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class PotatoFountain extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;
	private var potatoTimer:Int;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		timer = 300;
		potatoTimer = Std.random(6);

		sprite = new Spritemap("gfx/powers/potatofountain.png", 16, 16);
		graphic = sprite;
		layer = 3;
	}
	override public function update()
	{
		if (timer <= 0) {
			scene.remove(this);
		} else {
			timer -= 1;
		}

		if (potatoTimer <= 0) {
			//scene.add(new PotatoProjectile(x + Std.random(16), y + 6));
			potatoTimer = Std.random(6);
		} else {
			potatoTimer -= 1;
		}
		
		super.update();
	}

	override public function removed() {
		Emitters.SHAKEEMITTER.rmvd(x, y);
	}
}
package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class PotatoBomb extends Entity
{
	public var sprite:Spritemap;
	private var timer:Int;
	private var potatoTimer:Int;
	private var startY:Float;
	private var t:String;

	public function new(x:Float, y:Float, _t:String)
	{
		super(x, y);

		timer = 300;
		potatoTimer = Std.random(6);
		startY = y;
		t = _t;

		sprite = new Spritemap("gfx/powers/potatobomb.png", 16, 16);
		setHitbox(16, 16);
		graphic = sprite;
		layer = 3;
	}
	override public function update()
	{
		y -= 2;

		if (y <= startY - 48 || collide("solid", x, y) != null) {
			for (i in 0...5) {
				scene.add(new PotatoProjectile(x + 8, y + 8, 2 - i, t));
			}
			//scene.add(new PotatoProjectile(x, y, 135));
			//scene.add(new PotatoProjectile(x, y, 180));
			//scene.add(new PotatoProjectile(x, y, 225));
			scene.remove(this);
		}
		
		super.update();
	}

	override public function removed() {
		Emitters.SHAKEEMITTER.rmvd(x, y);
	}
}
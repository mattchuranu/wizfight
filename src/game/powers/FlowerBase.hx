package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import game.part.Emitters;

class FlowerBase extends Entity
{
	public var sprite:Spritemap;
	public var flower:AttackFlower;
	private var timer:Int;

	public function new(x:Float, y:Float, _t:String)
	{
		super(x, y);

		timer = 900;

		flower = new AttackFlower(x, y, this, _t);

		sprite = new Spritemap("gfx/powers/flowerbase.png", 16, 6);
		graphic = sprite;
		layer = 3;
	}

	override public function added()
	{
		scene.add(flower);
	}

	override public function update()
	{
		if (timer <= 0) {
			scene.remove(flower);
			scene.remove(this);
		} else {
			timer -= 1;
		}
		
		super.update();
	}

	override public function removed() {
		Emitters.SHAKEEMITTER.rmvd(x, y);
	}
}
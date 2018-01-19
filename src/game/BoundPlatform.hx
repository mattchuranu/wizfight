package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;

class BoundPlatform extends Entity
{
	private var sprite:Spritemap;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/spawn.png", 16, 16);
		sprite.alpha = 0;

		//sprite.centerOrigin();
		graphic = sprite;
		layer = 2;
		type = "solid";

		setHitbox(16, 16);
	}

	override public function update()
	{
		super.update();
	}
}
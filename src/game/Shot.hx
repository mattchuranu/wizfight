package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
//import com.haxepunk.blur.BlurredGraphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;

class Shot extends Entity
{
	public var sprite:Spritemap;
	//private var sprite_blur:BlurredGraphic;

	public function new(x:Float, y:Float, _type:String, _f:Int, _blur:Int)
	{
		super(x, y);

		sprite = new Spritemap("gfx/shot/" + _type + "wizshot.png", 6, 6);

		if (_f == 0) {
			sprite.flipped = true;
		}
		//sprite_blur = new BlurredGraphic(sprite, _blur);

		//sprite.centerOrigin();
		graphic = sprite;
		layer = 1;
		type = _type + "_shot";

		setHitbox(6, 6);
	}

	override public function update()
	{
		if (sprite.flipped) {
			x -= 5;
		} else {
			x += 5;
		}

		if (collide("solid", x, y) != null) {
			scene.remove(this);
		}

		goneTooFarThisTime();
		super.update();
	}

	private function goneTooFarThisTime() {
		if (x <= 0 || x >= 320) {
			scene.remove(this);
		}
	}
}
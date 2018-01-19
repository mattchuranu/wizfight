package game.powers;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

class Outline extends Entity
{
	public var sprite:Spritemap;
	private var i:Int;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/powers/outline.png", 14, 18);
		graphic = sprite;
		layer = 0;
	}
	override public function update()
	{
		super.update();
	}

	public function updateSprite(_alpha:Float) {
		sprite.alpha = _alpha;
		this.graphic = sprite;
	}

	public function updateFrame(_frame:Int) {
		sprite.setFrame(_frame, 0);
	}
}
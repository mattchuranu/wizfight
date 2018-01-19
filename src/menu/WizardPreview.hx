package menu;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

class WizardPreview extends Entity
{
	public var sprite:Spritemap;
	private var spawn:Int = 0;

	public function new(x:Float, y:Float, _map:String)
	{
		super(x, y);

		sprite = new Spritemap("gfx/wiz/" + _map + "wiz.png", 12, 16);
		sprite.add("frame", [0]);
		sprite.alpha = 0;
		sprite.centerOrigin();
		graphic = sprite;
		sprite.play("frame");
		layer = 1;
	}
	override public function update()
	{
		//super.update();
	}

	public function updateSprite(_alpha:Float) {
		sprite.alpha = _alpha;
		this.graphic = sprite;
	}

	public function updateImage(_type:String) {
		sprite = new Spritemap("gfx/wiz/" + _type + "wiz.png", 12, 16);
		sprite.add("frame", [0]);
		sprite.centerOrigin();
		this.graphic = sprite;
		sprite.play("frame");
	}

	public function updateScale(_scale:Float) {
		sprite.scale = _scale;
		this.graphic = sprite;
	}
}
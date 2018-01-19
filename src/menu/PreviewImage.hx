package menu;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import flash.display.BitmapData;

class PreviewImage extends Entity
{
	private var sprite:Spritemap;
	private var spawn:Int = 0;

	public function new(x:Float, y:Float, _map:String)
	{
		super(x, y);

		sprite = new Spritemap(BitmapData.load("gfx/preview/" + _map + ".png"), 80, 60);
		graphic = sprite;
		layer = 1;
	}
	
	override public function update()
	{
		//super.update();
	}

	public function updateSprite(_map:String) {
		sprite = new Spritemap(BitmapData.load("gfx/preview/" + _map + ".png"), 80, 60);
		this.graphic = sprite;
	}
}
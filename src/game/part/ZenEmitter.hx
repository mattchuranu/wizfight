package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class ZenEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new()
	{
		super(x, y);
		_emitter = new Emitter("gfx/emit/fogemit.png", 1, 1);
		_emitter.newType("zen", [0]);
		_emitter.setMotion("zen", 0, 20, 0.2, 360, -4, 1, Ease.quadOut);
		_emitter.setAlpha("zen", 1, 0.1);
		graphic = _emitter;
		layer = 0;
	}

	public function zen(_x:Float, _y:Float)
	{
		for(i in 0...100) {
			_emitter.emit("zen", _x, _y);
		}
	}
}
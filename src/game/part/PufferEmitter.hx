package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class PufferEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new()
	{
		super(x, y);
		_emitter = new Emitter("gfx/emit/pufferemit.png", 1, 1);
		_emitter.newType("death", [0]);
		_emitter.setMotion("death", 0, 15, 0.2, 360, -4, 1, Ease.quadOut);
		_emitter.setAlpha("death", 1, 0.1);
		graphic = _emitter;
		layer = 5;
	}

	public function emit(_x:Float, _y:Float)
	{
		for(i in 0...100) {
			_emitter.emit("death", _x, _y);
		}
	}
}
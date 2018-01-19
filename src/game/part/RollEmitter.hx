package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class RollEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new()
	{
		super(x, y);
		_emitter = new Emitter("gfx/emit/allemit.png", 3, 3);
		_emitter.newType("roll", [0]);
		_emitter.setMotion("roll", 90, 8, 0.3, 0, -2, 1, Ease.quadOut);
		_emitter.setAlpha("roll", 1, 0.1);
		graphic = _emitter;
		layer = 2;
	}

	public function roll(_x:Float, _y:Float) {
		_emitter.emit("roll", _x, _y);
	}
}
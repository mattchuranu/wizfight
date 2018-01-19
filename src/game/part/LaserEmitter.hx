package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class LaserEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new()
	{
		super(x, y);
		_emitter = new Emitter("gfx/emit/laseremit.png", 1, 1);
		_emitter.newType("still", [0]);
		_emitter.setMotion("still", 90, 1, 0.5, 360, 1, 1, Ease.quadOut);
		_emitter.setAlpha("still", 1, 0.1);
		graphic = _emitter;
		layer = 8;
		trace("10");
	}

	public function laser(_x:Float, _y:Float)
	{
		for(i in 0...10) {
#if flash
			_emitter.emit("still", _x, _y);
#else
			_emitter.emit("still", _x + 1, _y);
#end
		}
	}
}
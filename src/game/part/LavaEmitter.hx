package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class LavaEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new()
	{
		super(x, y);
		_emitter = new Emitter("gfx/emit/lavaemit.png", 3, 3);
		_emitter.newType("up", [0]);
		_emitter.setMotion("up", 90, 12, 0.2, 0, -4, 1, Ease.quadOut);
		_emitter.setAlpha("up", 1, 0.1);
		graphic = _emitter;
		layer = 9;
	}

	public function lava(_x:Float, _y:Float)
	{
		for(i in 0...10) {
#if flash
			_emitter.emit("up", _x, _y);
#else
			_emitter.emit("up", _x + 1, _y);
#end
		}
	}
}
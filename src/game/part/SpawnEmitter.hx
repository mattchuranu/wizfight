package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class SpawnEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new()
	{
		super(x, y);
		_emitter = new Emitter("gfx/emit/allemit.png", 1, 1);
		_emitter.newType("up", [0]);
		_emitter.setMotion("up", 90, 10, 1, 10, -4, 1, Ease.quadOut);
		_emitter.setAlpha("up", 1, 0.1);
		_emitter.newType("still", [0]);
		_emitter.setMotion("still", 90, 1, 0.5, 360, 1, 1, Ease.quadOut);
		_emitter.setAlpha("still", 1, 0.1);
		graphic = _emitter;
		layer = 6;
	}

	public function spawn(_x:Float, _y:Float) {
		for(i in 0...10) {
			_emitter.emit("still", _x, _y);
		}
	}
	public function flame(_x:Float, _y:Float)
	{
		for(i in 0...20) {
			_emitter.emit("up", _x, _y);
		}
	}
}
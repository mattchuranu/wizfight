package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class CloudEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new()
	{
		super(x, y);
		_emitter = new Emitter("gfx/emit/allemit.png", 3, 3);
		_emitter.newType("cloud", [0]);
		_emitter.setMotion("cloud", 0, 4, 0.1, 360, -4, 0, Ease.quadOut);
		_emitter.setAlpha("cloud", 1, 0.1);
		graphic = _emitter;
		layer = 2;
	}

	public function cloud(_x:Float, _y:Float) {
		for(i in 0...20) {
			_emitter.emit("cloud", _x + 2, _y);
			_emitter.emit("cloud", _x + 6, _y);
			_emitter.emit("cloud", _x + 10, _y);
		}
	}
}
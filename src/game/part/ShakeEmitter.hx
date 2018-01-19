package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class ShakeEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new(_tiles:String)
	{
		super(x, y);
		//_emitter = new Emitter("gfx/tiles/" + _tiles + ".png", 1, 1);
		_emitter = new Emitter("gfx/emit/shakeemit.png", 1, 1);
		_emitter.newType("shake", [0]);
		_emitter.setMotion("shake", 270, 5, 0.4, 0, 4, 0, Ease.quadOut);
		_emitter.setAlpha("shake", 0.7, 0.1);
		graphic = _emitter;
		layer = 2;
	}

	public function shake()
	{
		var _x, _y;

		for (w in 0...20) {
			for (h in 0...15) {
				_x = 8 + (16 * w);
				_y = 8 + (16 * h);
				if (collide("solid", _x, _y) != null) {
					var emitx = _x + Std.int(randomRange(-4, 4));
					var emity = _y + Std.int(randomRange(-4, 4));
					//_emitter.setAlpha("shake", Math.random(), 0.1);
					if (Math.random() > 0.7) {
						for (i in 0...15) {
							_emitter.emit("shake", emitx + Std.int(randomRange(-4, 4)), emity + Std.int(randomRange(-4, 4)));
						}
					}
				}
			}
		}
	}

	private function randomRange(min:Int, max:Int) {
		return min + (Math.random() * ((max - min) + 1));
	}

	public function rmvd(_x:Float, _y:Float) {
		for (i in 0...10) {
			_emitter.emit("shake", _x + Std.random(16), _y + Std.random(16));
		}
	}
}
package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Ease;
import com.haxepunk.Graphic;

class BlurEmitter extends Entity 
{
	private var _emitter:Emitter;
	private var source:Image;
	private var source_flipped:Image;

	public function new(_type:String, _w:Int, _h:Int)
	{
		super(x, y);

		_emitter = new Emitter("gfx/" + _type + ".png", _w, _h);
		trace("yay");
		_emitter.newType("blur", [0]);
		_emitter.setMotion("blur", 0, 0, 0.1, 0, 0, 0, Ease.quadOut);
		_emitter.setAlpha("blur", 0.6, 0.1);
		_emitter.newType("blur2", [1]);
		_emitter.setMotion("blur2", 0, 0, 0.1, 0, 0, 0, Ease.quadOut);
		_emitter.setAlpha("blur2", 0.6, 0.1);
		graphic = _emitter;
		layer = 2;
	}

	public function blur(_x:Float, _y:Float, _flipped:Int)
	{
		if (_flipped == 0) {
			_emitter.emit("blur2", _x, _y);
		} else {
			_emitter.emit("blur", _x, _y);
		}
	}
}
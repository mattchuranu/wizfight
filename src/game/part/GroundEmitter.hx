package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class GroundEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new(_type:String)
	{
		super(x, y);
		_emitter = new Emitter("gfx/emit/" + _type + "emit.png", 1, 1);
		_emitter.newType("up", [0]);
		_emitter.setMotion("up", 90, 10, 1, 0, -4, 1, Ease.quadOut);
		_emitter.setAlpha("up", 1, 0.1);
		_emitter.newType("exp", [0]);
		_emitter.setMotion("exp", 0, 20, 0.2, 360, -4, 1, Ease.quadOut);
		_emitter.setAlpha("exp", 1, 0.1);
		graphic = _emitter;
		layer = 2;
	}

	public function ground(_x:Float, _y:Float, ?_type:Dynamic)
	{
		if (_type != null) {
			_emitter.setSource("gfx/emit/" + _type + "emit.png");
		}

		for(i in 0...10) {
#if flash
			_emitter.emit("up", _x, _y);
#else
			_emitter.emit("up", _x + 1, _y);
#end
		}
	}

	public function explode(_x:Float, _y:Float)
	{
		for(i in 0...100) {
			_emitter.emit("exp", _x, _y);
		}
	}
}
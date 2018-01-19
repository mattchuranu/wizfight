package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class TrailEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new(_type:String)
	{
		super(x, y);
		_emitter = new Emitter("gfx/emit/" + _type + "emit.png", 1, 1);
		_emitter.newType("up", [0]);
		_emitter.setMotion("up", 90, 1, 0.5, 360, 2, 1, Ease.quadOut);
		_emitter.setAlpha("up", 1, 0.1);
		graphic = _emitter;
		type = _type + "_trail";
		layer = 1;
	}

	public function trail(_x:Float, _y:Float)//, ?_type:Dynamic)
	{
		/*if (_type != null) {
			_emitter.setSource("gfx/" + _type + "emit.png");
		}*/

		for(i in 0...30) {
			_emitter.emit("up", _x, _y);
		}
	}
}
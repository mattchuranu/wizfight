package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class PowerEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new(_type:String)
	{
		super(x, y);
		_emitter = new Emitter("gfx/emit/" + _type + "emit.png", 1, 1);
		_emitter.newType("up", [0]);
		_emitter.setMotion("up", 90, 1, 0.3, 360, 2, 0.1, Ease.quadOut);
		_emitter.setAlpha("up", 1, 0.1);
		_emitter.newType("down", [0]);
		_emitter.setMotion("down", 90, 1, 1, 360, 2, 0.1, Ease.quadOut);
		_emitter.setAlpha("down", 1, 0.1);
		graphic = _emitter;
		type = _type + "_trail";
		layer = 3;
	}

	public function trail(_x:Float, _y:Float)//, ?_type:Dynamic)
	{
		for(i in 0...30) {
			_emitter.emit("up", _x, _y);
		}
	}
	public function gold(_x:Float, _y:Float)//, ?_type:Dynamic)
	{
		for(i in 0...10) {
			_emitter.emit("down", _x, _y);
		}
	}

	public function setSource(_type:String)
	{
		_emitter.setSource("gfx/emit/" + _type + "emit.png", 1, 1);
	}
}
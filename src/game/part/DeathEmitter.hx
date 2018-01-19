package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class DeathEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new(_type:String)
	{
		super(x, y);
		_emitter = new Emitter("gfx/emit/" + _type + "emit.png", 3, 3);
		_emitter.newType("death", [0]);
		_emitter.setMotion("death", 0, 10, 0.2, 360, -4, 1, Ease.quadOut);
		_emitter.setAlpha("death", 1, 0.1);
		graphic = _emitter;
		layer = -1;
	}

	public function death(_x:Float, _y:Float)
	{
		for(i in 0...100) {
			_emitter.emit("death", _x, _y);
		}
	}
}
package game.part;

import flash.display.BitmapData;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.utils.Ease;

class DustEmitter extends Entity 
{
	private var _emitter:Emitter;

	public function new()
	{
		super(x, y);
		_emitter = new Emitter("gfx/emit/allemit.png", 1, 1);
		_emitter.newType("up", [0]);
		_emitter.setMotion("up", 0, 4, 0.15, 180, -4, 0.05, Ease.quadOut);
		_emitter.setAlpha("up", 1, 0.1);
		_emitter.newType("down", [0]);
		_emitter.setMotion("down", 195, 4, 0.1, 150, -4, 0.05, Ease.quadOut);
		_emitter.setAlpha("down", 1, 0.1);
		_emitter.newType("exp", [0]);
		_emitter.setMotion("exp", 0, 10, 0.2, 360, -4, 1, Ease.quadOut);
		_emitter.setAlpha("exp", 1, 0.1);
		_emitter.newType("hit", [0]);
		_emitter.setMotion("hit", 0, 4, 0.2, 360, -4, 0.05, Ease.quadOut);
		_emitter.setAlpha("hit", 1, 0.1);
		_emitter.newType("smash", [0]);
		_emitter.setMotion("smash", 90, 16, 0.2, 0, -4, 1, Ease.quadOut);
		_emitter.setAlpha("smash", 1, 0.1);
		graphic = _emitter;
		layer = 0;
	}

	public function up(_x:Float, _y:Float)
	{
		for(i in 0...30) {
			_emitter.emit("up", _x + 6, _y + 16);
		}
	}

	public function down(_x:Float, _y:Float)
	{
		for(i in 0...30) {
			_emitter.emit("down", _x + 6, _y);
		}
	}

	public function explode(_x:Float, _y:Float)
	{
		for(i in 0...50) {
			_emitter.emit("exp", _x, _y);
		}
	}

	public function smash(_x:Float, _y:Float)
	{
		for(i in 0...80) {
			_emitter.emit("smash", _x + Std.random(16), _y + 16);
		}
	}

	public function hit(_x:Float, _y:Float)
	{
		for(i in 0...30) {
			_emitter.emit("hit", _x, _y);
		}
	}
}
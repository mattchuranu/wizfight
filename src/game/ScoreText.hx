package game;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Draw;

class ScoreText extends Entity 
{
	public var scoreText:Text;
	private var num:Int;

	public function new(_x:Float, _y:Float, _num:Int, ?_color:Int, ?center:Bool, ?_size:Int, ?_font:String)
	{
		super(_x, _y);
		//trace("super");

		scoreText = new Text(Std.string(Scores.SCORES[num]));

		if (_color != null) {
			scoreText.color = _color;
		} else {
			scoreText.color = 0xFFFFFF;
		}

		num = _num;

		if (_size != null) {
			scoreText.size = _size;
		} else {
			scoreText.size = 10;
		}

		if (_font != null) {
			scoreText.font = _font;
		}

		if (center == true) {
			scoreText.centerOrigin();
		}

		graphic = scoreText;
		x = _x;
		y = _y;
		layer = -10;
	}

	override public function update()
	{
		scoreText.text = Std.string(Scores.SCORES[num]);
		super.update();
	}
}
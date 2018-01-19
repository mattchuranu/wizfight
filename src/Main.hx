import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine
{

	override public function init()
	{
#if debug
		//HXP.console.enable();
#end
		//HXP.screen.scaleX = 3;
		//HXP.screen.scaleY = 3;
		HXP.fullscreen = true;

		HXP.scene = new TitleScreen();
	}

	public static function main() { new Main(); }

}
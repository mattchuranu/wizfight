import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import game.Types;
import game.Border;
import haxe.xml.Fast;
import menu.Logo;
import flash.geom.Rectangle;
import flash.ui.Mouse;

class TitleScreen extends Scene
{
	private var logo:Logo;

	public function new()
	{
		trace("woo!");
		Types.types = new Array();
		Types.types[0] = "earth";
		Types.types[1] = "fire";
		Types.types[2] = "ice";
		Types.types[3] = "lightning";
		Types.types[4] = "barnacle";
		Types.types[5] = "blood";
		Types.types[6] = "cloud";
		Types.types[7] = "coffee";
		Types.types[8] = "fog";
		Types.types[9] = "generic";
		Types.types[10] = "love";
		Types.types[11] = "ocean";
		Types.types[12] = "peppermint";
		Types.types[13] = "rainbow";
		Types.types[14] = "sun";
		Types.types[15] = "naked";
		Types.types[16] = "chaos";
		Types.types[17] = "flower";
		Types.types[18] = "gold";
		Types.types[19] = "mushroom";
		Types.types[20] = "potato";
		Types.types[21] = "bacon";
		Types.types[22] = "egg";
		Types.types[23] = "buff";
		Types.types[24] = "invisi";
		Types.types[25] = "dark";
		Types.types[26] = "zen";
		Types.types[27] = "laser";
		Types.types[28] = "cherry";
		Types.types[29] = "banana";
		Types.types[30] = "moon";
		Types.types[31] = "pizza";
		Types.types[32] = "mimic";
		Types.types[33] = "thief";

		super();
	}

	public override function begin()
	{
		HXP.screen.scaleX = Math.min(HXP.windowWidth / 360, HXP.windowHeight / 240);
		HXP.screen.scaleY = Math.min(HXP.windowWidth / 360, HXP.windowHeight / 240);

		if (HXP.windowWidth / 360 > HXP.windowHeight / 240) {
			Types._xPos = Std.int(-(((flash.system.Capabilities.screenResolutionX - (360 * HXP.screen.scaleX)) / 2) / HXP.screen.scaleX));
			Types._yPos = 0;
		} else {
			Types._xPos = 0;
			Types._yPos = Std.int(-(((flash.system.Capabilities.screenResolutionY - (240 * HXP.screen.scaleY)) / 2) / HXP.screen.scaleX));
		}

		HXP.camera.x = Types._xPos;
		HXP.camera.y = Types._yPos;
		Mouse.hide();

		logo = new Logo(180, 100);
		add(logo);
	}
}
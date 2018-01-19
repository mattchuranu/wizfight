import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import menu.MenuText;
import menu.PreviewImage;
import menu.WizardPreview;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import flash.geom.Point;
import haxe.xml.Fast;
import com.haxepunk.utils.Joystick;
import game.Types;
import game.Border;
#if mac
import game.XBOX_GAMEPAD_MAC;
#end
#if windows
import game.XBOX_GAMEPAD_WIN;
#end

class Credits extends Scene
{
	private var txt:Array<MenuText>;
	private var logo:Image;
	private var timer:Int;
	private var brdr:Border;

	public function new()
	{
		timer = 660;
		super();
	}

	override public function begin()
	{
		logo = new Image("gfx/logo2.png");
		logo.x = 180;
		logo.y = 350;
		logo.layer = 1;
		logo.centerOrigin();
		addGraphic(logo);

		txt = new Array();
		txt[0] = new MenuText("By Another Day, Another Game", 180, 450, true, 18, "font/Dretch.otf");
		txt[1] = new MenuText("- Programming, game design and environment art -", 180, 470, true, 18, "font/Dretch.otf");
		txt[2] = new MenuText("Matt Chelen", 180, 480, true, 18, "font/Dretch.otf");
		txt[3] = new MenuText("- Character design, game design, and art -", 180, 500, true, 18, "font/Dretch.otf");
		txt[4] = new MenuText("Katarina Klick", 180, 510, true, 18, "font/Dretch.otf");
		txt[5] = new MenuText("- Music -", 180, 530, true, 18, "font/Dretch.otf");
		txt[6] = new MenuText("Jordan Oakley", 180, 540, true, 18, "font/Dretch.otf");
		txt[7] = new MenuText("- Special Thanks To -", 180, 560, true, 18, "font/Dretch.otf");
		txt[8] = new MenuText("Alex Watson", 180, 580, true, 18, "font/Dretch.otf");
		txt[9] = new MenuText("@BoyOfBacon", 180, 590, true, 18, "font/Dretch.otf");
		txt[10] = new MenuText("@_alts", 180, 600, true, 18, "font/Dretch.otf");
		txt[11] = new MenuText("@DarkestKale", 180, 610, true, 18, "font/Dretch.otf");
		txt[12] = new MenuText("AlphaMember, GodBlessU, JLJac, and jonbro of the TIGSource forums.", 180, 620, true, 18, "font/Dretch.otf");
		txt[13] = new MenuText("Benjamin Porter for allowing the use of his character Moonman from his game Moonman.", 180, 630, true, 18, "font/Dretch.otf");

		for (i in 0...txt.length) {
			txt[i].menuText.layer = 1;
			add(txt[i]);
		}

		if (HXP.fullscreen) {
			HXP.camera.x = Types._xPos;
			HXP.camera.y = Types._yPos;
			brdr = new Border(0, 0);
			add(brdr);
		}
	}

	override public function update() 
	{
		if (timer <= 0) {
			HXP.scene = new TitleScreen();
		} else {
			timer -= 1;
		}
		
		logo.y -= 1;

		for (i in 0...txt.length) {
			txt[i].y -= 1;
		}

		if (Input.pressed(Key.ESCAPE)) {
			HXP.scene = new TitleScreen();
		}
		for (i in 0...4) {
#if mac
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.X_BUTTON) || Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.B_BUTTON)) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.X_BUTTON) || Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.B_BUTTON)) {
#end
				HXP.scene = new TitleScreen();
			}
		}
	}
}
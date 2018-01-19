import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Input;
import haxe.xml.Fast;
import game.Types;
import game.Border;
import menu.MenuText;
#if mac
import game.XBOX_GAMEPAD_MAC;
#end
#if windows
import game.XBOX_GAMEPAD_WIN;
#end

class HowTo extends Scene
{
	private var controlFast:Fast;
	private var controls:Array<Fast>;
	private var focus:Int;
	private var rightArrow:MenuText;
	private var leftArrow:MenuText;
	private var brdr:Border;

	public function new()
	{
		focus = 0;
		controls = new Array();
		var controlString = openfl.Assets.getBytes("conf/controls.xml");
		var controlXML = Xml.parse(controlString.toString());
		controlFast = new Fast(controlXML.firstElement());
		var plyrcontrols = controlFast.node.players;
		controls[0] = plyrcontrols.node.pone;
		controls[1] = plyrcontrols.node.ptwo;
		controls[2] = plyrcontrols.node.pthree;
		controls[3] = plyrcontrols.node.pfour;

		super();
	}

	public override function begin()
	{
		//_text:String, _x:Float, _y:Float, ?center:Bool, ?_size:Int, ?_font:String
		var txt = new MenuText("Menu controls", 180, 20, true, 25, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Keyboard", 90, 40, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Change selection : Left/right arrow keys", 90, 50, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Select/Continue : Z", 90, 60, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Go back : X", 90, 70, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Go to title screen : Escape", 90, 80, true, 12, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Gamepad", 270, 40, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Change selection : Left analogue stick", 270, 50, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Select/Continue : A", 270, 60, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Go back : X", 270, 70, true, 12, "font/Dretch.otf");
		add(txt);

		/*txt = new MenuText("P1 (Keyboard)", 90, 40, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Change selection : " + Key.nameOfKey(Std.parseInt(controls[0].att.up)) + "/" + Key.nameOfKey(Std.parseInt(controls[0].att.down)) + "/" + Key.nameOfKey(Std.parseInt(controls[0].att.left)) + "/" + Key.nameOfKey(Std.parseInt(controls[0].att.right)), 90, 50, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Select/Continue : " + Key.nameOfKey(Std.parseInt(controls[0].att.hitone)), 90, 60, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Go back : " + Key.nameOfKey(Std.parseInt(controls[0].att.hittwo)), 90, 70, true, 12, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("P2 (Keyboard)", 90, 90, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Change selection : " + Key.nameOfKey(Std.parseInt(controls[1].att.up)) + "/" + Key.nameOfKey(Std.parseInt(controls[1].att.down)) + "/" + Key.nameOfKey(Std.parseInt(controls[1].att.left)) + "/" + Key.nameOfKey(Std.parseInt(controls[1].att.right)), 90, 100, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Select/Continue : " + Key.nameOfKey(Std.parseInt(controls[1].att.hitone)), 90, 110, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Go back : " + Key.nameOfKey(Std.parseInt(controls[1].att.hittwo)), 90, 120, true, 12, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("P3 (Keyboard)", 90, 140, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Change selection : " + Key.nameOfKey(Std.parseInt(controls[2].att.up)) + "/" + Key.nameOfKey(Std.parseInt(controls[2].att.down)) + "/" + Key.nameOfKey(Std.parseInt(controls[2].att.left)) + "/" + Key.nameOfKey(Std.parseInt(controls[2].att.right)), 90, 150, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Select/Continue : " + Key.nameOfKey(Std.parseInt(controls[2].att.hitone)), 90, 160, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Go back : " + Key.nameOfKey(Std.parseInt(controls[2].att.hittwo)), 90, 170, true, 12, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("P4 (Keyboard)", 270, 40, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Change selection : " + Key.nameOfKey(Std.parseInt(controls[3].att.up)) + "/" + Key.nameOfKey(Std.parseInt(controls[3].att.down)) + "/" + Key.nameOfKey(Std.parseInt(controls[3].att.left)) + "/" + Key.nameOfKey(Std.parseInt(controls[3].att.right)), 270, 50, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Select/Continue : " + Key.nameOfKey(Std.parseInt(controls[3].att.hitone)) , 270, 60, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Go back : " + Key.nameOfKey(Std.parseInt(controls[3].att.hittwo)), 270, 70, true, 12, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Keyboard (Global)", 270, 90, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Change selection (doesn't work in game setup) : Left/Right arrow", 270, 100, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Select/Continue (doesn't work in game setup) : Space", 270, 110, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Go to title screen : Escape", 270, 120, true, 12, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Gamepad", 270, 140, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Change selection : Left analogue stick", 270, 150, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Select/Continue : A", 270, 160, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Go back : X", 270, 170, true, 12, "font/Dretch.otf");
		add(txt);*/

		rightArrow = new MenuText(">", 350, 120, true, 25, "font/Dretch.otf");
		add(rightArrow);

		leftArrow = new MenuText("<", 370, 120, true, 25, "font/Dretch.otf");
		add(leftArrow);

		txt = new MenuText("Game controls", 540, 20, true, 25, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("P1 (Keyboard)", 450, 40, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Move left/right: " + Key.nameOfKey(Std.parseInt(controls[0].att.left)) + "/" + Key.nameOfKey(Std.parseInt(controls[0].att.right)), 450, 50, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Jump : " + Key.nameOfKey(Std.parseInt(controls[0].att.up)), 450, 60, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Attack : " + Key.nameOfKey(Std.parseInt(controls[0].att.hitone)), 450, 70, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Activate power : " + Key.nameOfKey(Std.parseInt(controls[0].att.hittwo)), 450, 80, true, 12, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("P2 (Keyboard)", 450, 100, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Move left/right: " + Key.nameOfKey(Std.parseInt(controls[1].att.left)) + "/" + Key.nameOfKey(Std.parseInt(controls[1].att.right)), 450, 110, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Jump : " + Key.nameOfKey(Std.parseInt(controls[1].att.up)), 450, 120, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Attack : " + Key.nameOfKey(Std.parseInt(controls[1].att.hitone)), 450, 130, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Activate power : " + Key.nameOfKey(Std.parseInt(controls[1].att.hittwo)), 450, 140, true, 12, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("P3 (Keyboard)", 450, 160, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Move left/right: " + Key.nameOfKey(Std.parseInt(controls[2].att.left)) + "/" + Key.nameOfKey(Std.parseInt(controls[2].att.right)), 450, 170, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Jump : " + Key.nameOfKey(Std.parseInt(controls[2].att.up)), 450, 180, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Attack : " + Key.nameOfKey(Std.parseInt(controls[2].att.hitone)), 450, 190, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Activate power : " + Key.nameOfKey(Std.parseInt(controls[2].att.hittwo)), 450, 200, true, 12, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("P4 (Keyboard)", 630, 40, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Move left/right: " + Key.nameOfKey(Std.parseInt(controls[3].att.left)) + "/" + Key.nameOfKey(Std.parseInt(controls[3].att.right)), 630, 50, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Jump : " + Key.nameOfKey(Std.parseInt(controls[3].att.up)), 630, 60, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Attack : " + Key.nameOfKey(Std.parseInt(controls[3].att.hitone)), 630, 70, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Activate power : " + Key.nameOfKey(Std.parseInt(controls[3].att.hittwo)), 630, 80, true, 12, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Gamepad", 630, 100, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Move left/right: Left analogue stick left/right", 630, 110, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Jump : A", 630, 120, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Attack : X", 630, 130, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Activate power: Y", 630, 140, true, 12, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Rules", 630, 160, true, 18, "font/Dretch.otf");
		add(txt);

		txt = new MenuText("Kill the other players!", 630, 170, true, 12, "font/Dretch.otf");
		add(txt);
		txt = new MenuText("Collect three orbs to unleash your wizard's power!", 630, 180, true, 12, "font/Dretch.otf");
		add(txt);

		if (HXP.fullscreen) {
			HXP.camera.x = Types._xPos;
			HXP.camera.y = Types._yPos;
			brdr = new Border(0, 0);
			//add(brdr);
		}
	}

	public override function update() {

		if (!HXP.fullscreen) {
			if (HXP.camera.x < focus * 360) {
				HXP.camera.x += 10;
			} else if (HXP.camera.x > focus * 360) {
				HXP.camera.x -= 10;
			}
		} else {
			brdr.x = HXP.camera.x - 720;
			brdr.layer = -20;
			if (HXP.camera.x < focus * 360 + Types._xPos) {
				HXP.camera.x += 10;
			} else if (HXP.camera.x > focus * 360 + Types._xPos) {
				HXP.camera.x -= 10;
			}
		}

		if (focus == 0) {
			rightArrow.menuText.text = ">";
			leftArrow.menuText.text = "";
		} else {
			rightArrow.menuText.text = "";
			leftArrow.menuText.text = "<";
		}

		if (Input.pressed(Key.LEFT)) {
			if (focus > 0) {
				focus -= 1;
			} else {
				HXP.scene = new TitleScreen();	
			}
		}

		if (Input.pressed(Key.RIGHT)) {
			if (focus < 1) {
				focus += 1;
			}
		}

		if (Input.pressed(Key.ESCAPE)) {
			HXP.scene = new TitleScreen();	
		}

		if (Input.pressed(Key.X)) {
			if (focus > 0) {
				focus -= 1;
			} else {
				HXP.scene = new TitleScreen();	
			}
		}

		for (i in 0...4) {
			/*if (Input.pressed(Std.parseInt(controls[i].att.hitone))) {
				if (focus < 1) {
					focus += 1;
				}
			} else if (Input.pressed(Std.parseInt(controls[i].att.hittwo))) {
				if (focus > 0) {
					focus -= 1;
				} else {
					HXP.scene = new TitleScreen();
				}
			}

#if mac
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.A_BUTTON)) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.A_BUTTON)) {
#end
				if (focus < 1) {
					focus += 1;
				}
			}*/

#if mac
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.X_BUTTON)) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.X_BUTTON)) {
#end
				if (focus > 0) {
					focus -= 1;
				} else {
					HXP.scene = new TitleScreen();
				}
			}

#if mac
			var xaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X);
#end
#if windows
			var xaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X);
#end
			if (Math.abs(xaxis) > Joystick.deadZone + 0.2) {
				if (xaxis < 0) {
					if (focus > 0) {
						focus -= 1;
					}
				} else if (xaxis > 0) {
					if (focus < 1) {
						focus += 1;
					}
				}
			}
		}
	}
}
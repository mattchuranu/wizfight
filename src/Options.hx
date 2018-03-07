import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Input;
import haxe.xml.Fast;
import game.Types;
import menu.MenuText;
import flash.geom.Point;
#if (mac || linux)
import game.XBOX_GAMEPAD_MAC;
#end
#if windows
import game.XBOX_GAMEPAD_WIN;
#end

class Options extends Scene
{
	private var controlFast:Fast;
	private var controls:Array<Fast>;
	private var focus:Int;
	private var menuFocus:Int;
	private var rightArrow:MenuText;
	private var leftArrow:MenuText;
	private var selectTxt:Array<MenuText>;
	private var txt:Array<MenuText>;
	private var controlNum:Array<Array<Int>>;
	private var normalTxt:Array<String>;
	private var extraKeys:Array<Int>;
	private var normalTxtTwo:Array<Array<String>>;
	private var normalTxtThree:Array<Array<String>>;
	private var state:Int;
	private var waitingOn:Point;
	private var msg:MenuText;
	private var maxNum:Array<Int>;
	private var joystickTimer:Int;

	public function new()
	{
		focus = 0;
		state = 0;
		joystickTimer = 0;
		waitingOn = new Point(0, 0);
		controls = new Array();
		var controlString = openfl.Assets.getBytes("conf/controls.xml");
		var controlXML = Xml.parse(controlString.toString());
		controlFast = new Fast(controlXML.firstElement());
		var plyrcontrols = controlFast.node.players;
		controls[0] = plyrcontrols.node.pone;
		controls[1] = plyrcontrols.node.ptwo;
		controls[2] = plyrcontrols.node.pthree;
		controls[3] = plyrcontrols.node.pfour;

		controlNum = new Array();
		for (i in 0...4) {
			controlNum[i] = new Array();

			controlNum[i][0] = Std.parseInt(controls[i].att.up);
			controlNum[i][1] = Std.parseInt(controls[i].att.down);
			controlNum[i][2] = Std.parseInt(controls[i].att.left);
			controlNum[i][3] = Std.parseInt(controls[i].att.right);
			controlNum[i][4] = Std.parseInt(controls[i].att.hitone);
			controlNum[i][5] = Std.parseInt(controls[i].att.hittwo);
		}

		controlNum[4] = new Array();
		controlNum[4][0] = Std.parseInt(controlFast.node.jump.att.option);
		controlNum[4][1] = Std.parseInt(controlFast.node.orb.att.loss);
		controlNum[4][2] = Std.parseInt(controlFast.node.orb.att.rate);
		for (i in 3...6) {
			controlNum[4][i] = 0;
		}

		maxNum = new Array();
		maxNum[0] = 1;
		maxNum[1] = 3;
		maxNum[2] = 2;
		for (i in 3...6) {
			maxNum[i] = 0;
		}

		normalTxt = new Array();
		normalTxt[0] = "Keyboard (P" + (focus + 1) + ")";
		normalTxt[1] = Key.nameOfKey(controlNum[focus][0]);
		normalTxt[2] = Key.nameOfKey(controlNum[focus][1]);
		normalTxt[3] = Key.nameOfKey(controlNum[focus][2]);
		normalTxt[4] = Key.nameOfKey(controlNum[focus][3]);
		normalTxt[5] = Key.nameOfKey(controlNum[focus][4]);
		normalTxt[6] = Key.nameOfKey(controlNum[focus][5]);
		normalTxt[7] = "Save";
		normalTxt[8] = "Exit";

		normalTxtTwo = new Array();

		normalTxtTwo[0] = new Array();
		normalTxtTwo[0][0] = "Jump: ";
		normalTxtTwo[0][1] = "Down: ";
		normalTxtTwo[0][2] = "Left: ";
		normalTxtTwo[0][3] = "Right: ";
		normalTxtTwo[0][4] = "Attack: ";
		normalTxtTwo[0][5] = "Activate power: ";

		normalTxtTwo[1] = new Array();
		normalTxtTwo[1][0] = "Jump speed: ";
		normalTxtTwo[1][1] = "Amount of power lost at death: ";
		normalTxtTwo[1][2] = "Orb spawn rate: ";
		normalTxtTwo[1][3] = "N/A: ";
		normalTxtTwo[1][4] = "N/A: ";
		normalTxtTwo[1][5] = "N/A: ";

		normalTxtThree = new Array();
		for (i in 0...9) {
			normalTxtThree[i] = new Array();
		}

		normalTxtThree[0][0] = "Game Settings";

		normalTxtThree[1][0] = "Fast";
		normalTxtThree[1][1] = "Ludicrous";

		normalTxtThree[2][0] = "0";
		normalTxtThree[2][1] = "1";
		normalTxtThree[2][2] = "2";
		normalTxtThree[2][3] = "3";

		normalTxtThree[3][0] = "Normal";
		normalTxtThree[3][1] = "Fast";
		normalTxtThree[3][2] = "Ludicrous";

		for (i in 4...7) {
			normalTxtThree[i][0] = "N/A";
		}

		normalTxtThree[7][0] = "Save";
		normalTxtThree[8][0] = "Exit";

		/*xOptions = new Array();
		xOptions[0] = 1280;
		xOptions[1] = 1280;
		xOptions[2] = 1280;
		xOptions[3] = 1280;
		xOptions[4] = 1280;

		yOptions = new Array();
		yOptions[0] = 720;
		yOptions[1] = 720;
		yOptions[2] = 720;
		yOptions[3] = 720;
		yOptions[4] = 720;*/

		super();
	}

	public override function begin()
	{
		//_text:String, _x:Float, _y:Float, ?center:Bool, ?_size:Int, ?_font:String
		var titletxt = new MenuText("Options", 180, 20, true, 25, "font/Dretch.otf");
		add(titletxt);

		selectTxt = new Array();
		selectTxt[0] = new MenuText("Keyboard (P1)", 180, 40, true, 18, "font/Dretch.otf");
		selectTxt[1] = new MenuText(Key.nameOfKey(controlNum[focus][0]), 220, 50, true, 18, "font/Dretch.otf");
		selectTxt[2] = new MenuText(Key.nameOfKey(controlNum[focus][1]), 220, 60, true, 18, "font/Dretch.otf");
		selectTxt[3] = new MenuText(Key.nameOfKey(controlNum[focus][2]), 220, 70, true, 18, "font/Dretch.otf");
		selectTxt[4] = new MenuText(Key.nameOfKey(controlNum[focus][3]), 220, 80, true, 18, "font/Dretch.otf");
		selectTxt[5] = new MenuText(Key.nameOfKey(controlNum[focus][4]), 220, 90, true, 18, "font/Dretch.otf");
		selectTxt[6] = new MenuText(Key.nameOfKey(controlNum[focus][5]), 220, 100, true, 18, "font/Dretch.otf");
		selectTxt[7] = new MenuText("Save", 180, 110, true, 18, "font/Dretch.otf");
		selectTxt[8] = new MenuText("Exit", 180, 120, true, 18, "font/Dretch.otf");

		txt = new Array();
		txt[0] = new MenuText("Jump: ", 140, 50, true, 18, "font/Dretch.otf");
		txt[1] = new MenuText("Down: ", 140, 60, true, 18, "font/Dretch.otf");
		txt[2] = new MenuText("Left: ", 140, 70, true, 18, "font/Dretch.otf");
		txt[3] = new MenuText("Right: ", 140, 80, true, 18, "font/Dretch.otf");
		txt[4] = new MenuText("Attack: ", 140, 90, true, 18, "font/Dretch.otf");
		txt[5] = new MenuText("Extra: ", 140, 100, true, 18, "font/Dretch.otf");

		msg = new MenuText("", 180, 130, true, 18, "font/Dretch.otf");
		add(msg);

		for (i in 0...selectTxt.length) {
			add(selectTxt[i]);
		}

		for (i in 0...txt.length) {
			add(txt[i]);
		}

		if (HXP.fullscreen) {
			HXP.camera.x = Types._xPos;
			HXP.camera.y = Types._yPos;
		} else {
			HXP.camera.x = -20;
		}
	}

	public override function update() {
		normalTxt[0] = "Keyboard (P" + (focus + 1) + ")";
		normalTxt[1] = Key.nameOfKey(controlNum[focus][0]);
		normalTxt[2] = Key.nameOfKey(controlNum[focus][1]);
		normalTxt[3] = Key.nameOfKey(controlNum[focus][2]);
		normalTxt[4] = Key.nameOfKey(controlNum[focus][3]);
		normalTxt[5] = Key.nameOfKey(controlNum[focus][4]);
		normalTxt[6] = Key.nameOfKey(controlNum[focus][5]);

		/*for (i in 1...7) {
			normalTxtThree[i] = Std.string(controlNum[4][i-1]);
		}*/

		if (joystickTimer > 0) {
			joystickTimer -= 1;
		}

		if (focus < 4) {
			for (i in 0...selectTxt.length) {
				if (menuFocus == i) {
					if (focus == 0 && menuFocus == 0) {
						selectTxt[i].menuText.text = normalTxt[i] + " >";
					} else if (focus != 0 && menuFocus == 0) {
						selectTxt[i].menuText.text = "< " + normalTxt[i] + " >";
					} else {
						selectTxt[i].menuText.text = "> " + normalTxt[i] + " <";
					}
					selectTxt[i].menuText.centerOrigin();
				} else {
					selectTxt[i].menuText.text = normalTxt[i];
					selectTxt[i].menuText.centerOrigin();
				}
			}

			for (i in 0...txt.length) {
				txt[i].menuText.text = normalTxtTwo[0][i];
				txt[i].menuText.centerOrigin();
			} 
		} else if (focus == 4) {
			for (i in 0...selectTxt.length) {
				if (menuFocus == i) {
					if (menuFocus == 0) {
						selectTxt[i].menuText.text = "< " + normalTxtThree[i][0];
					} else if (menuFocus > 0 && menuFocus < 7) {
						if (controlNum[4][i-1] == 0) {
							selectTxt[i].menuText.text = normalTxtThree[i][controlNum[4][i-1]] + " >";
						} else if (controlNum[4][i-1] == maxNum[i-1]) {
							selectTxt[i].menuText.text = "< " + normalTxtThree[i][controlNum[4][i-1]];
						} else {
							selectTxt[i].menuText.text = "< " + normalTxtThree[i][controlNum[4][i-1]] + " >";
						}
					} else {
						selectTxt[i].menuText.text = "> " + normalTxtThree[i][0] + " <";
					}
					selectTxt[i].menuText.centerOrigin();
				} else {
					if (i == 0 || i > 6) {
						selectTxt[i].menuText.text = normalTxtThree[i][0];
						selectTxt[i].menuText.centerOrigin();
					} else {
						selectTxt[i].menuText.text = normalTxtThree[i][controlNum[4][i-1]];
						selectTxt[i].menuText.centerOrigin();
					}
				}
			}

			for (i in 0...txt.length) {
				txt[i].menuText.text = normalTxtTwo[1][i];
				txt[i].menuText.centerOrigin();
			} 
		}

		if (state == 0) {
			if (Input.pressed(Key.ESCAPE)) {
				HXP.scene = new TitleScreen();
			}

			if (Input.pressed(Key.DOWN)) {
				if (focus < 5) {
					if (menuFocus < 8) {
						menuFocus += 1;
					}
				}
			}

			if (Input.pressed(Key.UP)) {
				if (focus < 5) {
					if (menuFocus > 0) {
						menuFocus -= 1;
					}
				}
			}

			if (Input.pressed(Key.LEFT)) {
				if (menuFocus == 0) {
					if (focus > 0) {
						focus -= 1;
					}
				}

				if (focus == 4 && menuFocus > 0 && menuFocus < 7) {
					if (controlNum[4][menuFocus-1] > 0) {
						controlNum[4][menuFocus-1] -= 1;
					}
				}
			}

			if (Input.pressed(Key.RIGHT)) {
				if (menuFocus == 0) {
					if (focus < 4) {
						focus += 1;
					}
				}

				if (focus == 4 && menuFocus > 0 && menuFocus < 7) {
					if (controlNum[4][menuFocus-1] < maxNum[menuFocus-1]) {
						controlNum[4][menuFocus-1] += 1;
					}
				}
			}

			if (Input.pressed(Key.Z)) {
				if (focus < 4) {
					if (menuFocus > 0 && menuFocus < 7) {
						msg.menuText.text = "Press any key to change.";
						msg.menuText.centerOrigin();
						waitingOn.x = focus;
						waitingOn.y = menuFocus - 1;
						state = 1;
					}
				}

				if (menuFocus == 7) {
					saveSettings();
				} else if (menuFocus == 8) {
					HXP.scene = new TitleScreen();
				}
			}
		} else if (state == 1) {
			if (Input.pressed(Key.ANY)) {
				var alreadySet = false;
				for (i in 0...controlNum.length - 1) {
					for (j in 0...controlNum[i].length) {
						if (Input.lastKey == controlNum[i][j]) {
							alreadySet = true;
							break;
						}
					}

					if (alreadySet) {
						break;
					}
				}

				if (alreadySet) {
					msg.menuText.text = "Key already assigned elsewhere.";
					msg.menuText.centerOrigin();
					state = 0;
				} else {
					controlNum[Std.int(waitingOn.x)][Std.int(waitingOn.y)] = Input.lastKey;
					msg.menuText.text = "Key changed.";
					msg.menuText.centerOrigin();
					state = 0;
				}
			}
		}

		for (i in 0...4) {
#if (mac || linux)
			var xaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X);
			var yaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_Y);
#end
#if windows
			var xaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X);
			var yaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_Y);
#end
			if (Math.abs(xaxis) > Joystick.deadZone + 0.2) {
				if (joystickTimer <= 0) {
					if (xaxis < 0) {
						if (menuFocus == 0) {
							if (focus > 0) {
								focus -= 1;
							}
						} else if (menuFocus > 0 && menuFocus < 7) {
							if (focus == 4) {
								if (controlNum[4][menuFocus-1] > 0) {
									controlNum[4][menuFocus-1] -= 1;
								}
							}
						}
					} else if (xaxis > 0) {
						if (menuFocus == 0) {
							if (focus < 4) {
								focus += 1;
							}
						} else if (menuFocus > 0 && menuFocus < 7) {
							if (focus == 4) {
								if (controlNum[4][menuFocus-1] < maxNum[menuFocus-1]) {
									controlNum[4][menuFocus-1] += 1;
								}
							}
						}
					}
					joystickTimer = 15;
				}
			}

			if (Math.abs(yaxis) > Joystick.deadZone + 0.2) {
				if (joystickTimer <= 0) {
					if (yaxis < 0) {
						if (focus < 5) {
							if (menuFocus > 0) {
								menuFocus -= 1;
							}
						}
					} else if (yaxis > 0) {
						if (focus < 5) {
							if (menuFocus < 8) {
								menuFocus += 1;
							}
						}
					}
					joystickTimer = 15;
				}
			}

#if (mac || linux)
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.A_BUTTON)) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.A_BUTTON)) {
#end
				if (menuFocus == 7) {
					saveSettings();
				} else if (menuFocus == 8) {
					HXP.scene = new TitleScreen();
				}
			}

#if (mac || linux)
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.B_BUTTON)) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.B_BUTTON)) {
#end
				HXP.scene = new TitleScreen();
			}
		}
	}

	private function saveSettings() {
		var saveString = "<controls>\n";
		saveString += "	<!-- This setup file uses the key codes associated with each key.\n";
		saveString += "	Go to https://github.com/HaxePunk/HaxePunk/blob/master/com/haxepunk/utils/Key.hx\n";
		saveString += "	for a list of all key codes. -->\n";
		saveString += "	<players>\n";
		saveString += "		<pone up='" + controlNum[0][0] + "' down='" + controlNum[0][1] + "' left='" + controlNum[0][2] + "' right='" + controlNum[0][3] + "' hitone='" + controlNum[0][4] + "' hittwo='" + controlNum[0][5] + "' />\n";
		saveString += "		<ptwo up='" + controlNum[1][0] + "' down='" + controlNum[1][1] + "' left='" + controlNum[1][2] + "' right='" + controlNum[1][3] + "' hitone='" + controlNum[1][4] + "' hittwo='" + controlNum[1][5] + "' />\n";
		saveString += "		<pthree up='" + controlNum[2][0] + "' down='" + controlNum[2][1] + "' left='" + controlNum[2][2] + "' right='" + controlNum[2][3] + "' hitone='" + controlNum[2][4] + "' hittwo='" + controlNum[2][5] + "' />\n";
		saveString += "		<pfour up='" + controlNum[3][0] + "' down='" + controlNum[3][1] + "' left='" + controlNum[3][2] + "' right='" + controlNum[3][3] + "' hitone='" + controlNum[3][4] + "' hittwo='" + controlNum[3][5] + "' />\n";
		saveString += "	</players>\n";
		saveString += "\n";
		saveString += "	<jump option='" + controlNum[4][0] + "' />\n";
		saveString += "	<orb loss='" + controlNum[4][1] + "' rate='" + controlNum[4][2] + "'/>\n";
		saveString += "</controls>";

		var fname = "conf/controls.xml";
		var fout = sys.io.File.write(fname, false);
		fout.writeString(saveString);
		fout.close();

		msg.menuText.text = "Settings saved successfully.";
		msg.menuText.centerOrigin();
	}
}
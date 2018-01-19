import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import menu.MenuText;
import menu.PreviewImage;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.geom.Point;
import haxe.xml.Fast;
import com.haxepunk.utils.Joystick;
#if mac
import game.XBOX_GAMEPAD_MAC;
#end
#if windows
import game.XBOX_GAMEPAD_WIN;
#end

class OldGameSetup extends Scene
{
	private var textp1:MenuText;
	private var textp2:MenuText;
	private var textp3:MenuText;
	private var textp4:MenuText;
	private var level:Int;
	private var levelText:MenuText;
	private var p1:Bool;
	private var p2:Bool;
	private var p3:Bool;
	private var p4:Bool;
	private var levelFast:Fast;
	private var levelList:Array<String>;
	private var joysticks:Array<Int>;
	private var joystickTimer:Int;
	private var textp:Array<MenuText>;
	private var preview:PreviewImage;
	private var controlFast:Fast;
	private var p1control:Fast;
	private var p2control:Fast;
	private var p3control:Fast;
	private var p4control:Fast;
	private var focus:Int;
	private var mode:Int;
	private var modeSet:Int;
	private var modes:Array<String>;
	private var modeText:MenuText;
	private var modeSetText:MenuText;
	private var txt:Text;
	private var txt2:Text;

	//private var strttxt:StartText;

	public function new()
	{
		super();
	}

	public override function begin()
	{
		var dist = 240 / 5;
		focus = 0;
		level = 0;
		mode = 0;
		modeSet = 0;
		modes = new Array();
		modes[0] = "Deathmatch";
		modes[1] = "Timed Deathmatch";
		modes[2] = "King of the Hill";
		modes[3] = "Timed King of the Hill";
		joystickTimer = 15;

		p1 = false;
		p2 = false;
		p3 = false;
		p4 = false;

		textp = new Array();

		levelText = new MenuText(Std.string(level), 240, 120, true, null, "font/Dretch.otf");
		modeText = new MenuText(modes[0], 200, 153, false, null, "font/Dretch.otf");
		modeSetText = new MenuText(Std.string(modeSet), 200, 163, false, null, "font/Dretch.otf");

		var levelString = flash.Assets.getBytes("maps/levels.lvl");
		var levelXML = Xml.parse(levelString.toString());
		levelFast = new Fast(levelXML.firstElement());
		levelList = new Array();

		var i = 0;

		for (l in levelFast.nodes.level) {
			levelList[i] = l.att.name;
			i++;
		}

		var controlString = flash.Assets.getBytes("conf/controls.xml");
		var controlXML = Xml.parse(controlString.toString());
		controlFast = new Fast(controlXML.firstElement());
		var plyrcontrols = controlFast.node.players;
		p1control = plyrcontrols.node.pone;
		p2control = plyrcontrols.node.ptwo;
		p3control = plyrcontrols.node.pthree;
		p4control = plyrcontrols.node.pfour;

#if flash
		textp[0] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p1control.att.hitone)) + " or A on a gamepad to join.", 5, dist);
		textp[1] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p2control.att.hitone)) + " or A on a gamepad to join.", 5, dist * 2);
		textp[2] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p3control.att.hitone)) + " or A on a gamepad to join.", 5, dist * 3);
		textp[3] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p4control.att.hitone)) + " or A on a gamepad to join.", 5, dist * 4);
#else
		textp[0] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p1control.att.hitone)) + " or A on a gamepad to join.", 10, dist);
		textp[1] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p2control.att.hitone)) + " or A on a gamepad to join.", 10, dist * 2);
		textp[2] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p3control.att.hitone)) + " or A on a gamepad to join.", 10, dist * 3);
		textp[3] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p4control.att.hitone)) + " or A on a gamepad to join.", 10, dist * 4);
#end

		preview = new PreviewImage(200, 80, levelList[0]);

		levelText = new MenuText(levelList[0], 200, 60);
		joysticks = new Array();
		for (i in 0...4) {
			joysticks[i] = -1;
		}

		//add(textp1);
		//add(textp2);
		//add(textp3);
		//add(textp4);

		for (i in 0...textp.length) {
			add(textp[i]);
		}
		add(levelText);
		add(modeText);
		add(modeSetText);
		add(preview);

		txt = new Text("<", 195, 110);
		txt.size = 15;
		txt.font = "font/Dretch.otf";
		addGraphic(txt);
		txt2 = new Text(">", 281, 110);
		txt2.size = 15;
		txt2.font = "font/Dretch.otf";
		addGraphic(txt2);
	}

	public override function update()
	{
		if (joystickTimer > 0) {
			joystickTimer -= 1;
		}

		levelText.menuText.text = Std.string(levelList[level]);
		if (focus == 0) {
			txt.text = "<";
			txt2.text = ">";
			modeText.menuText.text = modes[mode];
			if (mode == 0 || mode == 2) {
				modeSetText.menuText.text = Std.string(modeSet) + " points";
			} else {
				modeSetText.menuText.text = Std.string(modeSet) + " minutes";
			}
		}
		else if (focus == 1 || focus == 2) {
			txt.text = "";
			txt2.text = "";
			if (focus == 1) {
				modeText.menuText.text = "< " + modes[mode] + " >";
				if (mode == 0 || mode == 2) {
					modeSetText.menuText.text = Std.string(modeSet) + " points";
				} else {
					modeSetText.menuText.text = Std.string(modeSet) + " minutes";
				}
			} else {
				modeText.menuText.text = modes[mode];
				if (mode == 0 || mode == 2) {
					modeSetText.menuText.text = "< " + Std.string(modeSet) + " points" + " >";
				} else {
					modeSetText.menuText.text = "< " + Std.string(modeSet) + " minutes" + " >";
				}
			}
		}

#if !flash
		for (i in 0...4) {
#end
#if mac
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.A_BUTTON)) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.A_BUTTON)) {
#end
#if !flash
				for (j in 0...joysticks.length) {
					if (joysticks[j] < 0) {
						if (!checkForI(joysticks, i)) {
							joysticks[j] = i;
							textp[j].menuText.text = "Ready. Press Start to start.";
							trace("player " + j + "= joystick " + i);
							break;
						}
					}
				}
			}
#end

#if mac
			var xaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X);
			var yaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_Y);
#end
#if windows
			var xaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X);
			var yaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_Y);
#end
#if !flash
			if (Math.abs(xaxis) > Joystick.deadZone + 0.2) {
				if (xaxis < 0 && joystickTimer <= 0) {
					if (focus == 0) {
						if (level > 0) {
							level -= 1;
							//levelText.menuText.text = Std.string(levelList[level]);
							preview.updateSprite(levelList[level]);
						}
					}
					else if (focus == 1) {
						if (mode > 0) {
							modeSet = 0;
							//modeText.menuText.text = modes[0];
							//modeSetText.menuText.text = Std.string(modeSet);
							mode -= 1;
						}
					}
					else if (focus == 2) {
						if (mode == 0) {
							if (modeSet > 0) {
								modeSet -= 5;
								//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
							}
						}
						else if (mode == 1) {
							if (modeSet > 0) {
								modeSet -= 1;
								//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
							}
						}
						else if (mode == 2) {
							if (modeSet > 0) {
								modeSet -= 10;
								//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
							}
						}
						else if (mode == 3) {
							if (modeSet > 0) {
								modeSet -= 1;
								//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
							}
						}
					}
					joystickTimer = 15;
				} else if (xaxis > 0  && joystickTimer <= 0) {
					if (focus == 0) {
						if (level < levelList.length - 1) {
							level += 1;
							//levelText.menuText.text = Std.string(levelList[level]);
							preview.updateSprite(levelList[level]);
						}
					}
					else if (focus == 1) {
						if (mode < 3) {
							modeSet = 0;
							//modeText.menuText.text = modes[mode + 1];
							//modeSetText.menuText.text = Std.string(modeSet);
							mode += 1;
						}
					}
					else if (focus == 2) {
						if (mode == 0) {
							if (modeSet < 50) {
								modeSet += 5;
								//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
							}
						}
						else if (mode == 1) {
							if (modeSet < 10) {
								modeSet += 1;
								//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
							}
						}
						else if (mode == 2) {
							if (modeSet < 100) {
								modeSet += 10;
								//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
							}
						}
						else if (mode == 3) {
							if (modeSet < 10) {
								modeSet += 1;
								//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
							}
						}
					}
					joystickTimer = 15;
				}
			}

			if (Math.abs(yaxis) > Joystick.deadZone + 0.2) {
				if (yaxis < 0 && joystickTimer <= 0) {
					if (focus > 0) {
						focus -= 1;
					}
					joystickTimer = 15;
				}
				else if (yaxis > 0 && joystickTimer <= 0) {
					if (focus < 2) {
						focus += 1;
					}
					joystickTimer = 15;
				}
			}
/*#end
#if mac
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.X_BUTTON)) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.X_BUTTON)) {
#end
#if !flash
				if (mode < 3) {
					modeSet = 0;
					modeText.menuText.text = modes[mode + 1];
					modeSetText.menuText.text = Std.string(modeSet);
					mode += 1;
				} else if (mode == 3) {
					modeSet = 0;
					modeText.menuText.text = modes[0];
					modeSetText.menuText.text = Std.string(modeSet);
					mode = 0;
				}
			}*/
		}
#end

		//if (Input.pressed(Key.A) || Input.pressed(Key.LEFT)) {
		if (Input.pressed(Std.parseInt(p1control.att.left)) || Input.pressed(Std.parseInt(p2control.att.left)) || Input.pressed(Std.parseInt(p3control.att.left)) || Input.pressed(Std.parseInt(p4control.att.left))) {
			if (focus == 0) {
				if (level > 0) {
					level -= 1;
					//levelText.menuText.text = Std.string(levelList[level]);
					preview.updateSprite(levelList[level]);
				}
			}
			else if (focus == 1) {
				if (mode > 0) {
					modeSet = 0;
					//modeText.menuText.text = modes[0];
					//modeSetText.menuText.text = Std.string(modeSet);
					mode -= 1;
				}
			}
			else if (focus == 2) {
				if (mode == 0) {
					if (modeSet > 0) {
						modeSet -= 5;
						//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
					}
				}
				else if (mode == 1) {
					if (modeSet > 0) {
						modeSet -= 1;
						//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
					}
				}
				else if (mode == 2) {
					if (modeSet > 0) {
						modeSet -= 10;
						//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
					}
				}
				else if (mode == 3) {
					if (modeSet > 0) {
						modeSet -= 1;
						//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
					}
				}
			}
		}

		//if (Input.pressed(Key.D) || Input.pressed(Key.RIGHT)) {
		if (Input.pressed(Std.parseInt(p1control.att.right)) || Input.pressed(Std.parseInt(p2control.att.right)) || Input.pressed(Std.parseInt(p3control.att.right)) || Input.pressed(Std.parseInt(p4control.att.right))) {
			if (focus == 0) {
				if (level < levelList.length - 1) {
					level += 1;
					//levelText.menuText.text = Std.string(levelList[level]);
					preview.updateSprite(levelList[level]);
				}
			}
			else if (focus == 1) {
				if (mode < 3) {
					modeSet = 0;
					//modeText.menuText.text = modes[mode + 1];
					//modeSetText.menuText.text = Std.string(modeSet);
					mode += 1;
				}
			}
			else if (focus == 2) {
				if (mode == 0) {
					if (modeSet < 50) {
						modeSet += 5;
						//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
					}
				}
				else if (mode == 1) {
					if (modeSet < 10) {
						modeSet += 1;
						//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
					}
				}
				else if (mode == 2) {
					if (modeSet < 100) {
						modeSet += 10;
						//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
					}
				}
				else if (mode == 3) {
					if (modeSet < 10) {
						modeSet += 1;
						//modeSetText.menuText.text = "< " + Std.string(modeSet) + " >";
					}
				}
			}
		}

		if (Input.pressed(Std.parseInt(p1control.att.up)) || Input.pressed(Std.parseInt(p2control.att.up)) || Input.pressed(Std.parseInt(p3control.att.up)) || Input.pressed(Std.parseInt(p4control.att.up))) {
			if (focus > 0) {
				focus -= 1;
			}
		}

		if (Input.pressed(Std.parseInt(p1control.att.down)) || Input.pressed(Std.parseInt(p2control.att.down)) || Input.pressed(Std.parseInt(p3control.att.down)) || Input.pressed(Std.parseInt(p4control.att.down))) {
			if (focus < 2) {
				focus += 1;
			}
		}

		if (Input.pressed(Std.parseInt(p1control.att.hittwo)) || Input.pressed(Std.parseInt(p2control.att.hittwo)) || Input.pressed(Std.parseInt(p3control.att.hittwo)) || Input.pressed(Std.parseInt(p4control.att.hittwo))) {
			/*if (mode < 3) {
				modeSet = 0;
				modeText.menuText.text = modes[mode + 1];
				modeSetText.menuText.text = Std.string(modeSet);
				mode += 1;
			} else if (mode == 3) {
				modeSet = 0;
				modeText.menuText.text = modes[0];
				modeSetText.menuText.text = Std.string(modeSet);
				mode = 0;
			}*/
		}
		//if (Input.pressed(Key.G)) {
		if (Input.pressed(Std.parseInt(p1control.att.hitone))) {
			textp[0].menuText.text = "Ready. Press Space to start.";
			joysticks[0] = 10;
		}

		//if (Input.pressed(Key.NUMPAD_0)) {
		if (Input.pressed(Std.parseInt(p2control.att.hitone))) {
			textp[1].menuText.text = "Ready. Press Space to start.";
			joysticks[1] = 10;
		}

		//if (Input.pressed(Key.LEFT_SQUARE_BRACKET)) {
		if (Input.pressed(Std.parseInt(p3control.att.hitone))) {
			textp[2].menuText.text = "Ready. Press Space to start.";
			joysticks[2] = 10;
		}

		//if (Input.pressed(Key.NUMPAD_ADD)) {
		if (Input.pressed(Std.parseInt(p4control.att.hitone))) {
			textp[3].menuText.text = "Ready. Press Space to start.";
			joysticks[3] = 10;
		}

		if (Input.pressed(Key.SPACE) && joysticks[0] != -1 && modeSet != 0) {
			//HXP.scene = new Loading(joysticks, levelList[level], mode, modeSet); 
				HXP.scene = new Level(joysticks, levelList[level], mode, modeSet); 
					//"subterranean", "tiles", 
					//new Point(0, 112), new Point(304, 112), new Point(304, 192), new Point(0, 192), 
					//new Point(16, 128), new Point(288, 128));
		}

#if !flash
		for (i in 0...joysticks.length) {
#end
#if mac
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.START_BUTTON) && joysticks[0] != -1 && modeSet != 0) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.START_BUTTON) && joysticks[0] != -1 && modeSet != 0) {
#end
#if !flash
				HXP.scene = new Level(joysticks, levelList[level], mode, modeSet);
				//HXP.scene = new Loading(joysticks, levelList[level], mode, modeSet); 
			}
		}
#end

	
	}

	private function checkForI(_arr:Array<Int>, _i:Int) {
		for (i in 0..._arr.length) {
			if (_arr[i] == _i) {
				return true;
			}
		}

		return false;
	}
}
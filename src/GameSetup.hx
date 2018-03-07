import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Spritemap;
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
import game.part.PowerEmitter;
#if (mac || linux)
import game.XBOX_GAMEPAD_MAC;
#end
#if windows
import game.XBOX_GAMEPAD_WIN;
#end

class GameSetup extends Scene
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
	private var preview2:PreviewImage;
	private var controlFast:Fast;
	private var p1control:Fast;
	private var p2control:Fast;
	private var p3control:Fast;
	private var p4control:Fast;
	private var focus:Int;
	private var mode:Int;
	private var modeSet:Int;
	private var modes:Array<String>;
	private var modeSetMax:Array<Int>;
	private var modeSetMult:Array<Int>;
	private var modeSetReal:Int;
	private var modeText:MenuText;
	private var modeSetText:MenuText;
	private var txt:MenuText;
	private var txt2:MenuText;
	private var menuFocus:Int;
	private var wizPre:Array<WizardPreview>;
	private var loadingText:MenuText;
	private var choice:Array<Int>;
	private var choiceSet:Array<Int>;
	private var joystickTimers:Array<Int>;
	private var leftArrow:Array<Text>;
	private var rightArrow:Array<Text>;
	private var wizName:Array<MenuText>;
	private var music:Sfx;
	private var brdr:Border;
	private var wizDescText:Array<String>;
	private var wizDesc:Array<MenuText>;
	private var previews:Array<WizardPreview>;
	private var playerSelect:Array<Spritemap>;
	private var flurries:Array<PowerEmitter>;

	//private var strttxt:StartText;

	public function new()
	{
		super();
	}

	public override function begin()
	{
		var dist = 240 / 5;
		focus = 0;
		menuFocus = 0;
		level = 0;
		mode = 0;
		modeSet = 0;
		modes = new Array();
		modes[0] = "Deathmatch";
		modes[1] = "Timed Deathmatch";
		modes[2] = "King of the Hill";
		modes[3] = "Timed King of the Hill";
		modes[4] = "Waves of Hordes of Monsters";

		modeSetMax = new Array();

		/*modeSetMax[0] = 50;
		modeSetMax[1] = 10;
		modeSetMax[2] = 100;
		modeSetMax[3] = 10;*/

		modeSetMax[0] = 9;
		modeSetMax[1] = 9;
		modeSetMax[2] = 9;
		modeSetMax[3] = 9;
		modeSetMax[4] = 5;

		modeSetMult = new Array();

		modeSetMult[0] = 5;
		modeSetMult[1] = 1;
		modeSetMult[2] = 10;
		modeSetMult[3] = 1;
		modeSetMult[4] = 5;

		modeSetReal = 0;

		joystickTimers = new Array();
		for (i in 0...4) {
			joystickTimers[i] = 15;
		}
		joystickTimer = 15;

		p1 = false;
		p2 = false;
		p3 = false;
		p4 = false;

		textp = new Array();
		wizPre = new Array();
		wizName = new Array();
		wizDesc = new Array();
		previews = new Array();

		wizDescText = new Array();
		wizDescText[0] = "Shoots a boulder at other wizards.";
		wizDescText[1] = "Summons a pillar of fire to defeat \n his opponents.";
		wizDescText[2] = "Freezes the level over.";
		wizDescText[3] = "Calls a lightning bolt from the sky.";
		wizDescText[4] = "Covers the level in barnacles, \n affecting others' movement.";
		wizDescText[5] = "Spawns orbs that orbit him before \n shooting off towards the nearest opponent.";
		wizDescText[6] = "Summons a cloud to fly around on.";
		wizDescText[7] = "Gains temporary super speed.";
		wizDescText[8] = "Covers the level in fog."; //"Causes the level to go dark temporarily.";
		wizDescText[9] = "Spawns a broom that goes back and \n forth across a platform."; //"Temporarily makes others invisible.";
		wizDescText[10] = "Can temporarily deflect shots \n back at others.";
		wizDescText[11] = "Raises the ocean, flooding \n part of the level.";
		wizDescText[12] = "Summons deadly peppermint sticks.";
		wizDescText[13] = "Calls a unicorn to attack other wizards.";
		wizDescText[14] = "Summons a sun to orbit around the level.";
		wizDescText[15] = "Lifts up his beard and stuns onlookers.";
		wizDescText[16] = "Inverts other players' controls.";
		wizDescText[17] = "Spawns a killer flower.";
		wizDescText[18] = "Gains temporary invincibility and \n can turn others to gold.";
		wizDescText[19] = "Spawns a mushroom that gives off \n poison spores if touched.";
		wizDescText[20] = "Sends a giant potato into the air \n that rains potatoes on nearby players.";
		wizDescText[21] = "Shoots bacon strips in 3 directions."; //"Spawns a broom that goes back and forth across a platform.";
		wizDescText[22] = "Launches an egg that covers 3 tiles \n in egg that stuns other players."; //"Shoots bacon strips in 3 directions.";
		wizDescText[23] = "Sends a shockwave across the platform he's standing on.";
		//wizDescText[23] = "Causes the level to go dark temporarily."; //"Launches an egg that covers 3 tiles in egg that stuns other players.";
		wizDescText[24] = "Temporarily makes himself invisible."; //"Covers the level in fog.";
		wizDescText[25] = "Summons a blackhole that pulls \n other players towards it.";
		wizDescText[26] = "Makes everyone else unable to \n fight temporarily.";
		wizDescText[27] = "Spawns a laser that creeps its \n way across the level."; //"Covers the level in fog.";
		wizDescText[28] = "Throws a cherry bomb at his opponents.";
		wizDescText[29] = "Throws a banana peel that his \n opponents slip on.";
		wizDescText[30] = "Spawns turrets to help him take \n his opponents down.";
		wizDescText[31] = "For the stream!";
		wizDescText[32] = "Uses another wizard's power at random.";
		wizDescText[33] = "Steals the power of the wizard \n he shot last.";

		for (i in 0...Types.types.length) {
			previews[i] = new WizardPreview(((i - (10 * Std.int(i/10))) * 16) + 106, (Std.int(i/10) * 20) + 80, Types.types[i]);
			previews[i].updateSprite(1);
			add(previews[i]);
		}

		choice = new Array();
		choice[0] = 0;
		choice[1] = 1;
		choice[2] = 2;
		choice[3] = 3;

		choiceSet = new Array();
		choiceSet[0] = -1;
		choiceSet[1] = -1;
		choiceSet[2] = -1;
		choiceSet[3] = -1;

		//levelText = new MenuText(Std.string(level), 240, 120, true, null, "font/Dretch.otf");
		modeText = new MenuText(modes[0], 900, 100, true, 15, "font/Dretch.otf", 1.25);
		modeSetText = new MenuText(Std.string(modeSet), 900, 140, true, 15, "font/Dretch.otf", 1.25);

		/*var levelString = openfl.Assets.getBytes("maps/levels.lvl");
		var levelXML = Xml.parse(levelString.toString());
		levelFast = new Fast(levelXML.firstElement());
		levelList = new Array();
		levelList[0] = "";

		var i = 0;

		for (l in levelFast.nodes.level) {
			levelList[i] = l.att.name;
			i++;
		}*/

		levelList = new Array();
		var levelFiles = sys.FileSystem.readDirectory("maps");
		var currentNum = 0;

		for (ff in levelFiles) {
			var ss = ff.substr(0, ff.length - 4);

			var found = false;
			for (i in 0...currentNum) {
				if (levelList[i] == ss) {
					found = true;
					break;
				}
			}

			if (!found) {
				levelList[currentNum] = ss;
				currentNum++;
			}
		}

		var controlString = openfl.Assets.getBytes("conf/controls.xml");
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
		/*textp[0] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p1control.att.hitone)) + " or A on a gamepad to join.", 10, dist);
		textp[1] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p2control.att.hitone)) + " or A on a gamepad to join.", 10, dist * 2);
		textp[2] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p3control.att.hitone)) + " or A on a gamepad to join.", 10, dist * 3);
		textp[3] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p4control.att.hitone)) + " or A on a gamepad to join.", 10, dist * 4);*/
		textp[0] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p1control.att.hitone)) + " or A on a gamepad to join.", 72, 230, true, 10, "font/Dretch.otf"); //90, 100
		textp[1] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p2control.att.hitone)) + " or A on a gamepad to join.", 144, 230, true, 10, "font/Dretch.otf"); //270, 100
		textp[2] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p3control.att.hitone)) + " or A on a gamepad to join.", 216, 230, true, 10, "font/Dretch.otf"); //90, 220
		textp[3] = new MenuText("Press " + Key.nameOfKey(Std.parseInt(p4control.att.hitone)) + " or A on a gamepad to join.", 288, 230, true, 10, "font/Dretch.otf"); //270, 220
		wizPre[0] = new WizardPreview(72, 200, "earth"); //90, 70
		wizPre[1] = new WizardPreview(144, 200, "fire"); //270, 70
		wizPre[2] = new WizardPreview(216, 200, "ice"); //90, 190
		wizPre[3] = new WizardPreview(288, 200, "lightning"); //270, 190

		wizName[0] = new MenuText("", 71, 215, true, 12, "font/Dretch.otf"); //89, 85
		wizName[1] = new MenuText("", 143, 215, true, 12, "font/Dretch.otf"); //269, 85
		wizName[2] = new MenuText("", 216, 215, true, 12, "font/Dretch.otf"); //89, 205
		wizName[3] = new MenuText("", 288, 215, true, 12, "font/Dretch.otf"); //269, 205

		wizDesc[0] = new MenuText("", 71, 220, true, 12, "font/Dretch.otf"); //89, 90
		wizDesc[1] = new MenuText("", 143, 220, true, 12, "font/Dretch.otf"); //269, 90
		wizDesc[2] = new MenuText("", 216, 220, true, 12, "font/Dretch.otf"); //89, 210
		wizDesc[3] = new MenuText("", 288, 220, true, 12, "font/Dretch.otf"); //269, 210
#end

		preview = new PreviewImage(500, 90, levelList[0]);

		preview2 = new PreviewImage(1220, 90, levelList[0]);

		loadingText = new MenuText("Loading...", 1260, 180, true, 15, "font/Dretch.otf", 1.25);

		levelText = new MenuText(levelList[0], 540, 180, true, 15, "font/Dretch.otf", 1.25);
		joysticks = new Array();
		for (i in 0...4) {
			joysticks[i] = -1;
		}

		playerSelect = new Array();

		for (i in 0...4) {
			playerSelect[i] = new Spritemap("gfx/playerselect.png", 16, 20);
			playerSelect[i].setFrame(i, 0);
			playerSelect[i].alpha = 0;
			playerSelect[i].layer = 0;
			addGraphic(playerSelect[i]);
		}

		flurries = new Array();

		for (i in 0...4) {
			flurries[i] = new PowerEmitter(Types.types[i]);
			flurries[i].layer = 0;
			//add(flurries[i]);
		}

		music = new Sfx("music/menu.ogg");

		//add(textp1);
		//add(textp2);
		//add(textp3);
		//add(textp4);

		for (i in 0...4) {
			add(textp[i]);
			add(wizPre[i]);
			add(wizName[i]);
			add(wizDesc[i]);
		}
		add(loadingText);
		add(levelText);
		add(modeText);
		add(modeSetText);
		add(preview);
		add(preview2);

		/*txt = new Text("<", 495, 120);
		txt.size = 15;
		txt.font = "font/Dretch.otf";
		addGraphic(txt);
		txt2 = new Text(">", 581, 120);
		txt2.size = 15;
		txt2.font = "font/Dretch.otf";
		addGraphic(txt2);*/

		txt = new MenuText("<", 496, 120, false, 15, "font/Dretch.otf");
		add(txt);

		txt2 = new MenuText(">", 581, 120, false, 15, "font/Dretch.otf");
		add(txt2);

		/*leftArrow = new Array();
		leftArrow[0] = new Text("<", 79, 70); //80, 70
		leftArrow[1] = new Text("<", 259, 70); //240, 70
		leftArrow[2] = new Text("<", 79, 190); //80, 190
		leftArrow[3] = new Text("<", 259, 190); //240, 190

		for (i in 0...leftArrow.length) {
			leftArrow[i].size = 15;
			leftArrow[i].font = "font/Dretch.otf";
			addGraphic(leftArrow[i]);
			leftArrow[i].text = "";
		}

		rightArrow = new Array();
		rightArrow[0] = new Text(">", 97, 70); //80, 70
		rightArrow[1] = new Text(">", 277, 70); //240, 70
		rightArrow[2] = new Text(">", 97, 190); //80, 190
		rightArrow[3] = new Text(">", 277, 190); //240, 190

		for (i in 0...rightArrow.length) {
			rightArrow[i].size = 15;
			rightArrow[i].font = "font/Dretch.otf";
			addGraphic(rightArrow[i]);
			rightArrow[i].text = "";
		}*/

		if (HXP.fullscreen) {
			HXP.camera.x = Types._xPos;
			HXP.camera.y = Types._yPos;
			brdr = new Border(0, 0);
			//add(brdr);
		}

		/*if (HXP.fullscreen) {
			brdr = new Border(0, 0);
			add(brdr);
		}*/

		//add(new Border(0, 0));

		music.loop();
	}

	public override function update()
	{
		modeSetReal = (modeSet + 1) * modeSetMult[mode];
		/*if (joystickTimer > 0) {
			joystickTimer -= 1;
		}*/

		for (i in 0...joystickTimers.length) {
			if (joystickTimers[i] > 0) {
				joystickTimers[i] -= 1;
			}
		}

		levelText.menuText.text = Std.string(levelList[level]);
		levelText.menuText.centerOrigin();

		if (!HXP.fullscreen) {
			if (HXP.camera.x < focus * 360) {
				HXP.camera.x += 5;
			} else if (HXP.camera.x > focus * 360) {
				HXP.camera.x -= 5;
			}
		} else {
			brdr.x = HXP.camera.x - 720;
			brdr.layer = -20;
			if (HXP.camera.x < focus * 360 + Types._xPos) {
				HXP.camera.x += 5;
			} else if (HXP.camera.x > focus * 360 + Types._xPos) {
				HXP.camera.x -= 5;
			}
		}

		if (focus == 1) {
			if (level == 0) {
				txt.menuText.text = "";
				txt2.menuText.text = ">";
			} else if (level == levelList.length - 1) {
				txt.menuText.text = "<";
				txt2.menuText.text = "";
			} else {
				txt.menuText.text = "<";
				txt2.menuText.text = ">";
			}
		}

		if (focus == 2) {
			var num = 0;
			for (i in 0...joysticks.length) {
				if (joysticks[i] >= 0) {
					num += 1;
				}
			}
			if (num == 1) {
				mode = 4;
			}

			if (menuFocus == 0) {
				if (mode == 0) {
					modeText.menuText.text = modes[mode] + " >";
					modeText.menuText.centerOrigin();
				} else if (mode == 4) {
					modeText.menuText.text = "< " + modes[mode];
					modeText.menuText.centerOrigin();
				} else {
					modeText.menuText.text = "< " + modes[mode] + " >";
					modeText.menuText.centerOrigin();
				}

				if (mode == 0 || mode == 2) {
					modeSetText.menuText.text = Std.string(modeSetReal) + " points";
					modeSetText.menuText.centerOrigin();
				} else if (mode == 1 || mode == 3) {
					modeSetText.menuText.text = Std.string(modeSetReal) + " minutes";
					modeSetText.menuText.centerOrigin();
				} else if (mode == 4) {
					modeSetText.menuText.text = Std.string(modeSetReal) + " second spawn interval";
					modeSetText.menuText.centerOrigin();
				}
			} else {
				modeText.menuText.text = modes[mode];
				modeText.menuText.centerOrigin();
				if (mode == 0 || mode == 2) {
					if (modeSet == 0) {
						modeSetText.menuText.text = Std.string(modeSetReal) + " points" + " >";
						modeSetText.menuText.centerOrigin();
					} else if (modeSet == modeSetMax[mode]) {
						modeSetText.menuText.text = "< " + Std.string(modeSetReal) + " points";
						modeSetText.menuText.centerOrigin();
					} else {
						modeSetText.menuText.text = "< " + Std.string(modeSetReal) + " points" + " >";
						modeSetText.menuText.centerOrigin();
					}
				} else if (mode == 1 || mode == 3) {
					if (modeSet == 0) {
						modeSetText.menuText.text = Std.string(modeSetReal) + " minutes" + " >";
						modeSetText.menuText.centerOrigin();
					} else if (modeSet == modeSetMax[mode]) {
						modeSetText.menuText.text = "< " + Std.string(modeSetReal) + " minutes";
						modeSetText.menuText.centerOrigin();
					} else {
						modeSetText.menuText.text = "< " + Std.string(modeSetReal) + " minutes" + " >";
						modeSetText.menuText.centerOrigin();
					}
				} else if (mode == 4) {
					if (modeSet == 0) {
						modeSetText.menuText.text = Std.string(modeSetReal) + " second spawn interval" + " >";
						modeSetText.menuText.centerOrigin();
					} else if (modeSet == modeSetMax[mode]) {
						modeSetText.menuText.text = "< " + Std.string(modeSetReal) + " second spawn interval";
						modeSetText.menuText.centerOrigin();
					} else {
						modeSetText.menuText.text = "< " + Std.string(modeSetReal) + " second spawn interval" + " >";
						modeSetText.menuText.centerOrigin();
					}
				}
			}
		}

		if (focus == 3) {
			if (!HXP.fullscreen) {
				if (HXP.camera.x == 360 * 3) {
					music.stop();
					HXP.scene = new Level(joysticks, levelList[level], mode, modeSetReal, choiceSet);
				}
			} else {
				if (HXP.camera.x == 360 * 3 + Types._xPos) {
					music.stop();
					HXP.scene = new Level(joysticks, levelList[level], mode, modeSetReal, choiceSet);
				}
			}
		}

		for (j in 0...Types.types.length) {
			if (checkForI(choiceSet, j)) {
				previews[j].updateSprite(0.5);
			} else {
				previews[j].updateSprite(1);
			}
		}

		for (i in 0...4) {

			playerSelect[i].x = previews[choice[i]].x - 8;
			playerSelect[i].y = previews[choice[i]].y - 10;
			playerSelect[i].alpha = (joysticks[i] >= 0) ? 1 : 0;

			if (checkForI(choiceSet, choice[i])) {
				if (joysticks[i] >= 0 && choiceSet[i] != choice[i]) {
					wizPre[i].updateSprite(0.5);
				}
			} else {
				if (joysticks[i] >= 0) {
					wizPre[i].updateSprite(1);
				}
			}

			if (joysticks[i] >= 0 && choiceSet[i] < 0) {
				/*if (choice[i] == 0) {
					leftArrow[i].text = "";
					rightArrow[i].text = ">";
				} else if (choice[i] == Types.types.length - 1) {
					leftArrow[i].text = "<";
					rightArrow[i].text = "";
				} else {
					leftArrow[i].text = "<";
					rightArrow[i].text = ">";
				}*/
				wizName[i].menuText.text = Types.types[choice[i]] + " wizard";
				wizName[i].menuText.centerOrigin();
				wizDesc[i].menuText.text = wizDescText[choice[i]];
				wizDesc[i].menuText.centerOrigin();
			} else {
				//leftArrow[i].text = "";
				//rightArrow[i].text = "";
				wizName[i].menuText.text = "";
				wizDesc[i].menuText.text = "";
			}
#if (mac || linux)
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.A_BUTTON)) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.A_BUTTON)) {
#end
				if (focus == 0) {
					/*if (checkForI(joysticks, i)) {
						if (choiceSet[i] == null) {
							if (!checkForI(choiceSet, choice[i]) {
								choiceSet[i] = choice[i];
								textp[j].menuText.text = "Player " + (i + 1) + " joined. Press A to choose a wizard.";
								textp[j].menuText.centerOrigin();
							}
						} else {
							menuFocus = 0;
							focus += 1;
						}
					}*/
					for (j in 0...joysticks.length) {
						if (joysticks[j] < 0) {
							if (!checkForI(joysticks, i)) {
								joysticks[j] = i;
								wizPre[j].updateSprite(1);
								textp[j].menuText.text = "Player " + (i + 1) + " joined. Press A to choose a wizard.";
								textp[j].menuText.centerOrigin();
								trace("player " + j + "= joystick " + i);
								break;
							}
						} else {
							if (joysticks[j] == i) {
								trace("correct joystick");
								if (choiceSet[j] < 0) {
									if (!checkForI(choiceSet, choice[j])) {
										trace("choiceSet[" + j + "] = -1");
										choiceSet[j] = choice[j];
										trace("choiceSet[" + j + "] = " + choice[j]);
										textp[j].menuText.text = "Player " + (i + 1) + " chose " + Types.types[choice[j]] + ". Press A to continue.";
										trace("player " + j + "= wizard " + Types.types[choice[j]]);
										textp[j].menuText.centerOrigin();
									}
								} else {
									var p = 0;
									for (o in 0...joysticks.length) {
										if (joysticks[o] > -1) {
											if (choiceSet[o] < 0) {
												p += 1;
											}
										}
									}

									if (p == 0) {
										menuFocus = 0;
										focus += 1;
									}
								}
							}
						}
					}
				} else if (focus == 1) {
					preview2.updateSprite(levelList[level]);
					menuFocus = 0;
					focus += 1;
				} else if (focus == 2) { //&& modeSet > 0) {
					menuFocus = 0;
					focus += 1;
				}
			}

#if (mac || linux)
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.X_BUTTON)) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.X_BUTTON)) {
#end
				if (focus == 0) {
					for (j in 0...joysticks.length) {
						if (joysticks[j] == i) {
							if (choiceSet[j] > -1) {
								trace("player " + j + " aka joystick " + i + " hit X");
								textp[j].menuText.text = "Player " + (i + 1) + " joined. Press A to choose a wizard.";
								textp[j].menuText.centerOrigin();
								choiceSet[j] -= 50;
							}
						}
					}
				}
				if (focus > 0 && focus < 3) {
					menuFocus = 0;
					focus -= 1;
				}
			}

#if (mac || linux)
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.B_BUTTON)) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.B_BUTTON)) {
#end
				music.stop();
				HXP.scene = new TitleScreen();
			}
			
#if (mac || linux)
			var xaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X);
			var yaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_Y);
#end
#if windows
			var xaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X);
			var yaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_Y);
#end
			if (Math.abs(xaxis) > Joystick.deadZone + 0.2) {
				if (xaxis < 0 && joystickTimers[i] <= 0) {
					if (focus == 0) {
						for (j in 0...joysticks.length) {
							if (joysticks[j] == i) {
								if (choice[j] > 0 && choiceSet[j] < 0) {
									trace("left");
									choice[j] -= 1;
									wizPre[j].updateImage(Types.types[choice[j]]);
									flurries[j].setSource(Types.types[choice[j]]);
									for (k in 0...10) {
										flurries[j].trail(wizPre[j].x + randomRange(-6, 6), wizPre[j].y + randomRange(-8, 8));
									}
									/*if (checkForI(choiceSet, choice[j])) {
										wizPre[j].updateSprite(0.5);
									} else {
										wizPre[j].updateSprite(1);
									}*/
								}
							}
						}
					}
					if (focus == 1) {
						if (menuFocus == 0) {
							if (level > 0) {
								level -= 1;
								preview.updateSprite(levelList[level]);
							}
						}
					}
					else if (focus == 2) {
						if (menuFocus == 0) {
							if (mode > 0) {
								modeSet = 0;
								mode -= 1;
							}
						} else if (menuFocus == 1) {
							/*if (mode == 0) {
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
							}*/
							if (modeSet > 0) {
								modeSet -= 1;
							}
						}
					}
					joystickTimers[i] = 15;
				} else if (xaxis > 0  && joystickTimers[i] <= 0) {
					if (focus == 0) {
						for (j in 0...joysticks.length) {
							if (joysticks[j] == i) {
								if (choice[j] < Types.types.length - 1 && choiceSet[j] < 0) {
									trace("right");
									choice[j] += 1;
									wizPre[j].updateImage(Types.types[choice[j]]);
									flurries[j].setSource(Types.types[choice[j]]);
									for (k in 0...10) {
										flurries[j].trail(wizPre[j].x + randomRange(-6, 6), wizPre[j].y + randomRange(-8, 8));
									}
									/*if (checkForI(choiceSet, choice[j])) {
										wizPre[j].updateSprite(0.5);
									} else {
										wizPre[j].updateSprite(1);
									}*/
								}
							}
						}
					}
					if (focus == 1) {
						if (menuFocus == 0) {
							if (level < levelList.length - 1) {
								level += 1;
								preview.updateSprite(levelList[level]);
							}
						}
					}
					else if (focus == 2) {
						if (menuFocus == 0) {
							if (mode < 4) {
								modeSet = 0;
								mode += 1;
							}
						} else if (menuFocus == 1) {
							/*if (mode == 0) {
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
							}*/
							if (modeSet < modeSetMax[mode]) {
								modeSet += 1;
							}
						}
					}
					joystickTimers[i] = 15;
				}
			}

			if (Math.abs(yaxis) > Joystick.deadZone + 0.2) {
				if (yaxis < 0 && joystickTimers[i] <= 0) {
					if (focus == 0) {
						for (j in 0...joysticks.length) {
							if (joysticks[j] == i) {
								if (choice[j] >= 10 && choiceSet[j] < 0) {
									choice[j] -= 10;
									wizPre[j].updateImage(Types.types[choice[j]]);
									flurries[j].setSource(Types.types[choice[j]]);
									for (k in 0...10) {
										flurries[j].trail(wizPre[j].x + randomRange(-6, 6), wizPre[j].y + randomRange(-8, 8));
									}
								}
							}
						}
						joystickTimers[i] = 15;
					}
					if (focus == 2) {
						if (menuFocus > 0) {
							menuFocus -= 1;
						}
						joystickTimers[i] = 15;
					}
				}
				else if (yaxis > 0 && joystickTimers[i] <= 0) {
					if (focus == 0) {
						for (j in 0...joysticks.length) {
							if (joysticks[j] == i) {
								if (choice[j] < Types.types.length - 10 && choiceSet[j] < 0) {
									choice[j] += 10;
									wizPre[j].updateImage(Types.types[choice[j]]);
									flurries[j].setSource(Types.types[choice[j]]);
									for (k in 0...10) {
										flurries[j].trail(wizPre[j].x + randomRange(-6, 6), wizPre[j].y + randomRange(-8, 8));
									}
								}
							}
						}
						joystickTimers[i] = 15;
					}
					if (focus == 2) {
						if (menuFocus < 1) {
							menuFocus += 1;
						}
						joystickTimers[i] = 15;
					}
				}
			}
		}

		if (Input.pressed(Key.Z)) {
			if (focus == 0) {
				var p = 0;
				var j = 0;
				for (o in 0...joysticks.length) {
					if (joysticks[o] > -1) {
						j += 1;
						if (choiceSet[o] < 0) {
							p += 1;
						}
					}
				}

				if (p == 0 && j > 0) {
					menuFocus = 0;
					focus += 1;
				}
			} else if (focus == 1) {
				preview2.updateSprite(levelList[level]);
				menuFocus = 0;
				focus += 1;
			} else if (focus == 2) { //&& modeSet > 0) {
				menuFocus = 0;
				focus += 1;
			}
		}

		if (Input.pressed(Key.LEFT)) {
			if (focus == 1) {
				if (level > 0) {
					level -= 1;
					//levelText.menuText.text = Std.string(levelList[level]);
					preview.updateSprite(levelList[level]);
				}
			} else if (focus == 2) {
				if (menuFocus == 0) {
					if (mode > 0) {
						modeSet = 0;
						mode -= 1;
					}
				} else if (menuFocus == 1) {
					/*if (mode == 0) {
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
					}*/
					if (modeSet > 0) {
						modeSet -= 1;
					}
				}
			}
		}

		if (Input.pressed(Key.RIGHT)) {
			if (focus == 1) {
				if (level < levelList.length - 1) {
					level += 1;
					//levelText.menuText.text = Std.string(levelList[level]);
					preview.updateSprite(levelList[level]);
				}
			} else if (focus == 2) {
				if (menuFocus == 0) {
					if (mode < 4) {
						modeSet = 0;
						mode += 1;
					}
				} else if (menuFocus == 1) {
					/*if (mode == 0) {
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
					}*/
					if (modeSet < modeSetMax[mode]) {
						modeSet += 1;
					}
				}
			}
		}

		if (Input.pressed(Key.UP)) {
			if (menuFocus > 0) {
				menuFocus -= 1;
			}
		}

		if (Input.pressed(Key.DOWN)) {
			if (menuFocus < 1) {
				menuFocus += 1;
			}
		}

		if (Input.pressed(Key.X)) {
			if (focus < 3 && focus > 0) {
				focus -= 1;
			}
		}

		if (Input.pressed(Std.parseInt(p1control.att.hitone)) || Input.pressed(Std.parseInt(p2control.att.hitone)) || Input.pressed(Std.parseInt(p3control.att.hitone)) || Input.pressed(Std.parseInt(p4control.att.hitone))) {
			if (focus == 0) {
				if (Input.pressed(Std.parseInt(p1control.att.hitone))) {
					if (joysticks[0] < 0) {
						wizPre[0].updateSprite(1);
						textp[0].menuText.text = "Joined. Use " + Key.nameOfKey(Std.parseInt(p1control.att.left)) + "/" + Key.nameOfKey(Std.parseInt(p1control.att.right)) + " and " + Key.nameOfKey(Std.parseInt(p1control.att.hitone)) + " to choose a wizard.";
						textp[0].menuText.centerOrigin();
						joysticks[0] = 10;
					} else {
						if (joysticks[0] == 10) {
							trace("correct joystick");
							if (choiceSet[0] < 0) {
								if (!checkForI(choiceSet, choice[0])) {
									choiceSet[0] = choice[0];
									//textp[0].menuText.text = "Chose " + Types.types[choice[0]] + ". Press " + Key.nameOfKey(Std.parseInt(p1control.att.hitone)) + " to continue.";
									textp[0].menuText.text = "Chose " + Types.types[choice[0]] + ". Press Z to continue.";
									textp[0].menuText.centerOrigin();
								}
							} else {
								var p = 0;
								for (o in 0...joysticks.length) {
									if (joysticks[o] > -1) {
										if (choiceSet[o] < 0) {
											p += 1;
										}
									}
								}

								/*if (p == 0) {
									menuFocus = 0;
									focus += 1;
								}*/
							}
						}
					}
				}

				if (Input.pressed(Std.parseInt(p2control.att.hitone))) {
					if (joysticks[1] < 1) {
						wizPre[1].updateSprite(1);
						textp[1].menuText.text = "Joined. Use " + Key.nameOfKey(Std.parseInt(p2control.att.left)) + "/" + Key.nameOfKey(Std.parseInt(p2control.att.right)) + " and " + Key.nameOfKey(Std.parseInt(p2control.att.hitone)) + " to choose a wizard.";
						textp[1].menuText.centerOrigin();
						joysticks[1] = 10;
					} else {
						if (joysticks[1] == 10) {
							trace("correct joystick");
							if (choiceSet[1] < 0) {
								if (!checkForI(choiceSet, choice[1])) {
									choiceSet[1] = choice[1];
									textp[1].menuText.text = "Chose " + Types.types[choice[1]] + ". Press Z to continue.";
									textp[1].menuText.centerOrigin();
								}
							} else {
								var p = 0;
								for (o in 0...joysticks.length) {
									if (joysticks[o] > -1) {
										if (choiceSet[o] < 0) {
											p += 1;
										}
									}
								}

								/*if (p == 0) {
									menuFocus = 0;
									focus += 1;
								}*/
							}
						}
					}
				}

				//if (Input.pressed(Key.LEFT_SQUARE_BRACKET)) {
				if (Input.pressed(Std.parseInt(p3control.att.hitone))) {
					if (joysticks[2] < 0) {
						wizPre[2].updateSprite(1);
						textp[2].menuText.text = "Joined. Use " + Key.nameOfKey(Std.parseInt(p3control.att.left)) + "/" + Key.nameOfKey(Std.parseInt(p3control.att.right)) + " and " + Key.nameOfKey(Std.parseInt(p3control.att.hitone)) + " to choose a wizard.";
						textp[2].menuText.centerOrigin();
						joysticks[2] = 10;
					} else {
						if (joysticks[2] == 10) {
							trace("correct joystick");
							if (choiceSet[2] < 0) {
								if (!checkForI(choiceSet, choice[2])) {
									choiceSet[2] = choice[2];
									textp[2].menuText.text = "Chose " + Types.types[choice[2]] + ". Press Z to continue.";
									textp[2].menuText.centerOrigin();
								}
							} else {
								var p = 0;
								for (o in 0...joysticks.length) {
									if (joysticks[o] > -1) {
										if (choiceSet[o] < 0) {
											p += 1;
										}
									}
								}

								/*if (p == 0) {
									menuFocus = 0;
									focus += 1;
								}*/
							}
						}
					}
				}

				//if (Input.pressed(Key.NUMPAD_ADD)) {
				if (Input.pressed(Std.parseInt(p4control.att.hitone))) {
					if (joysticks[3] < 0) {
						wizPre[3].updateSprite(1);
						textp[3].menuText.text = "Joined. Use " + Key.nameOfKey(Std.parseInt(p4control.att.left)) + "/" + Key.nameOfKey(Std.parseInt(p4control.att.right)) + " and " + Key.nameOfKey(Std.parseInt(p4control.att.hitone)) + " to choose a wizard.";
						textp[3].menuText.centerOrigin();
						joysticks[3] = 10;
					} else {
						if (joysticks[3] == 10) {
							trace("correct joystick");
							if (choiceSet[3] < 0) {
								if (!checkForI(choiceSet, choice[3])) {
									choiceSet[3] = choice[3];
									textp[3].menuText.text = "Chose " + Types.types[choice[3]] + ". Press Z to continue.";
									textp[3].menuText.centerOrigin();
								}
							} else {
								var p = 0;
								for (o in 0...joysticks.length) {
									if (joysticks[o] > -1) {
										if (choiceSet[o] < 0) {
											p += 1;
										}
									}
								}

								/*if (p == 0) {
									menuFocus = 0;
									focus += 1;
								}*/
							}
						}
					}
				}
			}/* else if (focus == 1) {
				preview2.updateSprite(levelList[level]);
				menuFocus = 0;
				focus += 1;
			} else if (focus == 2 && modeSet > 0) {
				menuFocus = 0;
				focus += 1;
			}*/
		}

		if (Input.pressed(Std.parseInt(p1control.att.hittwo)) || Input.pressed(Std.parseInt(p2control.att.hittwo)) || Input.pressed(Std.parseInt(p3control.att.hittwo)) || Input.pressed(Std.parseInt(p4control.att.hittwo))) {
			if (focus == 0) {
				if (Input.pressed(Std.parseInt(p1control.att.hittwo))) {
					if (joysticks[0] == 10) {
						if (choiceSet[0] > -1) {
							textp[0].menuText.text = "Joined. Use " + Key.nameOfKey(Std.parseInt(p1control.att.left)) + "/" + Key.nameOfKey(Std.parseInt(p1control.att.right)) + " and " + Key.nameOfKey(Std.parseInt(p1control.att.hitone)) + " to choose a wizard.";
							textp[0].menuText.centerOrigin();
							choiceSet[0] -= 50;
						}
					}
				}

				if (Input.pressed(Std.parseInt(p2control.att.hittwo))) {
					if (joysticks[1] == 10) {
						if (choiceSet[1] > -1) {
							textp[1].menuText.text = "Joined. Use " + Key.nameOfKey(Std.parseInt(p2control.att.left)) + "/" + Key.nameOfKey(Std.parseInt(p2control.att.right)) + " and " + Key.nameOfKey(Std.parseInt(p2control.att.hitone)) + " to choose a wizard.";
							textp[1].menuText.centerOrigin();
							choiceSet[1] -= 50;
						}
					}
				}

				if (Input.pressed(Std.parseInt(p3control.att.hittwo))) {
					if (joysticks[2] == 10) {
						if (choiceSet[2] > -1) {
							textp[2].menuText.text = "Joined. Use " + Key.nameOfKey(Std.parseInt(p3control.att.left)) + "/" + Key.nameOfKey(Std.parseInt(p3control.att.right)) + " and " + Key.nameOfKey(Std.parseInt(p3control.att.hitone)) + " to choose a wizard.";
							textp[2].menuText.centerOrigin();
							choiceSet[2] -= 50;
						}
					}
				}

				if (Input.pressed(Std.parseInt(p4control.att.hittwo))) {
					if (joysticks[3] == 10) {
						if (choiceSet[3] > -1) {
							textp[3].menuText.text = "Joined. Use " + Key.nameOfKey(Std.parseInt(p4control.att.left)) + "/" + Key.nameOfKey(Std.parseInt(p4control.att.right)) + " and " + Key.nameOfKey(Std.parseInt(p4control.att.hitone)) + " to choose a wizard.";
							textp[3].menuText.centerOrigin();
							choiceSet[3] -= 50;
						}
					}
				}
			}

			/*if (focus < 3 && focus > 0) {
				focus -= 1;
			}*/
		}

		if (Input.pressed(Std.parseInt(p1control.att.left)) || Input.pressed(Std.parseInt(p2control.att.left)) || Input.pressed(Std.parseInt(p3control.att.left)) || Input.pressed(Std.parseInt(p4control.att.left))) {
			if (focus == 0) {
				if (Input.pressed(Std.parseInt(p1control.att.left))) {
					if (joysticks[0] == 10) {
						if (choice[0] > 0 && choiceSet[0] < 0) {
							choice[0] -= 1;
							wizPre[0].updateImage(Types.types[choice[0]]);
							if (checkForI(choiceSet, choice[0])) {
								wizPre[0].updateSprite(0.5);
							} else {
								wizPre[0].updateSprite(1);
							}
						}
					}
				}
				if (Input.pressed(Std.parseInt(p2control.att.left))) {
					if (joysticks[1] == 10) {
						if (choice[1] > 0 && choiceSet[1] < 0) {
							choice[1] -= 1;
							wizPre[1].updateImage(Types.types[choice[1]]);
							if (checkForI(choiceSet, choice[1])) {
								wizPre[1].updateSprite(0.5);
							} else {
								wizPre[1].updateSprite(1);
							}
						}
					}
				}
				if (Input.pressed(Std.parseInt(p3control.att.left))) {
					if (joysticks[2] == 10) {
						if (choice[2] > 0 && choiceSet[2] < 0) {
							choice[2] -= 1;
							wizPre[2].updateImage(Types.types[choice[2]]);
							if (checkForI(choiceSet, choice[2])) {
								wizPre[2].updateSprite(0.5);
							} else {
								wizPre[2].updateSprite(1);
							}
						}
					}
				}
				if (Input.pressed(Std.parseInt(p4control.att.left))) {
					if (joysticks[3] == 10) {
						if (choice[3] > 0 && choiceSet[3] < 0) {
							choice[3] -= 1;
							wizPre[3].updateImage(Types.types[choice[3]]);
							if (checkForI(choiceSet, choice[3])) {
								wizPre[3].updateSprite(0.5);
							} else {
								wizPre[3].updateSprite(1);
							}
						}
					}
				}
			}

			/*if (focus == 1) {
				if (level > 0) {
					level -= 1;
					//levelText.menuText.text = Std.string(levelList[level]);
					preview.updateSprite(levelList[level]);
				}
			} else if (focus == 2) {
				if (menuFocus == 0) {
					if (mode > 0) {
						modeSet = 0;
						mode -= 1;
					}
				} else if (menuFocus == 1) {
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
			}*/
		}

		if (Input.pressed(Std.parseInt(p1control.att.right)) || Input.pressed(Std.parseInt(p2control.att.right)) || Input.pressed(Std.parseInt(p3control.att.right)) || Input.pressed(Std.parseInt(p4control.att.right))) {
			if (focus == 0) {
				if (Input.pressed(Std.parseInt(p1control.att.right))) {
					if (joysticks[0] == 10) {
						if (choice[0] < Types.types.length - 1 && choiceSet[0] < 0) {
							choice[0] += 1;
							wizPre[0].updateImage(Types.types[choice[0]]);
							if (checkForI(choiceSet, choice[0])) {
								wizPre[0].updateSprite(0.5);
							} else {
								wizPre[0].updateSprite(1);
							}
						}
					}
				}
				if (Input.pressed(Std.parseInt(p2control.att.right))) {
					if (joysticks[1] == 10) {
						if (choice[1] < Types.types.length - 1 && choiceSet[1] < 0) {
							choice[1] += 1;
							wizPre[1].updateImage(Types.types[choice[1]]);
							if (checkForI(choiceSet, choice[1])) {
								wizPre[1].updateSprite(0.5);
							} else {
								wizPre[1].updateSprite(1);
							}
						}
					}
				}
				if (Input.pressed(Std.parseInt(p3control.att.right))) {
					if (joysticks[2] == 10) {
						if (choice[2] < Types.types.length - 1 && choiceSet[2] < 0) {
							choice[2] += 1;
							wizPre[2].updateImage(Types.types[choice[2]]);
							if (checkForI(choiceSet, choice[2])) {
								wizPre[2].updateSprite(0.5);
							} else {
								wizPre[2].updateSprite(1);
							}
						}
					}
				}
				if (Input.pressed(Std.parseInt(p4control.att.right))) {
					if (joysticks[3] == 10) {
						if (choice[3] < Types.types.length - 1 && choiceSet[3] < 0) {
							choice[3]+= 1;
							wizPre[3].updateImage(Types.types[choice[3]]);
							if (checkForI(choiceSet, choice[3])) {
								wizPre[3].updateSprite(0.5);
							} else {
								wizPre[3].updateSprite(1);
							}
						}
					}
				}
			}

			/*if (focus == 1) {
				if (level < levelList.length - 1) {
					level += 1;
					//levelText.menuText.text = Std.string(levelList[level]);
					preview.updateSprite(levelList[level]);
				}
			} else if (focus == 2) {
				if (menuFocus == 0) {
					if (mode < 3) {
						modeSet = 0;
						mode += 1;
					}
				} else if (menuFocus == 1) {
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
			}*/
		}

		if (Input.pressed(Std.parseInt(p1control.att.up)) || Input.pressed(Std.parseInt(p2control.att.up)) || Input.pressed(Std.parseInt(p3control.att.up)) || Input.pressed(Std.parseInt(p4control.att.up))) {
			if (focus == 0) {
				if (Input.pressed(Std.parseInt(p1control.att.up)) && choiceSet[0] < 0 && joysticks[0] > 0) {
					if (choice[0] >= 10) {
						choice[0] -= 10;
						wizPre[0].updateImage(Types.types[choice[0]]);
						if (checkForI(choiceSet, choice[0])) {
							wizPre[0].updateSprite(0.5);
						} else {
							wizPre[0].updateSprite(1);
						}
					}
				}

				if (Input.pressed(Std.parseInt(p2control.att.up)) && choiceSet[1] < 0 && joysticks[1] > 0) {
					if (choice[1] >= 10) {
						choice[1] -= 10;
						wizPre[1].updateImage(Types.types[choice[1]]);
						if (checkForI(choiceSet, choice[1])) {
							wizPre[1].updateSprite(0.5);
						} else {
							wizPre[1].updateSprite(1);
						}
					}
				}

				if (Input.pressed(Std.parseInt(p3control.att.up)) && choiceSet[2] < 0 && joysticks[2] > 0) {
					if (choice[2] >= 10) {
						choice[2] -= 10;
						wizPre[2].updateImage(Types.types[choice[2]]);
						if (checkForI(choiceSet, choice[2])) {
							wizPre[2].updateSprite(0.5);
						} else {
							wizPre[2].updateSprite(1);
						}
					}
				}

				if (Input.pressed(Std.parseInt(p4control.att.up)) && choiceSet[3] < 0 && joysticks[3] > 0) {
					if (choice[3] >= 10) {
						choice[3] -= 10;
						wizPre[3].updateImage(Types.types[choice[3]]);
						if (checkForI(choiceSet, choice[3])) {
							wizPre[3].updateSprite(0.5);
						} else {
							wizPre[3].updateSprite(1);
						}
					}
				}
			}
		}

		if (Input.pressed(Std.parseInt(p1control.att.down)) || Input.pressed(Std.parseInt(p2control.att.down)) || Input.pressed(Std.parseInt(p3control.att.down)) || Input.pressed(Std.parseInt(p4control.att.down))) {
			if (focus == 0) {
				if (Input.pressed(Std.parseInt(p1control.att.down)) && choiceSet[0] < 0 && joysticks[0] > 0) {
					if (choice[0] < Types.types.length - 10) {
						choice[0] += 10;
						wizPre[0].updateImage(Types.types[choice[0]]);
						if (checkForI(choiceSet, choice[0])) {
							wizPre[0].updateSprite(0.5);
						} else {
							wizPre[0].updateSprite(1);
						}
					}
				}
				if (Input.pressed(Std.parseInt(p2control.att.down)) && choiceSet[1] < 0 && joysticks[1] > 0) {
					if (choice[1] < Types.types.length - 10) {
						choice[1] += 10;
						wizPre[1].updateImage(Types.types[choice[1]]);
						if (checkForI(choiceSet, choice[1])) {
							wizPre[1].updateSprite(0.5);
						} else {
							wizPre[1].updateSprite(1);
						}
					}
				}

				if (Input.pressed(Std.parseInt(p3control.att.down)) && choiceSet[2] < 0 && joysticks[2] > 0) {
					if (choice[2] < Types.types.length - 10) {
						choice[2] += 10;
						wizPre[2].updateImage(Types.types[choice[2]]);
						if (checkForI(choiceSet, choice[2])) {
							wizPre[2].updateSprite(0.5);
						} else {
							wizPre[2].updateSprite(1);
						}
					}
				}

				if (Input.pressed(Std.parseInt(p4control.att.down)) && choiceSet[3] < 0 && joysticks[3] > 0) {
					if (choice[3] < Types.types.length - 10) {
						choice[3] += 10;
						wizPre[3].updateImage(Types.types[choice[3]]);
						if (checkForI(choiceSet, choice[3])) {
							wizPre[3].updateSprite(0.5);
						} else {
							wizPre[3].updateSprite(1);
						}
					}
				}
			}
		}

		if (Input.pressed(Key.ESCAPE)) {
			music.stop();
			HXP.scene = new TitleScreen();
		}
		
	}

	private function checkForI(_arr:Array<Int>, _i:Int) {
		for (i in 0..._arr.length) {
			if (_arr[i] == _i) {
				return true;
			}
		}

		return false;
	}

	private function randomRange(min:Int, max:Int) {
		return min + (Math.random() * ((max - min) + 1));
	}
}
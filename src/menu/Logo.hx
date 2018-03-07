package menu;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Joystick;
import com.haxepunk.Sfx;
import haxe.xml.Fast;
import game.Types;
import flash.display.StageDisplayState;
import flash.geom.Rectangle;
#if (mac || linux)
import game.XBOX_GAMEPAD_MAC;
#end
#if windows
import game.XBOX_GAMEPAD_WIN;
#end

class Logo extends Entity
{
	private var sprite:Spritemap;
	private var spawn:Int = 0;
	private var mainText:MenuText;
	private var activated:Bool;
	private var focus:Int;
	private var controlFast:Fast;
	private var controls:Array<Fast>;
	private var joystickTimer:Int;
	private var music:Sfx;

	public function new(x:Float, y:Float)
	{
		super(x, y);

		activated = false;
		focus = 0;
		joystickTimer = 0;

		controls = new Array();
		var controlString = openfl.Assets.getBytes("conf/controls.xml");
		var controlXML = Xml.parse(controlString.toString());
		controlFast = new Fast(controlXML.firstElement());
		var plyrcontrols = controlFast.node.players;
		controls[0] = plyrcontrols.node.pone;
		controls[1] = plyrcontrols.node.ptwo;
		controls[2] = plyrcontrols.node.pthree;
		controls[3] = plyrcontrols.node.pfour;
		music = new Sfx("music/title4.ogg");

		sprite = new Spritemap("gfx/logo2.png", 108, 158);
		sprite.centerOrigin();
		sprite.scale = 0;
		graphic = sprite;
		layer = 4;
		sprite.scale = 0;
		music.loop();
	}
	override public function update()
	{
		if (joystickTimer > 0) {
			joystickTimer -= 1;
		}

		if (sprite.scale <= 1) {
			sprite.scale += 0.02;
			graphic = sprite;
		}
		
		if (sprite.scale >= 1 && spawn == 0) {
			mainText = new MenuText("Press Z or Start on a gamepad to start", 180, 200, true, 15, "font/Dretch.otf");
			scene.add(mainText);
			var txt = new Text("Copyright 2013 Another Day, Another Game");
			txt.font = "font/Dretch.otf";
			txt.x = 0;
			txt.y = 235;
			scene.addGraphic(txt);
			/*var txt = new Text("Programming, design and environment art by Matt Chelen");
			txt.font = "font/Dretch.otf";
			txt.x = 0;
			txt.y = 225;
			scene.addGraphic(txt);
			txt = new Text("Character design, game design, and art by Katarina Klick");
			txt.font = "font/Dretch.otf";
			txt.x = 0;
			txt.y = 230;
			scene.addGraphic(txt);
			txt = new Text("Music by Jordan Oakley");
			txt.font = "font/Dretch.otf";
			txt.x = 0;
			txt.y = 235;
			scene.addGraphic(txt);*/
			var alphatxt = new MenuText("Beta build 1", 332, 235, false, 10, "font/Dretch.otf");
			scene.add(alphatxt);

			spawn += 1;
		}

		if (activated) {
			if (focus == 0) {
				mainText.menuText.text = "Start game >";
				mainText.menuText.centerOrigin();
			} else if (focus == 1) {
				mainText.menuText.text = "< Options >";
				mainText.menuText.centerOrigin();
			} else if (focus == 2) {
				mainText.menuText.text = "< How to play >";
				mainText.menuText.centerOrigin();
			} else if (focus == 3) {
				mainText.menuText.text = "< Profiles >";
				mainText.menuText.centerOrigin();
			} else if (focus == 4) {
				mainText.menuText.text = "< Credits";
				mainText.menuText.centerOrigin();
			}
		}

		if (spawn == 1) {
			if (Input.pressed(Key.Z)) {
				if (!activated) {
					//var text = new MenuText("Use " + Key.nameOfKey(Std.parseInt(controls[0].att.left)) + "/" + Key.nameOfKey(Std.parseInt(controls[0].att.right)) + " and " + Key.nameOfKey(Std.parseInt(controls[0].att.hitone)) + " to select an option.", 180, 220, true, 10, "font/Dretch.otf");
					var text = new MenuText("Use the arrow keys and Z to select an option.", 180, 220, true, 10, "font/Dretch.otf");
					scene.add(text);
					activated = true;
				} else if (activated) {
					if (focus == 0) {
						music.stop();
						HXP.scene = new GameSetup();
					} else if (focus == 1) {
						music.stop();
						HXP.scene = new Options();
					} else if (focus == 2) {
						music.stop();
						HXP.scene = new HowTo();
					} else if (focus == 3) {
						music.stop();
						HXP.scene = new Profiles();
					} else if (focus == 4) {
						music.stop();
						HXP.scene = new Credits();
					}
				}
			}

			if (Input.pressed(Key.LEFT)) {
				if (focus > 0) {
					focus -= 1;
				}
			}

			if (Input.pressed(Key.RIGHT)) {
				if (focus < 4) {
					focus += 1;
				}
			}

			for (i in 0...4) {
#if (mac || linux)
				if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.START_BUTTON)) {
#end
#if windows
				if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.START_BUTTON)) {
#end
					if (!activated) {
						activated = true;
					}			
				}

#if (mac || linux)
				var xaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X);
#end
#if windows
				var xaxis = Input.joystick(i).getAxis(XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X);
#end
				if (Math.abs(xaxis) > Joystick.deadZone + 0.2) {
					if (joystickTimer <= 0) {
						if (xaxis < 0) {
							if (focus > 0) {
								focus -= 1;
							}
						} else if (xaxis > 0) {
							if (focus < 2) {
								focus += 1;
							}
						}
						joystickTimer = 15;
					}
				}

				/*if (Input.pressed(Std.parseInt(controls[i].att.left))) {
					if (focus > 0) {
						focus -= 1;
					}
				}

				if (Input.pressed(Std.parseInt(controls[i].att.right))) {
					if (focus < 2) {
						focus += 1;
					}
				}*/

#if (mac || linux)
				if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.A_BUTTON) || Input.pressed(Std.parseInt(controls[i].att.hitone))) {
#end
#if windows
				if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.A_BUTTON) || Input.pressed(Std.parseInt(controls[i].att.hitone))) {
#end
					if (activated) {
						if (focus == 0) {
							music.stop();
							HXP.scene = new GameSetup();
						} else if (focus == 1) {
							music.stop();
							HXP.scene = new Options();
						} else if (focus == 2) {
							music.stop();
							HXP.scene = new HowTo();
						} else if (focus == 3) {
							music.stop();
							HXP.scene = new Profiles();
						} else if (focus == 4) {
							music.stop();
							//HXP.scene = new Credits();
						}
					}
				}
			}
		}

		if (Input.pressed(Key.ESCAPE)) {
			flash.system.System.exit(0);
		}

		super.update();
	}

	private function resizeScreen(_w:Int, _h:Int) {
		HXP.screen.scale = 1;

		var scaleFactor = Math.floor(_h / 240);

		var marginx = (_w / 2) - ((HXP.screen.width * scaleFactor) / 2);
		var marginy = (_h / 2) - ((HXP.screen.height * scaleFactor) / 2);

		HXP.fullscreen = true;
	}
}
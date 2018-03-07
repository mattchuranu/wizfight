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
#if (mac || linux)
import game.XBOX_GAMEPAD_MAC;
#end
#if windows
import game.XBOX_GAMEPAD_WIN;
#end

class Profiles extends Scene
{
	private var joystickTimer:Int;
	private var previews:Array<WizardPreview>;
	private var largePreview:WizardPreview;
	private var selection:Int;
	private var selectionBox:Image;
	private var focus:Int;
	private var nameText:MenuText;
	private var profileText:MenuText;
	private var profileTexts:Array<String>;
	private var powerText:MenuText;
	private var powerTexts:Array<String>;
	private var brdr:Border;
	private var reqByTexts:Array<String>;
	private var reqByText:MenuText;
	private var keysText:MenuText;

	public function new()
	{
		super();
	}

	override public function begin()
	{
		joystickTimer = 0;

		selection = 0;
		focus = 0;

		previews = new Array();

		var title = new MenuText("Profiles", 180, 20, true, 25, "font/Dretch.otf");
		add(title);

		for (i in 0...Types.types.length) {
			previews[i] = new WizardPreview(((i - (10 * Std.int(i/10))) * 16) + 106, (Std.int(i/10) * 20) + 40, Types.types[i]);
			previews[i].updateSprite(1);
			add(previews[i]);
		}

		largePreview = new WizardPreview(100, 320, Types.types[selection]);
		largePreview.updateSprite(1);
		largePreview.updateScale(4);
		add(largePreview);

		keysText = new MenuText("Z/A to select. X to go back.", 180, 220, true, 15, "font/Dretch.otf");
		add(keysText);

		//(_text:String, _x:Float, _y:Float, ?center:Bool, ?_size:Int, ?_font:String)
		nameText = new MenuText(Types.types[selection] + " wizard", 180, 280, true, 25, "font/Dretch.otf");
		add(nameText);

		reqByTexts = new Array();

		reqByTexts[0] = "N/A";
		reqByTexts[1] = "N/A";
		reqByTexts[2] = "N/A";
		reqByTexts[3] = "N/A";
		reqByTexts[4] = "N/A";
		reqByTexts[5] = "N/A";
		reqByTexts[6] = "N/A";
		reqByTexts[7] = "N/A";
		reqByTexts[8] = "N/A";
		reqByTexts[9] = "N/A";
		reqByTexts[10] = "N/A";
		reqByTexts[11] = "N/A";
		reqByTexts[12] = "N/A";
		reqByTexts[13] = "N/A";
		reqByTexts[14] = "N/A";
		reqByTexts[15] = "N/A";
		reqByTexts[16] = "N/A";
		reqByTexts[17] = "N/A";
		reqByTexts[18] = "N/A";
		reqByTexts[19] = "N/A";
		reqByTexts[20] = "N/A";
		reqByTexts[21] = "@BaconBoy95";
		reqByTexts[22] = "N/A";
		reqByTexts[23] = "N/A";
		reqByTexts[24] = "N/A";
		reqByTexts[25] = "N/A";
		reqByTexts[26] = "N/A";
		reqByTexts[27] = "N/A";
		reqByTexts[28] = "N/A";
		reqByTexts[29] = "N/A";
		reqByTexts[30] = "Character belongs to @eigenbom";
		reqByTexts[31] = "N/A";
		reqByTexts[32] = "N/A";
		reqByTexts[33] = "N/A";

		reqByText = new MenuText("Requested by: " + reqByTexts[selection], 140, 290, false, 15, "font/Dretch.otf");
		add(reqByText);

		powerTexts = new Array();

		powerTexts[0] = "Shoots a boulder at other wizards.";
		powerTexts[1] = "Summons a pillar of fire to defeat his opponents.";
		powerTexts[2] = "Freezes the level over.";
		powerTexts[3] = "Calls a lightning bolt from the sky.";
		powerTexts[4] = "Covers the level in barnacles, affecting others' movement.";
		powerTexts[5] = "Spawns orbs that orbit him before shooting off in random directions.";
		powerTexts[6] = "Summons a cloud to fly around on.";
		powerTexts[7] = "Gains temporary super speed.";
		powerTexts[8] = "Covers the level in fog.";
		powerTexts[9] = "Spawns a broom that goes back and forth across a platform.";
		powerTexts[10] = "Can temporarily deflect shots back at others.";
		powerTexts[11] = "Raises the ocean, flooding part of the level.";
		powerTexts[12] = "Summons deadly peppermint sticks in the direction he's facing.";
		powerTexts[13] = "Calls a unicorn to attack other wizards.";
		powerTexts[14] = "Summons a sun to orbit around the level.";
		powerTexts[15] = "Lifts up his beard and stuns onlookers.";
		powerTexts[16] = "Inverts other players' controls.";
		powerTexts[17] = "Spawns a killer flower.";
		powerTexts[18] = "Gains temporary invincibility and can turn others to gold.";
		powerTexts[19] = "Spawns a mushroom that gives off poison spores if touched.";
		powerTexts[20] = "Sends a giant potato into the air that rains potatoes on nearby players.";
		powerTexts[21] = "Shoots bacon strips in 3 directions.";
		powerTexts[22] = "Launches an egg that covers 3 tiles in egg that stuns other players.";
		powerTexts[23] = "Sends a shockwave across the platform he's standing on.";
		powerTexts[24] = "Temporarily makes himself invisible.";
		powerTexts[25] = "Summons a blackhole that pulls other players towards it.";
		powerTexts[26] = "Makes everyone else unable to fight temporarily.";
		powerTexts[27] = "Spawns a laser that creeps its way across the level."; //"Covers the level in fog.";
		powerTexts[28] = "Throws a cherry bomb at his opponents.";
		powerTexts[29] = "Throws a banana peel that his opponents slip on.";
		powerTexts[30] = "Spawns turrets to help him take his opponents down.";
		powerTexts[31] = "Just a joke.";
		powerTexts[32] = "Uses another wizard's power at random.";
		powerTexts[33] = "Steals the power of the wizard he shot last.";

		powerText = new MenuText("Power: " + powerTexts[selection], 140, 300, false, 15, "font/Dretch.otf");
		add(powerText);

		selectionBox = new Image("gfx/selectionbox.png");
		addGraphic(selectionBox);

		if (HXP.fullscreen) {
			HXP.camera.x = Types._xPos;
			HXP.camera.y = Types._yPos;
			brdr = new Border(0, 0);
			//add(brdr);
		}
	}

	override public function update()
	{
		if (joystickTimer > 0) {
			joystickTimer -= 1;
		}

		if (Input.pressed(Key.ESCAPE)) {
			HXP.scene = new TitleScreen();	
		}

		if (HXP.fullscreen) {
			if (HXP.camera.y < Types._yPos + (240 * focus)) {
				HXP.camera.y += 5;
			} else if (HXP.camera.y > Types._yPos + (240 * focus)) {
				HXP.camera.y -= 5;
			}
			brdr.y = HXP.camera.y - 405;
			brdr.layer = -20;
		} else {
			if (HXP.camera.y < 240 * focus) {
				HXP.camera.y += 5;
			} else if (HXP.camera.y > 240 * focus) {
				HXP.camera.y -= 5;
			}
		}

		selectionBox.x = previews[selection].x - 8;
		selectionBox.y = previews[selection].y - 10;

		largePreview.updateImage(Types.types[selection]);
		largePreview.updateScale(4);

		nameText.menuText.text = Types.types[selection] + " wizard";
		nameText.menuText.centerOrigin();

		reqByText.menuText.text = "Designed by: " + reqByTexts[selection];
		powerText.menuText.text = "Power: " + powerTexts[selection];

		if (focus == 0) {
			if (Input.pressed(Key.UP)) {
				if (selection >= 10) {
					selection -= 10;
				}
			}

			if (Input.pressed(Key.DOWN)) {
				if (selection <= Types.types.length - 11) {
					selection += 10;
				}
			}

			if (Input.pressed(Key.LEFT)) {
				if (selection > 0) {
					selection -= 1;
				}
			}

			if (Input.pressed(Key.RIGHT)) {
				if (selection < Types.types.length - 1) {
					selection += 1;
				}
			}
		}

		for (i in 0...4) {
			if (focus == 0) {
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
							if (selection > 0) {
								selection -= 1;
							}
						} else if (xaxis > 0) {
							if (selection < Types.types.length - 1) {
								selection += 1;
							}
						}
						joystickTimer = 15;
					}
				}

				if (Math.abs(yaxis) > Joystick.deadZone + 0.2) {
					if (joystickTimer <= 0) {
						if (yaxis < 0) {
							if (selection >= 10) {
								selection -= 10;
							}
						} else if (yaxis > 0) {
							if (selection <= Types.types.length - 11) {
								selection += 10;
							}
						}
						joystickTimer = 15;
					}
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
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.A_BUTTON) || Input.pressed(Key.Z)) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.A_BUTTON) || Input.pressed(Key.Z)) {
#end
				if (focus < 1) {
					focus += 1;
				}
			}

#if (mac || linux)
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.X_BUTTON) || Input.pressed(Key.X)) {
#end
#if windows
			if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.X_BUTTON) || Input.pressed(Key.X)) {
#end
				var scrY:Float = 0;

				if (HXP.fullscreen) {
					scrY = Types._yPos;
				}

				if (focus == 0 && HXP.camera.y == scrY) {
					HXP.scene = new TitleScreen();
				} else if (focus == 1) {
					focus -= 1;
				}
			}
		}

	}
}
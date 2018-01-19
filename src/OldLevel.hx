import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
//import com.haxepunk.blur.BlurCanvas;
//import com.haxepunk.blur.BlurWrapper;
//import com.haxepunk.blur.BlurredGraphic;
//import com.haxepunk.blur.MotionBlur;
//import com.haxepunk.bloom.BloomLighting;
//import com.haxepunk.bloom.BloomWrapper;
import com.haxepunk.graphics.Image;
import flash.geom.Point;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Key;
import com.haxepunk.Sfx;
import menu.MenuText;
import menu.WizardPreview;
import menu.TextBackground;
import game.Player;
import game.SpawnPoint;
import game.Lava;
import game.BoundPlatform;
import game.Hill;
import game.Trap;
import game.RandomTrap;
import game.Scores;
import game.ScoreText;
import game.Types;
import game.Sidebar;
import game.Border;
import game.part.DeathEmitter;
import game.part.SpawnEmitter;
import game.part.GroundEmitter;
import game.part.LavaEmitter;
import game.part.TrailEmitter;
import game.part.ShakeEmitter;
import game.part.LaserEmitter;
import game.part.RollEmitter;
import game.part.PufferEmitter;
import game.part.Emitters;
#if mac
import game.XBOX_GAMEPAD_MAC;
#end
#if windows
import game.XBOX_GAMEPAD_WIN;
#end
import haxe.xml.Fast;

class OldLevel extends Scene
{
	private var e:TmxEntity;
	private var timer:Int;
	private var p1:Player;
	private var p2:Player;
	private var p3:Player;
	private var p4:Player;
	private var s1:SpawnPoint;
	private var s2:SpawnPoint;
	private var s3:SpawnPoint;
	private var s4:SpawnPoint;
	private var l1:Lava;
	private var l2:Lava;
	//private var _blur:BlurCanvas;
	//private var _bloom:BloomLighting;
	private var _blur:Int;
	private var _bloom:Int;
	private var levelFast:Fast;
	private var controlFast:Fast;
	private var p1control:Fast;
	private var p2control:Fast;
	private var p3control:Fast;
	private var p4control:Fast;
	private var mode:Int;
	private var scoreSet:Int;
	private var gameOver:Bool;
	private var winner:Int;
	//private var types:Array<String>;
	private var goalText:MenuText;
	private var goalText2:MenuText;
	private var goalText3:MenuText;
	private var goalText4:MenuText;
	private var sidebarLeft:Sidebar;
	private var sidebarRight:Sidebar;
	private var fpsText:MenuText;
	private var musicLoop:Sfx;
	private var choice:Array<Int>;
	private var winSnd:Sfx;
	//private var spawnPoints:Array<SpawnPoint>;

	//public function new(_p1:Bool, _p2:Bool, _p3:Bool, _p4:Bool, _map:String, _tile:String, _s1:Point, _s2:Point, _s3:Point, _s4:Point)
	//public function new(_p1:Bool, _p2:Bool, _p3:Bool, _p4:Bool, _map:String) //, _tile:String, _s1:Point, _s2:Point, ?_s3:Point, ?_s4:Point, ?_l1:Point, ?_l2:Point)
	public function new(_control:Array<Int>, _map:String, ?_mode:Int, ?_modeSet:Int, ?_choice:Array<Int>)//, ?music:Sfx)
	{
		var levelString = openfl.Assets.getBytes("maps/" + _map + ".lvl");
		var levelXML = Xml.parse(levelString.toString());
		levelFast = new Fast(levelXML.firstElement());

		var tileset = _map;
		var music = _map;
		winSnd = new Sfx("music/win.ogg");

		if (levelFast.hasNode.overrides) {
			var over = levelFast.node.overrides;
			if (over.hasNode.tiles) {
				var tiles = over.node.tiles;
				tileset = tiles.att.name;
			}
			if (over.hasNode.music) {
				var mu = over.node.music;
				music = mu.att.name;
			}
			if (over.hasNode.win) {
				var wn = over.node.win;
				winSnd = new Sfx("music/" + wn.att.name + "_win.ogg");
			}
		}

		e = new TmxEntity("maps/" + _map + ".tmx");
		e.loadGraphic("gfx/tiles/" + tileset + ".png", ["back", "front"]);
		e.loadMask("collision", "solid");

		musicLoop = new Sfx("music/" + music + ".ogg");
		//musicLoop = music;

		sidebarLeft = new Sidebar(-20, 0, "all");
		sidebarRight = new Sidebar(320, 0, "all");
		sidebarRight.sprite.flipped = true;

		mode = _mode;
		Scores.MODE = mode;
		choice = _choice;

		if (mode == 0 || mode == 2) {
			scoreSet = _modeSet;
			//if (_control[0] > 0 || _control[2] > 0) {
				goalText = new MenuText(Std.string(_modeSet), -10, 118, true, 10, "font/Dretch.otf");
				goalText3 = new MenuText("points", -10, 122, true, 10, "font/Dretch.otf");
			/*} else {
				goalText = new MenuText("", 0, 0);
				goalText3 = new MenuText("", 0, 0);
			}*/

			//if (_control[1] > 0 || _control[3] > 0) {
				goalText2 = new MenuText(Std.string(_modeSet), 330, 118, true, 10, "font/Dretch.otf");
				goalText4 = new MenuText("points", 330, 122, true, 10, "font/Dretch.otf");
			/*} else {
				goalText2 = new MenuText("", 0, 0);
				goalText4 = new MenuText("", 0, 0);
			}*/
			
			//goalText = new MenuText(Std.string(_modeSet) + " points", 160, 2, true, null, "font/Dretch.otf");
		} else if (mode == 1 || mode == 3) {
			timer = _modeSet * 3600;
			//if (_control[0] > 0 || _control[2] > 0) {
				goalText = new MenuText(Std.string(timer / 60), -10, 118, true, 10, "font/Dretch.otf");
				goalText3 = new MenuText("seconds", -10, 122, true, 9, "font/Dretch.otf");
			/*} else {
				goalText = new MenuText("", 0, 0);
				goalText3 = new MenuText("", 0, 0);
			}*/

			//if (_control[1] > 0 || _control[3] > 0) {
				goalText2 = new MenuText(Std.string(timer / 60), 330, 118, true, 10, "font/Dretch.otf");
				goalText4 = new MenuText("seconds", 330, 122, true, 9, "font/Dretch.otf");
			/*} else {
				goalText2 = new MenuText("", 0, 0);
				goalText4 = new MenuText("", 0, 0);
			}*/

			//goalText = new MenuText(Std.string(timer / 60) + "\n" + " seconds left", 160, 2, true, null, "font/Dretch.otf"); 
		}

		gameOver = false;
		winner = 10;

		fpsText = new MenuText(Std.string(HXP.frameRate), 0, 0);

		var spawnArray = new Array();
		//spawnPoints = new Array();
		var spawnPts = levelFast.node.spawns;
		var count = 0;

		for (s in spawnPts.nodes.spawn) {
			spawnArray[count] = new Point(Std.parseInt(s.att.x), Std.parseInt(s.att.y));
			//spawnPoints[count] = new SpawnPoint(Std.parseInt(s.att.x), Std.parseInt(s.att.y));
			trace(spawnArray[count].x);
			count++;
		}

		var controlString = openfl.Assets.getBytes("conf/controls.xml");
		var controlXML = Xml.parse(controlString.toString());
		controlFast = new Fast(controlXML.firstElement());
		var plyrcontrols = controlFast.node.players;
		p1control = plyrcontrols.node.pone;
		p2control = plyrcontrols.node.ptwo;
		p3control = plyrcontrols.node.pthree;
		p4control = plyrcontrols.node.pfour;

		/*s1 = new SpawnPoint(_s1.x, _s1.y);
		s2 = new SpawnPoint(_s2.x, _s2.y);
		s3 = new SpawnPoint(_s3.x, _s3.y);
		s4 = new SpawnPoint(_s4.x, _s4.y);

		if (_l1 != null) {
			l1 = new Lava(_l1.x, _l1.y);
		}

		if (_l2 != null) {
			l2 = new Lava(_l2.x, _l2.y);
		}*/

		//_blur = new BlurCanvas(0.6);
		//_blur.layer = 1;

		//_bloom = new BloomLighting(15.0, 2); 
		//_bloom.layer = 0;

		_blur = 1;
		_bloom = 1;

		Emitters.DEATHEMITTER = new DeathEmitter("all");
		Emitters.SPAWNEMITTER = new SpawnEmitter();
		Emitters.LAVAEMITTER = new LavaEmitter();
		Emitters.SHAKEEMITTER = new ShakeEmitter(tileset);

		Emitters.GROUNDEMITTERS = new Array();
		Emitters.TRAILEMITTERS = new Array();
		/*Emitters.GROUNDEMITTERS[0] = new GroundEmitter("all");
		Emitters.GROUNDEMITTERS[1] = new GroundEmitter("all");
		Emitters.GROUNDEMITTERS[2] = new GroundEmitter("all");
		Emitters.GROUNDEMITTERS[3] = new GroundEmitter("all");*/

		Scores.SCORES = new Array();
		for (c in 0...choice.length) {
			Scores.SCORES[choice[c]] = 0;
		}

		Scores.SCORETEXTS = new Array();
		Scores.WIZPREVIEW = new Array();

		//types = new Array();
		//types[0] = "Earth";
		//types[1] = "Fire";
		//types[2] = "Ice";
		//types[3] = "Lightning";

		if (_control[0] >= 0) {
			Emitters.GROUNDEMITTERS[choice[0]] = new GroundEmitter("all");
			Emitters.TRAILEMITTERS[choice[0]] = new TrailEmitter(Types.types[choice[0]]);
			//Scores.SCORETEXTS[choice[0]] = new ScoreText(HXP.screen.width / 5, 0, choice[0], Types.colors[choice[0]], null, null, "font/Dretch.otf");
			Scores.SCORETEXTS[choice[0]] = new ScoreText(-10, 60, choice[0], null, true, 12, "font/Dretch.otf");
			Scores.WIZPREVIEW[0] = new WizardPreview(-10, 40, Types.types[choice[0]]);
			Scores.WIZPREVIEW[0].updateSprite(1); 

			if (_control[0] == 10) {
				/*p1 = new Player(spawnArray[0].x, spawnArray[0].y, "earth", 
					Key.W, Key.S, Key.A, Key.D, Key.G, Key.H, _blur);*/
				p1 = new Player(spawnArray[0].x, spawnArray[0].y, Types.types[choice[0]], 
					Std.parseInt(p1control.att.up), Std.parseInt(p1control.att.down), Std.parseInt(p1control.att.left), Std.parseInt(p1control.att.right), 
					Std.parseInt(p1control.att.hitone), Std.parseInt(p1control.att.hittwo), _blur);
			} else {
#if mac
				p1 = new Player(spawnArray[0].x, spawnArray[0].y, Types.types[choice[0]], 
					XBOX_GAMEPAD_MAC.A_BUTTON, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_Y, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X, XBOX_GAMEPAD_MAC.X_BUTTON, XBOX_GAMEPAD_MAC.Y_BUTTON, 
					_blur, Input.joystick(_control[0]));
#end
#if windows
				p1 = new Player(spawnArray[0].x, spawnArray[0].y, Types.types[choice[0]], 
					XBOX_GAMEPAD_WIN.A_BUTTON, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_Y, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X, XBOX_GAMEPAD_WIN.X_BUTTON, XBOX_GAMEPAD_WIN.Y_BUTTON, 
					_blur, Input.joystick(_control[0]));
#end
			}
		}

		if (_control[1] >= 0) {
			var n = spawnArray.length - 3;
			Emitters.GROUNDEMITTERS[choice[1]] = new GroundEmitter("all");
			Emitters.TRAILEMITTERS[choice[1]] = new TrailEmitter(Types.types[choice[1]]);
			//Scores.SCORETEXTS[choice[1]] = new ScoreText((HXP.screen.width / 5) * 2, 0, choice[1], Types.colors[choice[1]], null, null, "font/Dretch.otf");
			Scores.SCORETEXTS[choice[1]] = new ScoreText(330, 60, choice[1], null, true, 12, "font/Dretch.otf");
			Scores.WIZPREVIEW[1] = new WizardPreview(330, 40, Types.types[choice[1]]); 
			Scores.WIZPREVIEW[1].sprite.flipped = true; 
			Scores.WIZPREVIEW[1].updateSprite(1);

			for (i in 0...spawnArray.length) {
				if (spawnArray[n] != null) {
					if (_control[1] == 10) {
						/*p2 = new Player(spawnArray[n].x, spawnArray[n].y, "fire", 
							Key.UP, Key.DOWN, Key.LEFT, Key.RIGHT, Key.NUMPAD_0, Key.NUMPAD_DECIMAL, _blur);*/
						p2 = new Player(spawnArray[n].x, spawnArray[n].y, Types.types[choice[1]], 
							Std.parseInt(p2control.att.up), Std.parseInt(p2control.att.down), Std.parseInt(p2control.att.left), Std.parseInt(p2control.att.right), 
							Std.parseInt(p2control.att.hitone), Std.parseInt(p2control.att.hittwo), _blur);
					} else {
#if mac
						p2 = new Player(spawnArray[n].x, spawnArray[n].y, Types.types[choice[1]], 
							XBOX_GAMEPAD_MAC.A_BUTTON, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_Y, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X, XBOX_GAMEPAD_MAC.X_BUTTON, XBOX_GAMEPAD_MAC.Y_BUTTON, 
							_blur, Input.joystick(_control[1]));
#end
#if windows
						p2 = new Player(spawnArray[n].x, spawnArray[n].y, Types.types[choice[1]], 
							XBOX_GAMEPAD_WIN.A_BUTTON, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_Y, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X, XBOX_GAMEPAD_WIN.X_BUTTON, XBOX_GAMEPAD_WIN.Y_BUTTON, 
							_blur, Input.joystick(_control[1]));
#end
					}
					break;
				}
				n--;
			}
		}

		if (_control[2] >= 0) {
			var n = spawnArray.length - 2;
			Emitters.GROUNDEMITTERS[choice[2]] = new GroundEmitter("all");
			Emitters.TRAILEMITTERS[choice[2]] = new TrailEmitter(Types.types[choice[2]]);
			//Scores.SCORETEXTS[choice[2]] = new ScoreText((HXP.screen.width / 5) * 3, 0, choice[2], Types.colors[choice[2]], null, null, "font/Dretch.otf");
			Scores.SCORETEXTS[choice[2]] = new ScoreText(-10, 220, choice[2], null, true, 12, "font/Dretch.otf");
			Scores.WIZPREVIEW[2] = new WizardPreview(-10, 200, Types.types[choice[2]]);
			Scores.WIZPREVIEW[2].updateSprite(1);

			for (i in 0...spawnArray.length) {
				if (spawnArray[n] != null) {
					if (_control[2] == 10) {
						/*p3 = new Player(spawnArray[n].x, spawnArray[n].y, "ice", 
							Key.I, Key.K, Key.J, Key.L, Key.LEFT_SQUARE_BRACKET, Key.RIGHT_SQUARE_BRACKET, _blur);*/
						p3 = new Player(spawnArray[n].x, spawnArray[n].y, Types.types[choice[2]], 
							Std.parseInt(p3control.att.up), Std.parseInt(p3control.att.down), Std.parseInt(p3control.att.left), Std.parseInt(p3control.att.right), 
							Std.parseInt(p3control.att.hitone), Std.parseInt(p3control.att.hittwo), _blur);
					} else {
#if mac
						p3 = new Player(spawnArray[n].x, spawnArray[n].y, Types.types[choice[2]], 
							XBOX_GAMEPAD_MAC.A_BUTTON, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_Y, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X, XBOX_GAMEPAD_MAC.X_BUTTON, XBOX_GAMEPAD_MAC.Y_BUTTON, 
							_blur, Input.joystick(_control[2]));
#end
#if windows
						p3 = new Player(spawnArray[n].x, spawnArray[n].y, Types.types[choice[2]], 
							XBOX_GAMEPAD_WIN.A_BUTTON, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_Y, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X, XBOX_GAMEPAD_WIN.X_BUTTON, XBOX_GAMEPAD_WIN.Y_BUTTON, 
							_blur, Input.joystick(_control[2]));
#end
					}
					break;
				}
				n--;
			}
		}

		if (_control[3] >= 0) {
			var n = spawnArray.length - 1;
			Emitters.GROUNDEMITTERS[choice[3]] = new GroundEmitter("all");
			Emitters.TRAILEMITTERS[choice[3]] = new TrailEmitter(Types.types[choice[3]]);
			//Scores.SCORETEXTS[choice[3]] = new ScoreText((HXP.screen.width / 5) * 4, 0, choice[3], Types.colors[choice[3]], null, null, "font/Dretch.otf");
			Scores.SCORETEXTS[choice[3]] = new ScoreText(330, 220, choice[3], null, true, 12, "font/Dretch.otf");
			Scores.WIZPREVIEW[3] = new WizardPreview(330, 200, Types.types[choice[3]]);
			Scores.WIZPREVIEW[3].sprite.flipped = true; 
			Scores.WIZPREVIEW[3].updateSprite(1);

			for (i in 0...spawnArray.length) {
				if (spawnArray[n] != null) {
					if (_control[3] == 10) {
						/*p4 = new Player(spawnArray[n].x, spawnArray[n].y, "psy", 
							Key.NUMPAD_8, Key.NUMPAD_5, Key.NUMPAD_4, Key.NUMPAD_6, Key.NUMPAD_ADD, Key.NUMPAD_SUBTRACT, _blur);*/
						p4 = new Player(spawnArray[n].x, spawnArray[n].y, Types.types[choice[3]], 
							Std.parseInt(p4control.att.up), Std.parseInt(p4control.att.down), Std.parseInt(p4control.att.left), Std.parseInt(p4control.att.right), 
							Std.parseInt(p4control.att.hitone), Std.parseInt(p4control.att.hittwo), _blur);
					} else {
#if mac
						p4 = new Player(spawnArray[n].x, spawnArray[n].y, Types.types[choice[3]],
							XBOX_GAMEPAD_MAC.A_BUTTON, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_Y, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X, XBOX_GAMEPAD_MAC.X_BUTTON, XBOX_GAMEPAD_MAC.Y_BUTTON, 
							_blur, Input.joystick(_control[3]));
#end
#if windows
						p4 = new Player(spawnArray[n].x, spawnArray[n].y, Types.types[choice[3]],
							XBOX_GAMEPAD_WIN.A_BUTTON, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_Y, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X, XBOX_GAMEPAD_WIN.X_BUTTON, XBOX_GAMEPAD_WIN.Y_BUTTON, 
							_blur, Input.joystick(_control[3]));
#end
					}
					break;
				}
				n--;
			}
		}
		super();
	}

	public override function begin()
	{
		//add(_blur);
		//add(_bloom);
		add(e);
		/*add(s1);
		add(s2);
		if (s3 != null) add(s3);
		if (s4 != null) add(s4);
		if (l1 != null) _bloom.register(cast(add(l1).graphic, BloomWrapper));
		if (l2 != null) _bloom.register(cast(add(l2).graphic, BloomWrapper));*/
		var spawnPts = levelFast.node.spawns;

		for (s in spawnPts.nodes.spawn) {
			var sp = new SpawnPoint(Std.parseInt(s.att.x), Std.parseInt(s.att.y));
			add(sp);
		}

		/*for (i in 0...spawnPoints.length) {
			add(spawnPoints[i]);
		}*/

		if (levelFast.hasNode.lavas) {
			var LAVAS = levelFast.node.lavas;

			for (l in LAVAS.nodes.lava) {
				for (n in 0...Std.parseInt(l.att.width)) {
					var lv = new Lava(Std.parseInt(l.att.x) + (n * 4), Std.parseInt(l.att.y), Std.random(Std.parseInt(l.att.width) * 10));
					add(lv);
				}
				//var lv = new Lava(Std.parseInt(l.att.x), Std.parseInt(l.att.y));
				//add(lv);
				//_bloom.register(cast(add(lv).graphic, BloomWrapper));
			}
		}

		var bounds = levelFast.node.bounds;

		for (b in bounds.nodes.platform) {
			var bnd = new BoundPlatform(Std.parseInt(b.att.x), Std.parseInt(b.att.y));
			add(bnd);
		}

		var hills = levelFast.node.hills;

		if (mode > 1) {
			for (h in hills.nodes.hill) {
				var hl = new Hill(Std.parseInt(h.att.x), Std.parseInt(h.att.y));
				add(hl);
			}
		}

		if (levelFast.hasNode.traps) {
			var traps = levelFast.node.traps;
			if (traps.hasNode.boulder) {
				Emitters.ROLLEMITTER = new RollEmitter();
				add(Emitters.ROLLEMITTER);

				for (o in traps.nodes.boulder) {
					var bld = new Trap(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.spawnx), Std.parseInt(o.att.spawny), "boulder", Std.parseInt(o.att.delay), Std.parseInt(o.att.dir));
					trace("boulder trap created");
					add(bld);
					trace("boulder trap spawned");
				}
			}
			if (traps.hasNode.laser) {
				Emitters.LASEREMITTER = new LaserEmitter();
				add(Emitters.LASEREMITTER);

				for (la in traps.nodes.laser) {
					var lsr = new Trap(Std.parseInt(la.att.x), Std.parseInt(la.att.y), Std.parseInt(la.att.spawnx), Std.parseInt(la.att.spawny), "laser", Std.parseInt(la.att.delay), Std.parseInt(la.att.dir));
					add(lsr);
				}
			}

			if (traps.hasNode.spike) {
				for (sp in traps.nodes.spike) {
					var spk = new Trap(Std.parseInt(sp.att.x), Std.parseInt(sp.att.y), Std.parseInt(sp.att.spawnx), Std.parseInt(sp.att.spawny), "spike", Std.parseInt(sp.att.delay), Std.parseInt(sp.att.dir));
					add(spk);
				}
			}

			if (traps.hasNode.puffer) {
				Emitters.PUFFEREMITTER = new PufferEmitter();
				add(Emitters.PUFFEREMITTER);

				for (p in traps.nodes.puffer) {
					var puff = new RandomTrap("puffer", Std.parseInt(p.att.delaymin) * 60, Std.parseInt(p.att.delaymax) * 60);
					add(puff);
				}
			}
		}

		add(Emitters.DEATHEMITTER);
		add(Emitters.SPAWNEMITTER);
		add(Emitters.LAVAEMITTER);
		add(Emitters.SHAKEEMITTER);
		for (i in 0...Emitters.GROUNDEMITTERS.length) {
			if (Emitters.GROUNDEMITTERS[i] != null) {
				add(Emitters.GROUNDEMITTERS[i]);
			}
		}

		for (i in 0...Emitters.TRAILEMITTERS.length) {
			if (Emitters.TRAILEMITTERS[i] != null) {
				add(Emitters.TRAILEMITTERS[i]);
			}
		}

		for (i in 0...Scores.SCORETEXTS.length) {
			if (Scores.SCORETEXTS[i] != null) {
				add(Scores.SCORETEXTS[i]);
			}
		}

		for (i in 0...Scores.WIZPREVIEW.length) {
			if (Scores.WIZPREVIEW[i] != null) {
				Scores.WIZPREVIEW[i].layer = -3;
				add(Scores.WIZPREVIEW[i]);
			}
		}

		add(goalText);
		add(goalText2);
		add(goalText3);
		add(goalText4);
		add(fpsText);
		add(sidebarLeft);
		add(sidebarRight);

		if (p1 != null) add(p1);
		if (p2 != null) add(p2);
		if (p3 != null) add(p3);
		if (p4 != null) add(p4);
		add(new Border(-20, 0));

		//HXP.camera.x = -20;
		if (HXP.fullscreen) {
			HXP.camera.x = -20 + Types._xPos;
			HXP.camera.y = Types._yPos;
		} else {
			HXP.camera.x = -20;
		}

		musicLoop.play();
	}

	public override function update()
	{
		if (!musicLoop.playing && !gameOver) {
			musicLoop.play();
		}

		if (Input.check(Key.ESCAPE)) {
			this.remove(e);
			trace("removed e");

			if (musicLoop.playing) {
				musicLoop.stop();
			}
			trace("checked if music was playing and stopped it if it was");

			if (winSnd.playing) {
				winSnd.stop();
			}
			trace("checked if win riff was playing and stopped it if it was");

			HXP.scene = new TitleScreen();
			trace("going to title screen");
		}

		/*if (Input.pressed(Key.Q)) {
			HXP.camera.x -= 16;
		} 

		if (Input.pressed(Key.E)) {
			HXP.camera.x += 16;
		}*/

		if ((mode == 0 || mode == 2) && !gameOver) {
			for (i in 0...Scores.SCORES.length) {
				if (Scores.SCORES[i] >= scoreSet) {
					winner = i;
					endGame();
					gameOver = true;
				}
			}
		}
		if ((mode == 1 || mode == 3) && !gameOver) {
			if (timer <= 0) {
				for (i in 0...Scores.SCORES.length) {
					if (i == 0) {
						winner = i;
						trace(Std.string(winner));
					} else {
						if (Scores.SCORES[i] > 0) {
							if (Scores.SCORES[i] > Scores.SCORES[winner]) {
								winner = i;
								trace(Std.string(winner));
							}
						}
					}
				}
				endGame();
				gameOver = true;
			} else { 
				timer -= 1;
				goalText.menuText.text = Std.string(Std.int(timer / 60));
				goalText.menuText.centerOrigin();
				goalText2.menuText.text = Std.string(Std.int(timer / 60));
				goalText2.menuText.centerOrigin();
			}
		}

		//if (Input.pressed(Key.V)) {
		if (Input.pressed(Std.parseInt(controlFast.node.fullscreen.att.key))) {
			if (!HXP.fullscreen) { HXP.screen.scale = 1; HXP.fullscreen = true; }
			else { HXP.fullscreen = false; trace("left fullscreen"); }
		}

		if (gameOver) {
#if !flash
			for (i in 0...4) {
#end
#if mac
				if (Input.joystick(i).pressed(XBOX_GAMEPAD_MAC.START_BUTTON)) {
#end
#if windows
				if (Input.joystick(i).pressed(XBOX_GAMEPAD_WIN.START_BUTTON)) {
#end
#if !flash
					if (musicLoop.playing) {
						musicLoop.stop();
					}
					if (winSnd.playing) {
						winSnd.stop();
					}
					HXP.scene = new TitleScreen();				
				}
			}
#end
		}

		fpsText.menuText.text = Std.string(HXP.frameRate);
		super.update();
	}

	private function endGame() {
		if (this.typeCount(Types.types[choice[0]]) > 0) remove(p1);
		if (this.typeCount(Types.types[choice[1]]) > 0) remove(p2);
		if (this.typeCount(Types.types[choice[2]]) > 0) remove(p3);
		if (this.typeCount(Types.types[choice[3]]) > 0) remove(p4);

		var img = new TextBackground(65, 105);
		//img.x = 65;
		//img.y = 105;
		//img.layer = 0;

		var winText = new MenuText(Types.types[winner] + " wizard wins!", 160, 120, true, 20, "font/Dretch.otf"); //+ "\n" + "Press Escape to return to the menu.", 160, 120, true, 20);
		var winText2 = new MenuText("Press Escape or Start to return to the main menu.", 160, 130, true, 20, "font/Dretch.otf");

		add(img);
		add(winText);
		add(winText2);
		musicLoop.stop();
		winSnd.play();
	}
}
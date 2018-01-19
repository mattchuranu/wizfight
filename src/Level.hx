import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import flash.geom.Point;
import flash.system.System;
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
import game.Powerbar;
import game.Enemy;
import game.EnemyTwo;
import game.part.DeathEmitter;
import game.part.SpawnEmitter;
import game.part.GroundEmitter;
import game.part.LavaEmitter;
import game.part.TrailEmitter;
import game.part.ShakeEmitter;
import game.part.LaserEmitter;
import game.part.RollEmitter;
import game.part.PufferEmitter;
import game.part.CloudEmitter;
import game.part.PowerEmitter;
import game.part.DustEmitter;
import game.part.ZenEmitter;
import game.part.Emitters;
import game.powers.Orb;
#if mac
import game.XBOX_GAMEPAD_MAC;
#end
#if windows
import game.XBOX_GAMEPAD_WIN;
#end
import haxe.xml.Fast;
import sys.io.File;
import flash.display.BitmapData;
import flash.net.URLRequest;
import flash.media.Sound;
import flash.media.SoundChannel;

class Level extends Scene
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
	private var goalText:MenuText;
	private var goalText2:MenuText;
	private var goalText3:MenuText;
	private var goalText4:MenuText;
	private var sidebarLeft:Sidebar;
	private var sidebarRight:Sidebar;
	private var fpsText:MenuText;
	private var musicLoop:Sound;
	private var musicChannel:SoundChannel;
	private var musicSfx:Sfx;
	private var choice:Array<Int>;
	private var winSnd:Sfx;
	private var players:Array<Player>;
	private var playercontrols:Array<Fast>;
	private var playerNum:Int;
	private var preposx:Array<Int>;
	private var preposy:Array<Int>;
	public var icedTimer:Int;
	public var darkTimer:Int;
	private var orbTimer:Int;
	public var chaosTimer:Int;
	public var invisiTimer:Int;
	public var barnacleTimer:Int;
	public var zenTimer:Int;
	public var fogTimer:Int;
	public var monsterTimer:Int;
	public var timeElapsed:Float;
	private var spawnInterval:Int;
	private var orbRate:Int;
	private var spawnArray:Array<Point>;
	private var spawnPointArr:Array<SpawnPoint>;
	private var enemyArray:Array<Array<Dynamic>>;
	private var spawnSnd:Sfx;
	private var session:Array<Dynamic>;
	private var enemyWeight:Array<Int>;
	private var weightedEnemyArray:Array<Array<Dynamic>>;

	public function new(_control:Array<Int>, _map:String, ?_mode:Int, ?_modeSet:Int, ?_choice:Array<Int>)
	{

		//var levelString = openfl.Assets.getBytes("maps/" + _map + ".lvl");
		var levelString = File.getBytes("maps/" + _map + ".lvl");
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

		//e = new TmxEntity("maps/" + _map + ".tmx");
		//e.loadGraphic("gfx/tiles/" + tileset + ".png", ["back", "front"]);
		e = new TmxEntity(Xml.parse(File.getBytes("maps/" + _map + ".tmx").toString()));
		e.loadGraphic(BitmapData.load("gfx/tiles/" + tileset + ".png"), ["back", "front"]);
		e.loadMask("collision", "solid");

		//musicLoop = new Sfx("music/" + music + ".ogg");
		//musicLoop = new Sound(new URLRequest("music/" + music + ".ogg"));
		//musicChannel = musicLoop.play();
		musicSfx = new Sfx("music/" + music + ".ogg"); //new Sfx(musicLoop);


		sidebarLeft = new Sidebar(-20, 0, "all");
		sidebarRight = new Sidebar(320, 0, "all");
		sidebarRight.sprite.flipped = true;

		mode = _mode;
		Scores.MODE = mode;
		choice = _choice;

		if (mode == 0 || mode == 2) {
			scoreSet = _modeSet;
				goalText = new MenuText(Std.string(_modeSet), -10, 118, true, 10, "font/Dretch.otf");
				goalText3 = new MenuText("points", -10, 122, true, 10, "font/Dretch.otf");

				goalText2 = new MenuText(Std.string(_modeSet), 330, 118, true, 10, "font/Dretch.otf");
				goalText4 = new MenuText("points", 330, 122, true, 10, "font/Dretch.otf");
		} else if (mode == 1 || mode == 3) {
			timer = _modeSet * 3600;
				goalText = new MenuText(Std.string(timer / 60), -10, 118, true, 10, "font/Dretch.otf");
				goalText3 = new MenuText("seconds", -10, 122, true, 9, "font/Dretch.otf");

				goalText2 = new MenuText(Std.string(timer / 60), 330, 118, true, 10, "font/Dretch.otf");
				goalText4 = new MenuText("seconds", 330, 122, true, 9, "font/Dretch.otf");
		} else if (mode == 4) {
			spawnInterval = _modeSet * 60;
				goalText = new MenuText(Std.string(spawnInterval / 60) + " sec", -10, 118, true, 10, "font/Dretch.otf");
				goalText3 = new MenuText("til spawn", -10, 122, true, 9, "font/Dretch.otf");

				goalText2 = new MenuText(Std.string(spawnInterval / 60) + " sec", 330, 118, true, 10, "font/Dretch.otf");
				goalText4 = new MenuText("til spawn", 330, 122, true, 9, "font/Dretch.otf");
				/*goalText = new MenuText("Fight", -10, 118, true, 10, "font/Dretch.otf");
				goalText3 = new MenuText("to survive", -10, 122, true, 9, "font/Dretch.otf");

				goalText2 = new MenuText("Fight", 330, 118, true, 10, "font/Dretch.otf");
				goalText4 = new MenuText("to survive", 330, 122, true, 9, "font/Dretch.otf");*/
		}

		gameOver = false;
		winner = 10;

		icedTimer = 0;
		darkTimer = 0;
		invisiTimer = 0;
		barnacleTimer = 0;
		fogTimer = 0;
		zenTimer = 0;
		orbTimer = 120 + Std.random(120);
		monsterTimer = spawnInterval;
		timeElapsed = 0;

		//fpsText = new MenuText(Std.string(HXP.frameRate), 0, 0);

		spawnArray = new Array();
		spawnPointArr = new Array();
		var spawnPts = levelFast.node.spawns;
		var count = 0;

		for (s in spawnPts.nodes.spawn) {
			spawnArray[count] = new Point(Std.parseInt(s.att.x), Std.parseInt(s.att.y));
			trace(spawnArray[count].x);
			count++;
		}

		var controlString = openfl.Assets.getBytes("conf/controls.xml");
		var controlXML = Xml.parse(controlString.toString());
		controlFast = new Fast(controlXML.firstElement());
		var plyrcontrols = controlFast.node.players;

		playercontrols = new Array();
		playercontrols[0] = plyrcontrols.node.pone;
		playercontrols[1] = plyrcontrols.node.ptwo;
		playercontrols[2] = plyrcontrols.node.pthree;
		playercontrols[3] = plyrcontrols.node.pfour;

		enemyArray = new Array();
		enemyWeight = new Array();
		weightedEnemyArray = new Array();

		/*var enemiesString = openfl.Assets.getBytes("conf/enemies.xml");
		var enemiesXML = Xml.parse(enemiesString.toString());
		var enemiesFast = new Fast(enemiesXML.firstElement());

		var q = 0;
		for (enemy in enemiesFast.nodes.enemy) {
			enemyArray[q] = new Array();
			enemyArray[q][0] = Std.parseInt(enemy.node.w.innerData);
			enemyArray[q][1] = Std.parseInt(enemy.node.h.innerData);
			enemyArray[q][2] = enemy.node.type.innerData;
			enemyArray[q][3] = enemy.node.sprite.innerData;
			enemyArray[q][4] = Std.parseInt(controlFast.node.jump.att.option);
			enemyArray[q][5] = Std.parseInt(enemy.node.health.innerData);
			enemyArray[q][6] = Std.parseFloat(enemy.node.speed.innerData);
			enemyArray[q][7] = Std.parseInt(enemy.node.knockback.innerData);

			q++;
		}*/

		var enemyFiles = sys.FileSystem.readDirectory("enemies");
		var currentNum = 0;

		for (ff in enemyFiles) {
			var enemyString = File.getBytes("enemies/" + ff);
			var enemyXML = Xml.parse(enemyString.toString());
			var enemyFast = new Fast(enemyXML.firstElement());

			enemyArray[currentNum] = new Array();
			enemyArray[currentNum][0] = Std.parseInt(enemyFast.node.w.innerData);
			enemyArray[currentNum][1] = Std.parseInt(enemyFast.node.h.innerData);
			enemyArray[currentNum][2] = enemyFast.node.type.innerData;
			enemyArray[currentNum][3] = enemyFast.node.sprite.innerData;
			enemyArray[currentNum][4] = Std.parseInt(controlFast.node.jump.att.option);
			enemyArray[currentNum][5] = Std.parseInt(enemyFast.node.health.innerData);
			enemyArray[currentNum][6] = Std.parseFloat(enemyFast.node.speed.innerData);
			enemyArray[currentNum][7] = Std.parseInt(enemyFast.node.knockback.innerData);
			enemyWeight[currentNum] = Std.parseInt(enemyFast.node.weight.innerData);

			currentNum++;
		}

		currentNum = 0;

		for (i in 0...enemyArray.length) {
			for (j in 0...enemyWeight[i]) {
				weightedEnemyArray[currentNum] = enemyArray[i];
				currentNum++;
			}
		}

		session = new Array();
		session[0] = _control;
		session[1] = _map;
		session[2] = _mode;
		session[3] = _modeSet;
		session[4] = _choice;

		spawnSnd = new Sfx("snd/spawn.wav");

		Types.orbLoss = Std.parseInt(controlFast.node.orb.att.loss);
		orbRate = Std.parseInt(controlFast.node.orb.att.rate);
		trace(Types.orbLoss);

		var _speed = Std.parseInt(controlFast.node.jump.att.option);
		_blur = 1;
		_bloom = 1;

		Emitters.DEATHEMITTER = new DeathEmitter("all");
		Emitters.SPAWNEMITTER = new SpawnEmitter();
		Emitters.LAVAEMITTER = new LavaEmitter();
		Emitters.SHAKEEMITTER = new ShakeEmitter(tileset);
		Emitters.DUSTEMITTER = new DustEmitter();
		Emitters.ZENEMITTER = new ZenEmitter();

		Emitters.GROUNDEMITTERS = new Array();
		Emitters.TRAILEMITTERS = new Array();
		Emitters.POWEREMITTERS = new Array();

		playerNum = 0;

		Scores.SCORES = new Array();
		for (c in 0...choice.length) {
			Scores.SCORES[choice[c]] = 0;

			if (choice[c] >= 0) {
				playerNum++;
			}
		}

		Scores.SCORETEXTS = new Array();
		Scores.WIZPREVIEW = new Array();
		Scores.POWER = new Array();
		Scores.POWERPREVIEW = new Array();

		preposx = new Array();
		preposy = new Array();
		preposx[0] = -10;
		preposy[0] = 40;
		preposx[1] = 330;
		preposy[1] = 40;
		preposx[2] = -10;
		preposy[2] = 200;
		preposx[3] = 330;
		preposy[3] = 200;

		players = new Array();

		for (i in 0..._control.length) {
			if (_control[i] >= 0) {
				var n = i;
				Emitters.GROUNDEMITTERS[choice[i]] = new GroundEmitter("all");
				Emitters.TRAILEMITTERS[choice[i]] = new TrailEmitter(Types.types[choice[i]]);
				Emitters.POWEREMITTERS[choice[i]] = new PowerEmitter(Types.types[choice[i]]);
				Scores.SCORETEXTS[choice[i]] = new ScoreText(preposx[i], preposy[i] + 20, choice[i], null, true, 12, "font/Dretch.otf");
				Scores.WIZPREVIEW[i] = new WizardPreview(preposx[i], preposy[i], Types.types[choice[i]]);
				Scores.POWER[i] = 0;
				Scores.POWERPREVIEW[i] = new Powerbar(preposx[i], preposy[i] + 30, choice[i]);

				if (Math.round(i / 2) != i / 2) {
					Scores.WIZPREVIEW[i].sprite.flipped = true;
				}

				Scores.WIZPREVIEW[i].updateSprite(1); 

				for (k in 0...spawnArray.length) {
					if (spawnArray[n] != null) {
						if (_control[i] == 10) {
							players[i] = new Player(spawnArray[n].x, spawnArray[n].y, Types.types[choice[i]], 
								Std.parseInt(playercontrols[i].att.up), Std.parseInt(playercontrols[i].att.down), Std.parseInt(playercontrols[i].att.left), Std.parseInt(playercontrols[i].att.right), 
								Std.parseInt(playercontrols[i].att.hitone), Std.parseInt(playercontrols[i].att.hittwo), _speed);
						} else {
#if mac
							players[i] = new Player(spawnArray[n].x, spawnArray[n].y, Types.types[choice[i]], 
								XBOX_GAMEPAD_MAC.A_BUTTON, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_Y, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X, XBOX_GAMEPAD_MAC.LEFT_ANALOGUE_X, XBOX_GAMEPAD_MAC.X_BUTTON, XBOX_GAMEPAD_MAC.Y_BUTTON, 
								_speed, Input.joystick(_control[i]));
#end
#if windows
							players[i] = new Player(spawnArray[n].x, spawnArray[n].y, Types.types[choice[i]], 
								XBOX_GAMEPAD_WIN.A_BUTTON, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_Y, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X, XBOX_GAMEPAD_WIN.LEFT_ANALOGUE_X, XBOX_GAMEPAD_WIN.X_BUTTON, XBOX_GAMEPAD_WIN.Y_BUTTON, 
								_speed, Input.joystick(_control[i]));
#end
						}
						break;
					}
					n--;
				}
			}
		}

		super();
	}

	public override function begin()
	{
		add(e);
		var spawnPts = levelFast.node.spawns;

		var spawnNum = 0;
		for (s in spawnPts.nodes.spawn) {
			var sp = new SpawnPoint(Std.parseInt(s.att.x), Std.parseInt(s.att.y));
			spawnPointArr[spawnNum] = sp;
			add(sp);
			spawnNum++;
		}

		if (levelFast.hasNode.lavas) {
			var LAVAS = levelFast.node.lavas;

			for (l in LAVAS.nodes.lava) {
				for (n in 0...Std.parseInt(l.att.width)) {
					var lv = new Lava(Std.parseInt(l.att.x) + (n * 4), Std.parseInt(l.att.y), Std.random(Std.parseInt(l.att.width) * 10));
					add(lv);
				}
			}
		}

		var bounds = levelFast.node.bounds;

		for (b in bounds.nodes.platform) {
			var bnd = new BoundPlatform(Std.parseInt(b.att.x), Std.parseInt(b.att.y));
			add(bnd);
		}

		var hills = levelFast.node.hills;

		if (mode > 1 && mode < 4) {
			for (h in hills.nodes.hill) {
				var hl = new Hill(Std.parseInt(h.att.x), Std.parseInt(h.att.y));
				add(hl);
			}
		}

		if (levelFast.hasNode.traps) {
			var traps = levelFast.node.traps;
			if (traps.hasNode.boulder) {
				//Emitters.ROLLEMITTER = new RollEmitter();
				//add(Emitters.ROLLEMITTER);

				for (o in traps.nodes.boulder) {
					var bld = new Trap(Std.parseInt(o.att.x), Std.parseInt(o.att.y), Std.parseInt(o.att.spawnx), Std.parseInt(o.att.spawny), "boulder", Std.parseInt(o.att.delay), Std.parseInt(o.att.dir));
					add(bld);
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

		Emitters.ROLLEMITTER = new RollEmitter();
		add(Emitters.ROLLEMITTER);

		add(Emitters.DEATHEMITTER);
		add(Emitters.SPAWNEMITTER);
		add(Emitters.LAVAEMITTER);
		add(Emitters.SHAKEEMITTER);
		add(Emitters.DUSTEMITTER);
		add(Emitters.ZENEMITTER);
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

		for (i in 0...Emitters.POWEREMITTERS.length) {
			if (Emitters.POWEREMITTERS[i] != null) {
				add(Emitters.POWEREMITTERS[i]);
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
		
		for (i in 0...Scores.POWERPREVIEW.length) {
			if (Scores.POWERPREVIEW[i] != null) {
				Scores.POWERPREVIEW[i].layer = -3;
				add(Scores.POWERPREVIEW[i]);
			}
		}

		for (i in 0...choice.length) {
			if (Types.types[choice[i]] == "cloud" || Types.types[choice[i]] == "mimic") {
				Emitters.CLOUDEMITTER = new CloudEmitter();
				add(Emitters.CLOUDEMITTER);
			}
		}

		add(goalText);
		add(goalText2);
		add(goalText3);
		add(goalText4);
		//add(fpsText);
		add(sidebarLeft);
		add(sidebarRight);

		for (i in 0...players.length) {
			if (players[i] != null) {
				add(players[i]);
				trace("added player");
			}
		}
		add(new Border(-20, 0));

		if (HXP.fullscreen) {
			HXP.camera.x = -20 + Types._xPos;
			HXP.camera.y = Types._yPos;
		} else {
			HXP.camera.x = -20;
		}

		musicSfx.play();
	}

	public override function update()
	{
		if (!musicSfx.playing && !gameOver) {
			musicSfx.play();
		}

		if (icedTimer <= 0) {
			if (typeCount("iced") > 0) {
				var arr:Array<Entity> = new Array();
				getType("iced", arr);

				for (i in 0...arr.length) {
					remove(arr[i]);
				}
			}
		} else {
			icedTimer -= 1;
		}

		if (barnacleTimer <= 0) {
			if (typeCount("barnacled") > 0) {
				var arr:Array<Entity> = new Array();
				getType("barnacled", arr);

				for (i in 0...arr.length) {
					remove(arr[i]);
				}
			}
		} else {
			barnacleTimer -= 1;
		}

		if (fogTimer <= 0) {
			if (typeCount("fogged") > 0) {
				var arr:Array<Entity> = new Array();
				getType("fogged", arr);

				for (i in 0...arr.length) {
					remove(arr[i]);
				}
			}
		} else {
			fogTimer -= 1;
		}

		if (zenTimer > 0) {
			zenTimer -= 1;
		}

		if (orbTimer <= 0 && mode != 4) {
			spawnOrb();
		} else {
			orbTimer -= 1;
		}

		if (darkTimer <= 0) {
			e.visible = true;
		} else {
			e.visible = false;
			darkTimer -= 1;
		}

		if (chaosTimer > 0) {
			chaosTimer -= 1;
		}

		if (invisiTimer > 0) {
			invisiTimer -= 1;
		}

		if (Input.pressed(Key.ESCAPE)) {
			//this.remove(e);
			//trace("removed e");
			//if (!winSnd.playing) {
				/*if (musicLoop.playing) {
					musicLoop.stop();
				}

				if (winSnd.playing) {
					winSnd.stop();
				}*/
				if (!gameOver) {
					//musicChannel.stop();
					musicSfx.stop();
				} else {
					if (winSnd.playing) {
						winSnd.stop();
					}
				}

				HXP.scene = new TitleScreen();
			//}
		}

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

		if (mode == 4 && !gameOver) {
			timeElapsed += 1;
			var n = -1;
			for (i in 0...Types.types.length) {
				if (typeCount(Types.types[i]) > 0) {
					var p = nearestToPoint(Types.types[i], 0, 0);

					if (!cast(p, Player).dead) {
						n = 1;
						break;
					}
				}
			}

			if (n < 0) {
				endGame();
				gameOver = true;
			}

			var m = Std.int(timeElapsed / spawnInterval);

			if (monsterTimer <= 0) {
				var rand = Math.floor(randomRange(0, spawnArray.length - 1));
				var rand2 = Math.floor(randomRange(0, weightedEnemyArray.length - 1));
				var enemy = null;

				if (weightedEnemyArray[rand2][2] != "turret") {
					enemy = new EnemyTwo(
						spawnPointArr[rand].x + (16 - (weightedEnemyArray[rand2][0] + (weightedEnemyArray[rand2][0] / 2))), //x
						spawnPointArr[rand].y + (16 - weightedEnemyArray[rand2][1] - 2), //y
						weightedEnemyArray[rand2][2], //type
						weightedEnemyArray[rand2][3], //sprite
						weightedEnemyArray[rand2][4], //jump speed (same for all)
						weightedEnemyArray[rand2][0], //width
						weightedEnemyArray[rand2][1],//height
						weightedEnemyArray[rand2][5], //health
						weightedEnemyArray[rand2][6], //velocity
						weightedEnemyArray[rand2][7] //knockback
						);
				} else {
					var randx = randomRange(0, 20);
					var randy = randomRange(0, 15);

					if (!e.collidePoint(0, 0, randx * 16, randy * 16) 
						&& !e.collidePoint(0, 0, (randx * 16) + (16 - (weightedEnemyArray[rand2][0] + (weightedEnemyArray[rand2][0] / 2))), (randy * 16) + (16 - (weightedEnemyArray[rand2][1] + (weightedEnemyArray[rand2][1] / 2)))) 
						&& ((randx * 16) + (16 - (weightedEnemyArray[rand2][0] + (weightedEnemyArray[rand2][0] / 2))) > 0 
							&& (randx * 16) + (16 - (weightedEnemyArray[rand2][0] + (weightedEnemyArray[rand2][0] / 2))) < 320)
						&& ((randy * 16) + (16 - (weightedEnemyArray[rand2][1] + (weightedEnemyArray[rand2][1] / 2))) > 0
							&& (randy * 16) + (16 - (weightedEnemyArray[rand2][1] + (weightedEnemyArray[rand2][1] / 2))) < 240)) {
						enemy = new EnemyTwo(
							(randx * 16) + (16 - (weightedEnemyArray[rand2][0] + (weightedEnemyArray[rand2][0] / 2))), //x
							(randy * 16) + (16 - (weightedEnemyArray[rand2][1] + (weightedEnemyArray[rand2][1] / 2))), //y
							weightedEnemyArray[rand2][2], //type
							weightedEnemyArray[rand2][3], //sprite
							weightedEnemyArray[rand2][4], //jump speed (same for all)
							weightedEnemyArray[rand2][0], //width
							weightedEnemyArray[rand2][1],//height
							weightedEnemyArray[rand2][5], //health
							weightedEnemyArray[rand2][6], //velocity
							weightedEnemyArray[rand2][7] //knockback
							);
					} else {
						rand2 -= 1;
						enemy = new EnemyTwo(
						spawnPointArr[rand].x + (16 - (weightedEnemyArray[rand2][0] + (weightedEnemyArray[rand2][0] / 2))), //x
						spawnPointArr[rand].y + (16 - weightedEnemyArray[rand2][1] - 2), //y
						weightedEnemyArray[rand2][2], //type
						weightedEnemyArray[rand2][3], //sprite
						weightedEnemyArray[rand2][4], //jump speed (same for all)
						weightedEnemyArray[rand2][0], //width
						weightedEnemyArray[rand2][1],//height
						weightedEnemyArray[rand2][5], //health
						weightedEnemyArray[rand2][6], //velocity
						weightedEnemyArray[rand2][7] //knockback
						);
					}
				}

				if (enemy != null) {
					spawnSnd.play(0.5);
					add(enemy);
				}

				monsterTimer = Std.int(spawnInterval / m);
				goalText.menuText.text = Std.string(monsterTimer / 60) + " sec";
				goalText2.menuText.text = Std.string(monsterTimer / 60) + " sec";
			} else {
				monsterTimer -= 1;
				goalText.menuText.text = Std.string(Std.int(monsterTimer / 60)) + " sec";
				goalText2.menuText.text = Std.string(Std.int(monsterTimer / 60)) + " sec";
			}
		}

		/*if (Input.pressed(Std.parseInt(controlFast.node.fullscreen.att.key))) {
			if (!HXP.fullscreen) { HXP.screen.scale = 1; HXP.fullscreen = true; }
			else { HXP.fullscreen = false; trace("left fullscreen"); }
		}*/

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
					/*if (musicLoop.playing) {
						musicLoop.stop();
					}
					if (winSnd.playing) {
						winSnd.stop();
					}*/
					if (!gameOver) {
						//musicChannel.stop();
						musicSfx.stop();
					} else {
						if (winSnd.playing) {
							winSnd.stop();
						}
					}

					HXP.scene = new TitleScreen();				
				}
			}
#end
			if (Input.pressed(Key.R)) {
				if (winSnd.playing) {
					winSnd.stop();
				}
				HXP.scene = new Level(session[0], session[1], session[2], session[3], session[4]);
			}
		}

		//fpsText.menuText.text = Std.string(HXP.frameRate + "\n" + HXP.round(System.totalMemory / 1024 / 1024, 2) + "MB");
		super.update();
	}

	private function endGame() {
		for (i in 0...players.length) {
			if (players[i] != null) {
				remove(players[i]);
			}
		}

		if (mode == 4) {
			monsterTimer = 0;
			timeElapsed = 0;

			if (typeCount("enemy") > 0) {
				var arr:Array<Entity> = new Array();
				getType("enemy", arr);

				for (i in 0...arr.length) {
					remove(arr[i]);
				}
			}
		}

		var img = new TextBackground(65, 105);

		var winText = new MenuText(Types.types[winner] + " wizard wins!", 160, 120, true, 20, "font/Dretch.otf");
		var winText2 = new MenuText("Press Escape or Start to exit to menu. Press R to play again.", 160, 130, true, 20, "font/Dretch.otf");

		if (mode == 4) {
			winText.menuText.text = "You have been defeated!";
			winText.menuText.centerOrigin();
		}

		add(img);
		add(winText);
		add(winText2);
		musicSfx.stop();
		//musicChannel.stop();
		winSnd.play();
	}

	private function spawnOrb() {
		for (_x in 0...20) {
			for (_y in 0...15) {
				if (collidePoint("solid", (_x * 16), (_y * 16)) != null) {
					if (collidePoint("solid", (_x * 16), ((_y - 1) * 16)) == null) {
						if (Math.random() < 0.05 && (_y - 1) * 16 > 0 && orbTimer <= 0 && collidePoint("lava", (_x * 16), ((_y - 1) * 16)) == null && collideRect("orb", (_x * 16), ((_y - 1) * 16), 16, 16) == null) {
							add(new Orb( (_x * 16) + 6, ((_y - 1) * 16) + 9 ));
							//orbTimer = 120 + Std.random(120);
							//orbTimer = 180 - (60 * Math.floor(playerNum / 2)) + Std.random(120);
							orbTimer = Std.int(180 / (orbRate + 1)) - (60 * Math.floor(playerNum / 2)) + Std.random(120);
							break;
						}
					}
				}
			}
		}
	}

	private function randomRange(min:Int, max:Int) {
		return min + (Math.random() * ((max - min) + 1));
	}
}
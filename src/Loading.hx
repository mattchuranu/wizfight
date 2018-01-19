import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;
import menu.MenuText;
import haxe.xml.Fast;
import flash.events.Event;
import flash.media.Sound;
import flash.utils.ByteArray;
import flash.net.URLRequest;

class Loading extends Scene
{
	private var percent:MenuText;
	private var control:Array<Int>;
	private var map:String;
	private var mode:Int;
	private var modeSet:Int;
	private var musicLoader:Sound;
	private var levelFast:Fast;
	//private var strttxt:StartText;

	public function new(_control:Array<Int>, _map:String, ?_mode:Int, ?_modeSet:Int)
	{
		control = _control;
		map = _map;
		mode = _mode;
		modeSet = _modeSet;

		super();
	}

	public override function begin()
	{
		var levelString = flash.Assets.getBytes("maps/" + map + ".lvl");
		var levelXML = Xml.parse(levelString.toString());
		levelFast = new Fast(levelXML.firstElement());

		var music = map;

		if (levelFast.hasNode.overrides) {
			var over = levelFast.node.overrides;
			if (over.hasNode.music) {
				var mu = over.node.music;
				music = mu.att.name;
			}
		}

		var musicRequest = new URLRequest("music/" + music + ".ogg");
		//musicLoader = new URLLoader(musicRequest);
		trace("music/" + music + ".ogg");
		musicLoader = new Sound(musicRequest);
		musicLoader.addEventListener(Event.COMPLETE, onComplete);

		percent = add(new MenuText("Loading...", 160, 120, true, 15, "font/Dretch.otf"));
		add(percent);	
	}

	public override function update() 
	{
		//trace(musicLoader.bytesLoaded);
		//percent.menuText.text = Std.string(musicLoader.bytesLoaded);
	}

	private function onComplete(e:Event)
	{
		//var newmusic = new Sound(musicLoader);
		var musicSfx = new Sfx(musicLoader);
		HXP.scene = new Level(control, map, mode, modeSet, musicSfx);
	}
}
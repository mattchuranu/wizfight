package com.haxepunk.bloom;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import com.haxepunk.Graphic;
	/**
	 * ...
	 * @author Reiss
	 */
	class BloomWrapper extends Graphic
	{
		public var bloomCanvas:BitmapData;
		private var _graphic(get_Graphic, null):Graphic;
		
		public function new(g:Graphic)
		{
			super();
			bloomCanvas = null;
			_graphic = g;
			active = g.active;
			visible = g.visible;
			relative = g.relative;
		}
		
		public function get_Graphic():Graphic
		{
			return _graphic;
		}
		
		override public function render(target:BitmapData, point:Point, camera:Point)
		{
			if (bloomCanvas != null)
				_graphic.render(bloomCanvas, point, camera);
			_graphic.render(target, point, camera);
		}
		
		override public function update()
		{
			_graphic.update();
		}
		
	}
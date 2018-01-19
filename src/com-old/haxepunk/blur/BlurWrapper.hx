package com.haxepunk.blur;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import com.haxepunk.Graphic;
	
	/**
	 * ...
	 * @author Reiss
	 */
	class BlurWrapper extends Graphic
	{
		private var _blurCanvas:BitmapData;
		private var _graphic:Graphic;
		public var parent:MotionBlur;
		
		public function new(g:Graphic, m:MotionBlur, ?autoStart:Bool) 
		{
			if (autoStart == null) autoStart = true;

			super();
			_graphic = g;
			active = g.active;
			visible = g.visible;
			relative = g.relative;
			parent = m;
			
			if(autoStart)
				_blurCanvas = m.buffer;
		}
		
		public function getWrappedGraphic()
		{
			return _graphic;
		}
		
		public function getIsBlurring()
		{
			return _blurCanvas != null;
		}
		public function setIsBlurring(b:Bool)
		{
			if(b)
				_blurCanvas = parent.buffer;
			else
				_blurCanvas = null;
		}
		
		override public function render(target:BitmapData, point:Point, camera:Point)
		{
			if (_blurCanvas != null)
				_graphic.render(_blurCanvas, point, camera);
			_graphic.render(target, point, camera);
		}
		
		override public function update()
		{
			_graphic.update();
		}
		
	}
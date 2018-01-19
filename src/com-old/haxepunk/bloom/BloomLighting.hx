package com.haxepunk.bloom;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import com.haxepunk.Entity;
	import com.haxepunk.HXP;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import com.haxepunk.Graphic;
	
	/**
	 * ...
	 * @author Reiss
	 */
	class BloomLighting extends Entity
	{
		//buffers and filters for creating the bloom
		private var _canvas(get_Buffer, null):BitmapData;
		private var _postprocess:BitmapData;
		private var _filter:BlurFilter;
		
		//screen size, location
		private var _screenrect:Rectangle;
		private var _screenpoint:Point;
		
		//tinting data
		private var _color(get_Color, null):Int;
		private var _tint:ColorTransform;
		
		
		public function new(bloom:Float, quality:Int)
		{
			super();
			_canvas = new BitmapData(HXP.width, HXP.height, false, 0xff000000);
			_postprocess = new BitmapData(HXP.width, HXP.height, false, 0xff000000);
			_screenrect = new Rectangle(0, 0, HXP.width, HXP.height);
			_screenpoint = new Point();
			_color = 0x00FFFFFF;
			_tint = null;
			_filter = new BlurFilter(bloom, bloom, quality);
		}
		
		//tinting accessors
		public function get_Color():Int { return _color; }
		public function set_Color(value:Int)
		{
			value &= 0xFFFFFF;
			if (_color == value) return;
			_color = value;
			if (_color == 0xFFFFFF)
			{
				_tint = null;
				return;
			}
			_tint = new ColorTransform();
			_tint.redMultiplier = (_color >> 16 & 0xFF) / 255;
			_tint.greenMultiplier = (_color >> 8 & 0xFF) / 255;
			_tint.blueMultiplier = (_color & 0xFF) / 255;
		}
		
		//register an entity as casting bloom lighting
		public function register(g:BloomWrapper)
		{
			g.bloomCanvas = _canvas;
		}
		
		//unregister and entity as casting bloom lighting
		public function unregister(g:BloomWrapper)
		{
			g.bloomCanvas = null;
		}
		
		//returns the bloom canvas, in case you want to draw to it without using a bloom wrapper
		public function get_Buffer():BitmapData
		{
			return _canvas;
		}
		
		override public function render()
		{
			super.render();
			
			//calculate the blur from the canvas
			_postprocess.applyFilter(_canvas, _screenrect, _screenpoint, _filter);
			
			//draw the blur to the buffer using SCREEN blending, to simulate bloom lighting
			HXP.buffer.draw(_postprocess,null,_tint,BlendMode.SCREEN);
			
			//clear the canvas after drawing
			_canvas.fillRect(_screenrect, 0xff000000);
		}
		
	}
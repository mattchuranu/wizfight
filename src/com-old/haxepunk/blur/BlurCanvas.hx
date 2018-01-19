package com.haxepunk.blur;

	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import com.haxepunk.Entity;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.BitmapData;
	import com.haxepunk.HXP;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Reiss
	 */
	class BlurCanvas extends Entity
	{	
		//screen size and location
		private var _screenRect:Rectangle; 
		private var _translationMatrix:Matrix;
		//screen-sized transparent pre-processing buffer
		private var _preprocess:BitmapData;
		//alpha transform for motion blur trails
		private var _alphaTransform:ColorTransform;
		private var _color:Int;
		//camera point to track -- defaults to FP.camera
		public var camera:Point;
		private var _oldCamera:Point;
		//bitmap to wrap
		private var _bmp:Bitmap;
		public var buffer:BitmapData;
		
		public function new(blurFactor:Float, ?screenWidth:Int, ?screenHeight:Int)
		{
			if (screenWidth == null) screenWidth = -1;
			if (screenHeight == null) screenHeight = -1;

			_translationMatrix = new Matrix();
			_color = 0x00FFFFFF;
			camera = HXP.camera;
			_oldCamera = new Point(camera.x, camera.y);
			_screenRect = new Rectangle(0, 0, screenWidth < 0 ? HXP.width : screenWidth, screenHeight < 0 ? HXP.height : screenHeight);
			buffer = _preprocess = new BitmapData(Std.int(_screenRect.width), Std.int(_screenRect.height), true, 0);
			_bmp = new Bitmap(_preprocess);
			//set the fade for motion blur trails
			_alphaTransform = new ColorTransform(1, 1, 1, blurFactor);

			super();
		}
		
		//accessors for blur factor
		public function getBlurFactor()
		{
			return _alphaTransform.alphaMultiplier;
		}
		public function setBlurFactor(blur:Float)
		{
			_alphaTransform.alphaMultiplier = blur;
		}
		
		//accessors for color change
		public function getColor()
		{
			return _color;
		}
		public function setColor(value:Int)
		{
			value &= 0xFFFFFF;
			if (_color == value) return;
			_color = value;
			if (_color == 0xFFFFFF)
			{
				_alphaTransform.redMultiplier = 1.0;
				_alphaTransform.greenMultiplier = 1.0;
				_alphaTransform.blueMultiplier = 1.0;
				return;
			}
			_alphaTransform.redMultiplier = (_color >> 16 & 0xFF) / 255;
			_alphaTransform.greenMultiplier = (_color >> 8 & 0xFF) / 255;
			_alphaTransform.blueMultiplier = (_color & 0xFF) / 255;
		}
		
		//returns the bloom canvas, in case you want to draw to it without using a bloom wrapper
		public function getBuffer()
		{
			return _preprocess;
		}
		
		override public function render()
		{
			_preprocess.colorTransform(_screenRect, _alphaTransform);
			//move the preprocessing buffer by the camera amount
			_preprocess.scroll(Std.int(_oldCamera.x - camera.x), Std.int(_oldCamera.y - camera.y));
			
			super.render();
			
			//draw the Bitmap wrapper for the buffer, since Flash Player 10.1 has a memory leak
			//when drawing one BitmapData to another
			HXP.buffer.draw(_bmp);
			
			//save camera coords
			syncCamera();
		}
		
		private function syncCamera()
		{
			_oldCamera.x = camera.x;
			_oldCamera.y = camera.y;
		}
		
		public function reset()
		{
			syncCamera();
			_preprocess.fillRect(_screenRect, 0);
		}
	}
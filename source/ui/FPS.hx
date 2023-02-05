package ui;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Timer;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.system.System;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends Bitmap
{
	static final _intervalArray:Array<String> = ['B', 'KB', 'MB', 'GB', 'TB'];

	static function _getInterval(num:UInt):String
	{
		var size:Float = num;
		var data = 0;
		while (size > 1024 && data < _intervalArray.length - 1)
		{
			data++;
			size = size / 1024;
		}

		size = Math.round(size * 100) / 100;
		return size + " " + _intervalArray[data];
	}

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		_text = "FPS: 0\nMemory: 0 MB";

		_flxText = new FlxText(0, 0, 250, _text, 16);
		_flxText.setFormat('_sans', 16, color, LEFT, OUTLINE, FlxColor.BLACK);
		_flxText.borderSize = 2;

		_updateBitmap();

		addEventListener(Event.ENTER_FRAME, _update);
	}

	var _times:Array<Float> = [];
	var _memPeak:UInt = 0;

	var _flxText:FlxText;
	var _text:String = '';

	// display info
	var _displayFps = true;
	var _displayMemory = true;

	// Event Handlers
	function _update(_:Event):Void
	{
		var lastText = _text;

		var now:Float = Timer.stamp();
		_times.push(now);
		while (_times[0] < now - 1)
			_times.shift();

		var mem = System.totalMemory;
		if (mem > _memPeak)
			_memPeak = mem;

		if (visible)
		{
			_text = '' // set up the text itself
				+ (_displayFps ? _times.length + " FPS\n" : '') // Framerate
				+ (_displayMemory ? '${_getInterval(mem)} / ${_getInterval(_memPeak)}\n' : ''); // Current and Total Memory Usage
		}

		if (lastText != _text)
		{
			_flxText.text = _text;
			_flxText.updateHitbox();
			_updateBitmap();
		}
	}

	function _updateBitmap()
	{
		bitmapData = _flxText.pixels;
	}
}

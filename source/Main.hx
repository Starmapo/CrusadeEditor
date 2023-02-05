package;

import flixel.FlxGame;
import flixel.FlxState;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import states.*;
import ui.FPS;

using StringTools;

#if CRASH_HANDLER
import haxe.CallStack;
import haxe.io.Path;
import lime.app.Application;
import lime.utils.Log;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;
#end

class Main extends Sprite
{
	public static var game:FlxGame;
	public static var fps:FPS;

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	static var _gameWidth:Int = 1280; // Width of the game in pixels.
	static var _gameHeight:Int = 720; // Height of the game in pixels.
	static var _initialState:Class<FlxState> = BootState; // The FlxState the game starts with.
	static var _framerate:Int = 60; // How many frames per second the game should run at.
	static var _skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	static var _startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	public function new()
	{
		#if CRASH_HANDLER
		Log.throwErrors = false;
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, _onCrash);
		#end

		super();

		if (stage != null)
			_init();
		else
			addEventListener(Event.ADDED_TO_STAGE, _init);
	}

	function _init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, _init);

		game = new FlxGame(_gameWidth, _gameHeight, _initialState, _framerate, _framerate, _skipSplash, _startFullscreen);
		addChild(game);

		fps = new FPS(2, 2, FlxColor.WHITE);
		fps.visible = false;
		addChild(fps);

		stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent)
		{
			switch (e.keyCode)
			{
				case Keyboard.F5:
					fps.visible = !fps.visible;
				case Keyboard.F11:
					FlxG.fullscreen = !FlxG.fullscreen;
			}
		});
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if CRASH_HANDLER
	function _onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "PsychEngine_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ", column " + column + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error + "\n\n> Crash Handler written by: sqirra-rng";

		e.stopImmediatePropagation();
		e.stopPropagation();
		e.preventDefault();

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		Application.current.window.alert(errMsg);
		Sys.exit(1);
	}
	#end
}

package states;

import flixel.FlxState;
import flixel.util.FlxStringUtil;
import lime.app.Application;
import sys.FileSystem;
import systools.Dialogs;

class BootState extends FlxState
{
	override public function create()
	{
		super.create();

		FlxG.game.focusLostFramerate = 60;
		FlxG.fixedTimestep = false;
		FlxG.mouse.useSystemCursor = true;
		#if !html5
		FlxG.keys.preventDefaultKeys = [TAB];
		#end

		if (FlxStringUtil.isNullOrEmpty(FlxG.save.data.gameDirectory) || !FileSystem.exists(FlxG.save.data.gameDirectory))
		{
			var result:String = Dialogs.folder("Select your game directory:", "");
			if (!FlxStringUtil.isNullOrEmpty(result) && FileSystem.exists(result))
			{
				Util.changeDirectory(result);
			}
			else
			{
				Application.current.window.alert('It seems you didn\'t choose a directory. Please select one.', 'Error');
				Sys.exit(1);
			}
		}
		else
		{
			Util.changeDirectory(FlxG.save.data.gameDirectory);
		}

		FlxG.switchState(new CSSEditorState());
	}
}

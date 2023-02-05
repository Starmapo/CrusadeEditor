import data.CharacterData;
import flixel.FlxObject;
import flixel.math.FlxMath;
import haxe.io.Path;
import lime.utils.AssetLibrary;
import lime.utils.AssetType;
import lime.utils.Assets;
import sys.FileSystem;

using StringTools;

class Util
{
	// maximum vertical bounds for the roster
	// for horizontal bounds, x is 0 and width is 1280 (FlxG.width), so I won't bother putting them here
	public static final CSS_Y:Int = 42;
	public static final CSS_HEIGHT:Int = 500;
	public static final SOUND_EXTENSIONS:Array<String> = ["ogg", "mp3", "wav"];

	// whether the game directory is CMC+
	public static var usingCMCPlus:Bool = false;

	public static var slotWidth:Int = 64;
	public static var slotHeight:Int = 64;

	public static function centerInBounds(object:FlxObject, x:Float = 0, y:Float = 0, width:Float = 100, height:Float = 100)
	{
		object.setPosition(x + ((width - object.width) / 2), y + ((height - object.height) / 2));
		return object;
	}

	public static function getSplitText(text:String)
	{
		var splitText = text.split('\n');
		for (i in 0...splitText.length)
			splitText[i] = splitText[i].trim(); // need to trim them so CRLF isn't counted
		return splitText;
	}

	public static function assetsListByPrefix(prefix:String = '', ?type:AssetType)
	{
		var items = [];

		@:privateAccess
		for (library in Assets.libraries)
		{
			var libraryItems = libraryListByPrefix(library, prefix, type);

			if (libraryItems != null)
			{
				items = items.concat(libraryItems);
			}
		}

		return items;
	}

	public static function libraryListByPrefix(library:AssetLibrary, prefix:String = '', type:String)
	{
		var requestedType = type != null ? cast(type, AssetType) : null;
		var items = [];

		@:privateAccess
		for (id in library.types.keys())
		{
			if ((requestedType == null || library.exists(id, type)) && id.startsWith(prefix))
			{
				items.push(id);
			}
		}

		return items;
	}

	public static function playMusic()
	{
		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			var music:Array<String> = [];
			var path = Paths.crusadePath('music/css/');
			if (FileSystem.exists(path))
			{
				for (file in FileSystem.readDirectory(path))
				{
					var fileExt = Path.extension(file);
					if (SOUND_EXTENSIONS.contains(fileExt))
					{
						music.push(file);
					}
				}
			}
			if (music.length > 0)
			{
				var chosenMusic = FlxG.random.getObject(music);
				var musicPath = Path.join(['music/css/', chosenMusic]);
				FlxG.sound.playMusic(Paths.crusadeSound(musicPath));

				if (chosenMusic.contains('__'))
				{
					var musicData = Path.withoutExtension(chosenMusic).split('__')[1].split('_');
					// idk if it can even be a float, but just in case
					var startTime = Std.parseFloat(musicData[0]);
					var endTime = Std.parseFloat(musicData[1]);
					var loopTime = FlxMath.remapToRange(startTime, 0, endTime, 0, FlxG.sound.music.length);
					FlxG.sound.music.loopTime = loopTime;
				}
				else
				{
					FlxG.sound.music.loopTime = 0;
				}
			}
		}
	}

	public static function changeDirectory(directory:String)
	{
		FlxG.save.data.gameDirectory = directory;
		FlxG.save.flush();
		// yes, this is the best way I found to detect if it's a CMC+ build
		// I can't search for an "arcade" or "sticker" or "data/dats" folder since versions before V7 don't have them
		Util.usingCMCPlus = FileSystem.exists(Path.join([directory, 'binmaker.exe']));
		CharacterData.reloadCharacters();
	}
}

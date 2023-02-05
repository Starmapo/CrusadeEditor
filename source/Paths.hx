import haxe.io.Path;
import openfl.display.BitmapData;
import openfl.media.Sound;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class Paths
{
	public static inline function crusadePath(key:String)
	{
		return Path.join([FlxG.save.data.gameDirectory, key]);
	}

	public static function crusadeImage(key:String)
	{
		// if key doesn't end with an extension, add it
		if (!key.endsWith('.png'))
			key += '.png';

		var path = crusadePath(key);
		if (FlxG.bitmap.checkCache(path))
			return FlxG.bitmap.get(path);
		if (FileSystem.exists(path))
		{
			var bitmap = BitmapData.fromFile(path);
			if (bitmap != null)
			{
				var graphic = FlxG.bitmap.add(bitmap, false, path);
				return graphic;
			}
		}

		trace('couldn\'t find image: $path');
		return null;
	}

	// Warning: You must add the file extension yourself!
	public static function crusadeData(key:String)
	{
		var path = crusadePath(key);
		if (FileSystem.exists(path))
			return File.getContent(path);

		trace('couldn\'t find data: $path');
		return null;
	}

	// Warning: You must add the file extension yourself!
	public static function crusadeSound(key:String)
	{
		var path = crusadePath(key);
		if (FileSystem.exists(path))
			return Sound.fromFile(path);

		trace('couldn\'t find sound: $path');
		return null;
	}
}

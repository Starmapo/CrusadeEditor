package sprites;

import data.CharacterData;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import sys.FileSystem;

class CharacterSlot extends FlxSpriteGroup
{
	public var char(default, set):String = null;
	public var charID:Int = 0;
	public var row:Int = 0;
	public var column:Int = 0;
	public var mugshot:FlxSprite;

	public function new(x:Float = 0, y:Float = 0, char:String = '', scale:Float = 1)
	{
		super(x, y);

		_bg = _makeSprite(0, 0, Paths.crusadeImage('gfx/mugs/slot_bg'), scale);
		_bg.clipRect = FlxRect.get(0, 0, 63, 63);

		mugshot = _makeSprite(2, 2, null, scale);
		mugshot.clipRect = FlxRect.get(0, 0, 61, 61);

		_border = _makeSprite(0, 0, Paths.crusadeImage('gfx/mugs/slot'), scale);

		add(_bg);
		add(mugshot);
		add(_border);

		active = false;

		this.char = char;
	}

	var _bg:FlxSprite;
	var _border:FlxSprite;

	function _makeSprite(x:Float = 0, y:Float = 0, graphic:FlxGraphicAsset, scale:Float = 1)
	{
		var sprite = new FlxSprite(x * scale, y * scale).loadGraphic(graphic);
		sprite.antialiasing = true;
		sprite.scale.set(scale, scale);
		sprite.updateHitbox();
		return sprite;
	}

	function set_char(value:String)
	{
		if (char != value)
		{
			char = value;
			if (CharacterData.characters.exists(char))
				charID = CharacterData.characters.get(char).id;
			else if (char == 'random')
				charID = 9999; // stupid fix
			else
				charID = 0;

			var mugshotGraphic = null;
			if (char.length > 0 && FileSystem.exists(Paths.crusadePath('gfx/mugs/$char.png')))
				mugshotGraphic = Paths.crusadeImage('gfx/mugs/$char');
			if (mugshotGraphic == null)
				mugshotGraphic = FlxG.bitmap.create(61, 61, FlxColor.TRANSPARENT);
			mugshot.loadGraphic(mugshotGraphic);
			mugshot.updateHitbox();

			alpha = (charID > 0 ? 1 : 0.00001);
		}
		return value;
	}
}

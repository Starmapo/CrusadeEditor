package sprites;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;

class ContextMenu extends FlxTypedSpriteGroup<ContextMenuOption>
{
	public var options:Array<String> = [];
	public var callback:String->Void;

	public function new(x:Float = 0, y:Float = 0, ?options:Array<String>)
	{
		super(x, y);

		scrollFactor.set();

		changeOptions(options);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (visible)
		{
			for (option in members)
			{
				var overlap = false;
				for (camera in cameras)
				{
					if (option.overlapsPoint(FlxG.mouse.getWorldPosition(camera, _point), true, camera))
					{
						overlap = true;
						if (FlxG.mouse.justPressed)
						{
							if (callback != null)
								callback(option.option);
							visible = false;
						}
						break;
					}
				}

				option.setSelected(overlap);
			}
		}
	}

	public function changeOptions(options:Array<String>)
	{
		if (!FlxArrayUtil.equals(this.options, options))
		{
			this.options = options;

			destroyMembers();
			if (options != null && options.length > 0)
			{
				var curY:Float = 0;
				var maxWidth:Float = 1;
				for (i in 0...options.length)
				{
					var option = new ContextMenuOption(0, curY, options[i]);
					add(option);
					if (option.width > maxWidth)
						maxWidth = option.width;
					curY += option.height;
				}
				if (length > 1)
				{
					for (i in 0...length)
						members[i].resize(maxWidth);
				}
			}
		}
	}

	public function showAt(x:Float, y:Float)
	{
		setPosition(x, y);
		if (x + width > FlxG.width)
			this.x = x - width;
		if (y + height > FlxG.height)
			this.y = y - height;
		visible = true;
	}
}

// I think i'm using too many sprite groups
class ContextMenuOption extends FlxSpriteGroup
{
	public var option:String = '';

	public function new(x:Float = 0, y:Float = 0, option:String)
	{
		super(x, y);
		this.option = option;

		_text = new FlxText(0, 0, 0, option);
		_bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		// _bg.alpha = 0.5;
		resize(_text.width);

		add(_bg);
		add(_text);

		active = false;
		scrollFactor.set();
	}

	public function resize(width:Float)
	{
		_bg.setGraphicSize(Std.int(width), Std.int(_text.height));
		_bg.updateHitbox();
	}

	public function setSelected(selected:Bool)
	{
		if (selected)
		{
			_bg.makeGraphic(1, 1, FlxColor.WHITE);
			_text.color = FlxColor.BLACK;
		}
		else
		{
			_bg.makeGraphic(1, 1, FlxColor.BLACK);
			_text.color = FlxColor.WHITE;
		}
	}

	var _bg:FlxSprite;
	var _text:FlxText;
}

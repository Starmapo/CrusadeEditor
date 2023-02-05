package states;

import data.CharacterData;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.ui.FlxUIText;
import flixel.util.FlxColor;
import ibwwg.FlxScrollableArea;
import sprites.CharacterSlot;

class ChooseCharacterSubState extends FlxSubState
{
	public function new(?exclude:Array<String>, ?callback:Character->Void)
	{
		super();
		if (exclude == null)
			exclude = [];
		_callback = callback;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.8;
		bg.scrollFactor.set();
		add(bg);

		var characterList:Array<Character> = [];
		var curY:Float = 0;
		for (name => char in CharacterData.characters)
		{
			if (!CharacterData.characterLock.contains(name) && !exclude.contains(name))
			{
				characterList.push(char);
			}
		}
		characterList.sort(function(a, b)
		{
			var a = a.bustName.toLowerCase();
			var b = b.bustName.toLowerCase();
			if (a < b)
				return -1;
			if (a > b)
				return 1;
			return 0;
		});
		characterList.unshift(CharacterData.characterIDs.get(9999));
		for (char in characterList)
		{
			var item = new CharacterItem(0, curY, char);
			_items.add(item);
			curY += item.height + 5;
		}

		_scrollableArea = new FlxScrollableArea(FlxRect.get(0, 0, FlxG.width, FlxG.height * 0.9), _items.getHitbox(), FIT_WIDTH, -1, FlxColor.GRAY, this, 20);
		trace(_scrollableArea.content, _scrollableArea.viewPort);
		FlxG.cameras.add(_scrollableArea, false);

		_items.cameras = [_scrollableArea];

		add(_items);

		var text = new FlxUIText(0, FlxG.height, FlxG.width, 'Click on an icon to select a character. Press ESCAPE to cancel.');
		text.y -= text.height;
		add(text);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE)
		{
			close();
			return;
		}
		if (FlxG.mouse.justPressed)
		{
			for (item in _items)
			{
				var icon = item.icon;
				if (icon.overlapsPoint(FlxG.mouse.getWorldPosition(_scrollableArea, FlxPoint.weak()), true, _scrollableArea))
				{
					if (_callback != null)
						_callback(CharacterData.characters.get(icon.char));
					close();
					return;
				}
			}
		}
	}

	override function destroy()
	{
		super.destroy();
		FlxG.cameras.remove(_scrollableArea);
	}

	var _callback:Character->Void;
	var _items:FlxTypedSpriteGroup<CharacterItem> = new FlxTypedSpriteGroup();
	var _scrollableArea:FlxScrollableArea;
}

class CharacterItem extends FlxSpriteGroup
{
	public var icon:CharacterSlot;

	public function new(x:Float = 0, y:Float = 0, char:Character)
	{
		super(x, y);

		icon = new CharacterSlot(0, 0, char.name);

		_nameText = new FlxText(icon.width + 5, icon.height / 2, 0, char.bustName, 16);
		_nameText.y -= _nameText.height / 2;

		_filenameText = new FlxText(_nameText.x + _nameText.width + 5, _nameText.y + _nameText.height, 0, '(' + char.name + ')', 8);
		_filenameText.y -= _filenameText.height + 4;

		add(icon);
		add(_nameText);
		add(_filenameText);

		active = false;
	}

	var _nameText:FlxText;
	var _filenameText:FlxText;
}

package sprites;

import data.CharacterData;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxStringUtil;

using StringTools;

// This is a cry for help, someone please help me figure out why this is constantly increasing memory
class CSS extends FlxTypedSpriteGroup<CharacterSlot>
{
	public static function getRosterScale(rosterRows:Array<String>)
	{
		var rows = rosterRows.length;
		var columns = 0;
		for (i in 0...rows)
		{
			var rowColumns = rosterRows[i].split(' ').length;
			if (rowColumns > columns)
				columns = rowColumns;
		}
		var rosterScaleX = FlxG.width / (columns * Util.slotWidth);
		var rosterScaleY = Util.CSS_HEIGHT / (rows * Util.slotHeight);
		return Math.min(rosterScaleX, rosterScaleY);
	}

	public var cssScale:Float = 1;
	public var rows:Int = 2;
	public var columns:Int = 1;

	public function new(x:Float = 0, y:Float = 0, roster:String = '')
	{
		super(x, y);
		active = false;
		scrollFactor.set();
		loadFromRoster(roster);
	}

	public function loadFromRoster(roster:String)
	{
		destroyMembers();

		if (!FlxStringUtil.isNullOrEmpty(roster))
		{
			roster = roster.trim();
			var rosterRows = roster.split('\n');
			cssScale = getRosterScale(rosterRows);
			rows = rosterRows.length;
			columns = 0;

			var curX:Float = 0;
			var curY:Float = 0;
			var index:Int = 0;
			var row:Array<String>;
			var id:String = '';
			var intID:Null<Int> = 0;
			for (i in 0...rosterRows.length)
			{
				if (!FlxStringUtil.isNullOrEmpty(rosterRows[i]))
				{
					row = rosterRows[i].split(' ');
					curX = 0;
					if (row.length > columns)
						columns = row.length;
					for (j in 0...row.length)
					{
						id = row[j];
						if (!FlxStringUtil.isNullOrEmpty(id))
						{
							intID = Std.parseInt(id);
							if (intID != null && CharacterData.characterIDs.exists(intID))
							{
								var charSlot = new CharacterSlot(curX, curY, CharacterData.characterIDs.get(intID).name, cssScale);
								charSlot.ID = index;
								charSlot.row = i;
								charSlot.column = j;
								add(charSlot);
							}
						}
						curX += Util.slotWidth * cssScale;
						if (j < row.length - 1)
							index++;
					}
				}
				curY += Util.slotHeight * cssScale;
				index++;
			}
		}
	}

	public function moveIcon(id:Int, pos:Int)
	{
		if (id != pos && id < members.length && pos < members.length)
		{
			var charName:String = members[id].char;
			if (id < pos)
			{
				for (i in id...pos)
				{
					members[i].char = members[i + 1].char;
				}
			}
			else
			{
				var i = id;
				while (i > pos)
				{
					members[i].char = members[i - 1].char;
					i--;
				}
			}
			members[pos].char = charName;
		}
	}

	public function swapIcons(id1:Int, id2:Int)
	{
		if (id1 != id2 && id1 < members.length && id2 < members.length)
		{
			var firstChar = members[id1].char;
			members[id1].char = members[id2].char;
			members[id2].char = firstChar;
		}
	}

	public function cssString()
	{
		var output = '';
		var row = 0;
		for (slot in members)
		{
			var id = Std.string(slot.charID);
			while (id.length < 4)
				id = '0' + id;
			output += id;
			if (slot.column == columns - 1)
			{
				if (row < rows - 1)
				{
					output += '\r\n';
					row++;
				}
			}
			else
				output += ' ';
		}
		return output;
	}

	public function addRow()
	{
		var roster = cssString() + '\n';
		for (i in 0...columns)
		{
			roster += '0000 ';
		}
		loadFromRoster(roster);
	}

	public function addColumn()
	{
		var splitRoster = cssString().split('\n');
		for (i in 0...splitRoster.length)
		{
			splitRoster[i] = splitRoster[i].trim() + ' 0000';
		}
		var roster = splitRoster.join('\n');
		loadFromRoster(roster);
	}

	public function removeRow()
	{
		var splitRoster = cssString().split('\n');
		FlxArrayUtil.setLength(splitRoster, splitRoster.length - 1);
		var roster = splitRoster.join('\n');
		loadFromRoster(roster);
	}

	public function removeColumn()
	{
		var splitRoster = cssString().split('\n');
		for (i in 0...splitRoster.length)
		{
			if (splitRoster[i].length >= 4)
				splitRoster[i] = splitRoster[i].substr(0, splitRoster[i].length - 4).trim();
		}
		var roster = splitRoster.join('\n');
		loadFromRoster(roster);
	}

	public function getCharacters()
	{
		var characters:Array<String> = [];
		for (slot in members)
		{
			if (slot.char.length > 0 && slot.char != 'random' && !characters.contains(slot.char))
				characters.push(slot.char);
		}
		return characters;
	}

	public function clearSlot(id:Int)
	{
		members[id].char = '';
	}

	public function removeSlot(id:Int)
	{
		for (i in id...length)
		{
			if (members[i + 1] != null)
			{
				members[i].char = members[i + 1].char;
			}
			else
			{
				members[i].char = '';
			}
		}
	}
}
